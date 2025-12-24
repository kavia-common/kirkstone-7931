# Matter POC on RPi4

Validation checklist (POC)
1) First boot dataset import (if provided)
- Place Thread dataset at /etc/otbr/poc-dataset.hex in image or via scp
- Reboot once; verify import ran:
  journalctl -u otbr-import-dataset.service -b
  journalctl -u otbr-agent -b | tail -n 100
- If dataset missing, system boots without errors.

2) Network online and OTBR services
- Ensure services active:
  systemctl status otbr-requires-network otbr-agent otbr-web avahi-daemon
- Check wpan0 and dataset:
  ip link show wpan0
  wpanctl status
- Check IPv6 ULA on wpan0:
  ip -6 addr show dev wpan0 | grep fd

3) chip-tool persistence
- env file: /etc/matter/chip-tool.env
- storage dir: /var/lib/matter/chip-tool
- Example commissioning (Thread-only Aqara T2):
  chip-tool pairing onnetwork-long 12345 ${SETUP_PIN_CODE:-20202021} --commissioner-name poc --discriminator ${DISCRIMINATOR:-3840}
  chip-tool operationalcredentials add-fabric 1 0
  chip-tool onoff on 1 1
- For Wi‑Fi device (optional):
  chip-tool pairing onnetwork 12345 ${SETUP_PIN_CODE:-20202021}

4) Healthcheck
- Run:
  systemctl start matter-poc-healthcheck.service
  journalctl -u matter-poc-healthcheck -b

Useful logs
- journalctl -u wpan0-setup -u otbr-requires-network -u otbr-import-dataset -u otbr-agent -u otbr-web -u avahi-daemon -b
- avahi-browse -rt _matter._tcp

Notes
- Set OTBR_NCP_PATH in /etc/default/otbr-agent to match your hardware (/dev/ttyAMA0 typical on RPi4 when BT disabled).
- Services are ordered to avoid boot loops; warnings may be logged if uplink routes are not present yet. (Thread + optional Wi‑Fi)

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
