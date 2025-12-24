FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RRECOMMENDS:${PN} += "matter-poc"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}/chip-all-clusters-app.service.d
    install -m 0644 ${WORKDIR}/chip-all-clusters-app.service.d-override.conf ${D}${systemd_system_unitdir}/chip-all-clusters-app.service.d/override.conf

    install -d ${D}${sysconfdir}/tmpfiles.d
    if [ -f ${D}${sysconfdir}/tmpfiles.d/matter.conf ]; then
        echo 'd /var/lib/matter/chip-all-clusters-app 0750 matter matter - -' >> ${D}${sysconfdir}/tmpfiles.d/matter.conf
    else
        echo 'd /var/lib/matter/chip-all-clusters-app 0750 matter matter - -' > ${D}${sysconfdir}/tmpfiles.d/matter-all-clusters.conf
    fi
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/chip-all-clusters-app.service.d/override.conf \
    ${sysconfdir}/tmpfiles.d/matter-all-clusters.conf \
"
