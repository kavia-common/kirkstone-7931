# Recommend POC helpers and mDNS daemon if available
IMAGE_INSTALL:append = " matter-poc"
IMAGE_INSTALL:append = " avahi-daemon"
