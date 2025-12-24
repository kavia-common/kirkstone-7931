FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " file://99-matter-poc.conf "

do_install:append() {
    install -d ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/99-matter-poc.conf ${D}${sysconfdir}/sysctl.d/99-matter-poc.conf
}

FILES:${PN} += " ${sysconfdir}/sysctl.d/99-matter-poc.conf "
