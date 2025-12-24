# Recommend POC helpers and mDNS daemon if available
IMAGE_INSTALL:append = " matter-poc otbr otbr-web avahi-daemon chip-tool"

RRECOMMENDS:${PN} += " otbr otbr-web avahi-daemon chip-tool"

SYSTEMD_AUTO_ENABLE:append = " wpan0-setup.service otbr-requires-network.service"

# Do not auto-enable app demos; dataset import is conditioned by file existence.
IMAGE_INSTALL:append = " avahi-daemon"
