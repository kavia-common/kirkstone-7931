# Matter POC on RPi4 (Thread + optional Wi‑Fi)

This POC adds minimal Yocto-native tweaks to enable reliable commissioning using OTBR on Raspberry Pi 4:
- Deterministic `wpan0` bring-up before `otbr-agent`
- POC env at `/etc/matter/poc.env`
- Storage created at `/var/lib/matter` via tmpfiles
- chip-tool wrapper `/usr/bin/chip-tool-poc`
- Optional demo units for lighting/all-clusters apps (disabled by default)

Services/ordering:
- wpan0-setup.service (oneshot, Before=otbr-agent.service)
- otbr-agent.service (After=network-online.target)
- otbr-web.service (After=otbr-agent.service)
- matter-demo.target (Wants=otbr-agent.service otbr-web.service)

Commissioning quickstart:
1) Ensure backhaul (default eth0) has internet and IPv6. Adjust `/etc/matter/poc.env` if using wlan0.
2) Reboot or start services:
   systemctl status wpan0-setup otbr-agent otbr-web
3) For Thread-only device (Aqara LED Bulb T2):
   - Put bulb into pairing mode per vendor docs.
   - Use chip-tool:
     chip-tool-poc pairing open-commissioning-window 1234 300
   - For QR/manual codes, use vendor-provided pairing code; do NOT hardcode in wrapper.
4) For Wi‑Fi device:
   - Commission via BLE + Wi‑Fi creds (example):
     chip-tool-poc pairing ble-wifi <node-id> <ssid> <pass> 20202021 3840
5) Reset storage if needed:
   matter-factory-reset

Notes:
- POC only; no production security, telemetry, or TR-181 integration.
- Avahi is enabled automatically if present to support mDNS.
- IPv6 forwarding is enabled via sysctl for border routing.

Logs to inspect:
- journalctl -u wpan0-setup -u otbr-agent -u otbr-web
- ot-ctl state
- ip -6 route; sysctl net.ipv6.conf.all.forwarding
