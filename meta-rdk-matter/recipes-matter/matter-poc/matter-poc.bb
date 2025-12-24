SUMMARY = "Matter POC helpers: env, tmpfiles, wrappers, demo units"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=86d3f3a95c324c9479bd8986968f4327"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
  file://poc.env \
  file://matter.conf \
  file://chip-tool-poc \
  file://matter-factory-reset \
  file://lighting-app@.service \
  file://all-clusters-app@.service \
  file://matter-demo.target \
"

RDEPENDS:${PN} += "bash"

do_install() {
    # Env file
    install -d ${D}${sysconfdir}/matter
    install -m 0644 ${WORKDIR}/poc.env ${D}${sysconfdir}/matter/poc.env

    # tmpfiles for storage dir
    install -d ${D}${libdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/matter.conf ${D}${libdir}/tmpfiles.d/matter.conf

    # Wrappers
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/chip-tool-poc ${D}${bindir}/chip-tool-poc
    install -m 0755 ${WORKDIR}/matter-factory-reset ${D}${bindir}/matter-factory-reset

    # Systemd demo units (not enabled by default)
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/lighting-app@.service ${D}${systemd_system_unitdir}/lighting-app@.service
    install -m 0644 ${WORKDIR}/all-clusters-app@.service ${D}${systemd_system_unitdir}/all-clusters-app@.service
    install -m 0644 ${WORKDIR}/matter-demo.target ${D}${systemd_system_unitdir}/matter-demo.target
}

SYSTEMD_SERVICE:${PN} = "matter-demo.target"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILES:${PN} += " \
  ${sysconfdir}/matter/poc.env \
  ${libdir}/tmpfiles.d/matter.conf \
  ${bindir}/chip-tool-poc \
  ${bindir}/matter-factory-reset \
  ${systemd_system_unitdir}/lighting-app@.service \
  ${systemd_system_unitdir}/all-clusters-app@.service \
  ${systemd_system_unitdir}/matter-demo.target \
"
