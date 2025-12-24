Matter POC commissioning demo
- Ensure network backhaul (eth0 preferred).
- wpan0 setup and OTBR services should start at boot.
  Check: systemctl status wpan0-setup otbr-agent otbr-web
- Use chip-tool-poc for commissioning:
  Example Wi‑Fi:
    chip-tool-poc pairing ble-wifi 1 MySSID MyPass 20202021 3840
  Example Thread:
    Use vendor pairing code (QR/manual) for Aqara LED Bulb T2.

Verification:
- ot-ctl state
- chip-tool-poc pairing credentials/status commands
- mDNS browse:
  avahi-browse -rt _matter._tcp

Reset:
- matter-factory-reset
