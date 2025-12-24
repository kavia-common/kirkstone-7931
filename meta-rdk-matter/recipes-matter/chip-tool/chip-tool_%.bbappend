# Ensure chip-tool POC env, KVS dir and service sourcing

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RRECOMMENDS:${PN} += "matter-poc"

do_install:append() {
    # Env file for chip-tool
    install -d ${D}${sysconfdir}/matter
    install -m 0644 ${WORKDIR}/chip-tool.env ${D}${sysconfdir}/matter/chip-tool.env

    # Ensure KVS directory exists at runtime using tmpfiles
    install -d ${D}${sysconfdir}/tmpfiles.d
    cat > ${D}${sysconfdir}/tmpfiles.d/matter.conf <<'EOF'
d /var/lib/matter 0750 matter matter - -
d /var/lib/matter/chip-tool 0750 matter matter - -
EOF

    # Ensure service file is installed (if base recipe provides it, we modify via file in layer)
    if [ -f ${WORKDIR}/chip-tool.service ]; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/chip-tool.service ${D}${systemd_system_unitdir}/chip-tool.service
    fi
}

FILES:${PN} += " \
    ${sysconfdir}/matter/chip-tool.env \
    ${sysconfdir}/tmpfiles.d/matter.conf \
    ${systemd_system_unitdir}/chip-tool.service \
"
