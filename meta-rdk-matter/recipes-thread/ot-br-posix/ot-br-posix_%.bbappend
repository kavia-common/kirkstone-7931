# Minimal POC tweaks for reliable OTBR bring-up on RPi4

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://otbr-agent-defaults \
    file://wpan0-setup.service \
    file://otbr-agent.service.d-override.conf \
    file://otbr-web.service.d-override.conf \
"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    # Defaults for otbr-agent
    install -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/otbr-agent-defaults ${D}${sysconfdir}/default/otbr-agent

    # Systemd drop-in overrides for ordering
    install -d ${D}${systemd_system_unitdir}/otbr-agent.service.d
    install -d ${D}${systemd_system_unitdir}/otbr-web.service.d
    install -m 0644 ${WORKDIR}/otbr-agent.service.d-override.conf ${D}${systemd_system_unitdir}/otbr-agent.service.d/override.conf
    install -m 0644 ${WORKDIR}/otbr-web.service.d-override.conf ${D}${systemd_system_unitdir}/otbr-web.service.d/override.conf

    # wpan0 setup oneshot
    install -m 0644 ${WORKDIR}/wpan0-setup.service ${D}${systemd_system_unitdir}/wpan0-setup.service
    # enable wpan0-setup to run at boot (does nothing if already commissioned)
    ln -sf ../wpan0-setup.service ${D}${systemd_system_multiuser_wants}/wpan0-setup.service || true
}

FILES:${PN} += " \
  ${sysconfdir}/default/otbr-agent \
  ${systemd_system_unitdir}/wpan0-setup.service \
  ${systemd_system_unitdir}/otbr-agent.service.d/override.conf \
  ${systemd_system_unitdir}/otbr-web.service.d/override.conf \
"
