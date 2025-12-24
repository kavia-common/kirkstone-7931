# Minimal POC tweaks for reliable OTBR bring-up on RPi4 with dataset import and network ordering

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://otbr-agent-defaults \
    file://wpan0-setup.service \
    file://otbr-agent.service.d-override.conf \
    file://otbr-web.service.d-override.conf \
    file://otbr-import-dataset.service \
    file://otbr-requires-network.service \
    file://90-wpan.rules \
    file://otbr.conf \
    file://wpan0-setup.service.d-override.conf \
"

RDEPENDS:${PN} += "wpan-tools"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    # Defaults for otbr-agent
    install -d ${D}${sysconfdir}/default
    if [ -f ${WORKDIR}/otbr-agent-defaults ]; then
        install -m 0644 ${WORKDIR}/otbr-agent-defaults ${D}${sysconfdir}/default/otbr-agent
    fi

    # Systemd drop-in overrides for ordering
    install -d ${D}${systemd_system_unitdir}/otbr-agent.service.d
    install -d ${D}${systemd_system_unitdir}/otbr-web.service.d
    if [ -f ${WORKDIR}/otbr-agent.service.d-override.conf ]; then
        install -m 0644 ${WORKDIR}/otbr-agent.service.d-override.conf ${D}${systemd_system_unitdir}/otbr-agent.service.d/override.conf
    fi
    if [ -f ${WORKDIR}/otbr-web.service.d-override.conf ]; then
        install -m 0644 ${WORKDIR}/otbr-web.service.d-override.conf ${D}${systemd_system_unitdir}/otbr-web.service.d/override.conf
    else
        cat > ${D}${systemd_system_unitdir}/otbr-web.service.d/override.conf <<'EOF'
[Unit]
Wants=otbr-agent.service network-online.target
After=otbr-agent.service network-online.target
EOF
    fi

    # wpan0 setup oneshot
    if [ -f ${WORKDIR}/wpan0-setup.service ]; then
        install -m 0644 ${WORKDIR}/wpan0-setup.service ${D}${systemd_system_unitdir}/wpan0-setup.service
        ln -sf ../wpan0-setup.service ${D}${systemd_system_multiuser_wants}/wpan0-setup.service || true
    fi

    # wpan0-setup drop-in for NCP explicit checks
    install -d ${D}${systemd_system_unitdir}/wpan0-setup.service.d
    install -m 0644 ${WORKDIR}/wpan0-setup.service.d-override.conf ${D}${systemd_system_unitdir}/wpan0-setup.service.d/override.conf

    # dataset import oneshot
    install -m 0644 ${WORKDIR}/otbr-import-dataset.service ${D}${systemd_system_unitdir}/otbr-import-dataset.service

    # network-online shim
    install -m 0644 ${WORKDIR}/otbr-requires-network.service ${D}${systemd_system_unitdir}/otbr-requires-network.service

    # udev rule for stable wpan0 and permissions
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/90-wpan.rules ${D}${sysconfdir}/udev/rules.d/90-wpan.rules

    # tmpfiles for otbr runtime dirs
    install -d ${D}${sysconfdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/otbr.conf ${D}${sysconfdir}/tmpfiles.d/otbr.conf
}

# Systemd integration
SYSTEMD_SERVICE:${PN} += " otbr-requires-network.service otbr-import-dataset.service"

FILES:${PN} += " \
  ${sysconfdir}/default/otbr-agent \
  ${systemd_system_unitdir}/wpan0-setup.service \
  ${systemd_system_unitdir}/wpan0-setup.service.d/override.conf \
  ${systemd_system_unitdir}/otbr-agent.service.d/override.conf \
  ${systemd_system_unitdir}/otbr-web.service.d/override.conf \
  ${systemd_system_unitdir}/otbr-import-dataset.service \
  ${systemd_system_unitdir}/otbr-requires-network.service \
  ${sysconfdir}/udev/rules.d/90-wpan.rules \
  ${sysconfdir}/tmpfiles.d/otbr.conf \
"
