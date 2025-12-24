FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RRECOMMENDS:${PN} += "matter-poc"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}/chip-lighting-app.service.d
    install -m 0644 ${WORKDIR}/chip-lighting-app.service.d-override.conf ${D}${systemd_system_unitdir}/chip-lighting-app.service.d/override.conf

    # Append KVS dir creation to common matter tmpfiles if present; otherwise create our own file
    install -d ${D}${sysconfdir}/tmpfiles.d
    if [ -f ${D}${sysconfdir}/tmpfiles.d/matter.conf ]; then
        echo 'd /var/lib/matter/chip-lighting-app 0750 matter matter - -' >> ${D}${sysconfdir}/tmpfiles.d/matter.conf
    else
        echo 'd /var/lib/matter/chip-lighting-app 0750 matter matter - -' > ${D}${sysconfdir}/tmpfiles.d/matter-lighting.conf
    fi
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/chip-lighting-app.service.d/override.conf \
    ${sysconfdir}/tmpfiles.d/matter-lighting.conf \
"
