# POC: ensure avahi-daemon enabled, reflect IPv6, disable wide-area, and order after network-online

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    # Default daemon config if none installed yet
    install -d ${D}${sysconfdir}/avahi
    if [ ! -f ${D}${sysconfdir}/avahi/avahi-daemon.conf ]; then
        install -m 0644 ${WORKDIR}/avahi-daemon.conf ${D}${sysconfdir}/avahi/avahi-daemon.conf
    else
        sed -i 's/^#\?enable-wide-area=.*/enable-wide-area=no/' ${D}${sysconfdir}/avahi/avahi-daemon.conf || true
        sed -i 's/^#\?reflect-ipv6=.*/reflect-ipv6=yes/' ${D}${sysconfdir}/avahi/avahi-daemon.conf || true
    fi

    # systemd ordering drop-in
    install -d ${D}${systemd_system_unitdir}/avahi-daemon.service.d
    install -m 0644 ${WORKDIR}/avahi-daemon.service.d-override.conf ${D}${systemd_system_unitdir}/avahi-daemon.service.d/override.conf
}

FILES:${PN}-daemon += " ${systemd_system_unitdir}/avahi-daemon.service.d/override.conf ${sysconfdir}/avahi/avahi-daemon.conf "
