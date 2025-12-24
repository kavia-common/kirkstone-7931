SUMMARY = "Matter POC helpers: env, tmpfiles, wrappers, demo units"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=86d3f3a95c324c9479bd8986968f4327"

inherit systemd sysusers

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
  file://poc.env \
  file://matter.conf \
  file://chip-tool-poc \
  file://matter-factory-reset \
  file://lighting-app@.service \
  file://all-clusters-app@.service \
  file://matter-demo.target \
  file://matter-poc-healthcheck \
  file://matter-poc-healthcheck.service \
  file://matter.conf \
"

RDEPENDS:${PN} += "bash avahi-utils wpan-tools"

do_install() {
    # Env file
    install -d ${D}${sysconfdir}/matter
    install -m 0644 ${WORKDIR}/poc.env ${D}${sysconfdir}/matter/poc.env

    # tmpfiles for storage dir (common matter dirs)
    install -d ${D}${libdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/matter.conf ${D}${libdir}/tmpfiles.d/matter.conf

    # Wrappers and helpers
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/chip-tool-poc ${D}${bindir}/chip-tool-poc
    install -m 0755 ${WORKDIR}/matter-factory-reset ${D}${bindir}/matter-factory-reset

    # Healthcheck
    install -m 0755 ${WORKDIR}/matter-poc-healthcheck ${D}${bindir}/matter-poc-healthcheck
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/matter-poc-healthcheck.service ${D}${systemd_system_unitdir}/matter-poc-healthcheck.service

    # Systemd demo targets (disabled by default)
    install -m 0644 ${WORKDIR}/lighting-app@.service ${D}${systemd_system_unitdir}/lighting-app@.service
    install -m 0644 ${WORKDIR}/all-clusters-app@.service ${D}${systemd_system_unitdir}/all-clusters-app@.service
    install -m 0644 ${WORKDIR}/matter-demo.target ${D}${systemd_system_unitdir}/matter-demo.target

    # sysusers
    install -d ${D}${sysconfdir}/sysusers.d
    install -m 0644 ${WORKDIR}/matter.conf ${D}${sysconfdir}/sysusers.d/matter.conf
}

SYSTEMD_SERVICE:${PN} = "matter-demo.target matter-poc-healthcheck.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILES:${PN} += " \
  ${sysconfdir}/matter/poc.env \
  ${libdir}/tmpfiles.d/matter.conf \
  ${bindir}/chip-tool-poc \
  ${bindir}/matter-factory-reset \
  ${bindir}/matter-poc-healthcheck \
  ${systemd_system_unitdir}/matter-poc-healthcheck.service \
  ${systemd_system_unitdir}/lighting-app@.service \
  ${systemd_system_unitdir}/all-clusters-app@.service \
  ${systemd_system_unitdir}/matter-demo.target \
  ${sysconfdir}/sysusers.d/matter.conf \
"
