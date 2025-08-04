#!/bin/sh

# Function to log messages
log() {
    echo "$1" >> /var/log/custom_setup.log
}

log "Starting custom network configuration script..."

# Clear existing network, wireless, firewall, and mwan3 configs to start fresh
uci -q batch <<EOF
delete network
delete wireless
delete firewall
delete mwan3
EOF

log "Cleared existing configurations."

# --- LAN Configuration ---
uci -q batch <<EOF
# Explicitly define the LAN bridge device and add eth0 to it.
# The wireless AP will be bridged later by setting its network to 'lan'.
set network.lan_bridge=device
set network.lan_bridge.type='bridge'
set network.lan_bridge.name='br-lan'
list network.lan_bridge.ports 'eth0'

# Configure the 'lan' interface on top of the bridge.
set network.lan=interface
set network.lan.proto='static'
set network.lan.device='br-lan'
set network.lan.ipaddr='192.168.1.1'
set network.lan.netmask='255.255.255.0'
set network.lan.ip6assign='60'

set network.globals=globals
set network.globals.ula_prefix='auto'
EOF
log "LAN interface configured."

# --- WAN Interface Definitions ---
# These interfaces will be managed by mwan3.

# 1. USB Tethering (e.g., usb0)
uci -q batch <<EOF
set network.wan_usb=interface
set network.wan_usb.proto='dhcp'
set network.wan_usb.device='usb0'
set network.wan_usb.metric='10'
EOF
log "WAN (USB Tethering) interface defined."

# 2. USB-to-Ethernet Adapter (e.g., eth1)
uci -q batch <<EOF
set network.wan_eth=interface
set network.wan_eth.proto='dhcp'
set network.wan_eth.device='eth1'
set network.wan_eth.metric='20'
EOF
log "WAN (USB-Ethernet) interface defined."

# 3. WiFi Client - POCO X6
uci -q batch <<EOF
set network.wan_wifi_poco=interface
set network.wan_wifi_poco.proto='dhcp'
set network.wan_wifi_poco.metric='30'
EOF
log "WAN (WiFi POCO) interface defined."

# 4. WiFi Client - OnePlus 7 Pro
uci -q batch <<EOF
set network.wan_wifi_oneplus=interface
set network.wan_wifi_oneplus.proto='dhcp'
set network.wan_wifi_oneplus.metric='40'
EOF
log "WAN (WiFi OnePlus) interface defined."


# --- Wireless Configuration ---
uci -q batch <<EOF
set wireless.radio0=wifi-device
set wireless.radio0.type='mac80211'
set wireless.radio0.path='platform/soc/fe300000.mmcnr/mmc_host/mmc1/mmc1:0001/mmc1:0001:1' # RPi 4/400/CM4
set wireless.radio0.channel='auto'
set wireless.radio0.band='2g'
set wireless.radio0.htmode='HT20'
set wireless.radio0.country='IN'

# LAN AP Configuration
set wireless.lan_ap=wifi-iface
set wireless.lan_ap.device='radio0'
set wireless.lan_ap.network='lan'
set wireless.lan_ap.mode='ap'
set wireless.lan_ap.ssid='OpenWrt-Custom'
set wireless.lan_ap.encryption='psk2'
set wireless.lan_ap.key='password123'

# WAN Client - POCO X6
set wireless.sta_poco=wifi-iface
set wireless.sta_poco.device='radio0'
set wireless.sta_poco.network='wan_wifi_poco'
set wireless.sta_poco.mode='sta'
set wireless.sta_poco.ssid='कौन सा POCO X6'
set wireless.sta_poco.encryption='psk2'
set wireless.sta_poco.key='00000000'

# WAN Client - OnePlus 7 Pro
set wireless.sta_oneplus=wifi-iface
set wireless.sta_oneplus.device='radio0'
set wireless.sta_oneplus.network='wan_wifi_oneplus'
set wireless.sta_oneplus.mode='sta'
set wireless.sta_oneplus.ssid='OnePlus 7 Pro'
set wireless.sta_oneplus.encryption='psk2'
set wireless.sta_oneplus.key='00000000'
EOF
log "Wireless configuration (AP and STA) completed."

# --- Firewall Configuration ---
uci -q batch <<EOF
set firewall.defaults=defaults
set firewall.defaults.input='ACCEPT'
set firewall.defaults.output='ACCEPT'
set firewall.defaults.forward='REJECT'
set firewall.defaults.syn_flood='1'

# LAN Zone
set firewall.lan_zone=zone
set firewall.lan_zone.name='lan'
set firewall.lan_zone.network='lan'
set firewall.lan_zone.input='ACCEPT'
set firewall.lan_zone.output='ACCEPT'
set firewall.lan_zone.forward='ACCEPT' # Allow forwarding from LAN to WAN

# WAN Zone
set firewall.wan_zone=zone
set firewall.wan_zone.name='wan'
set firewall.wan_zone.network='wan_usb wan_eth wan_wifi_poco wan_wifi_oneplus'
set firewall.wan_zone.input='REJECT'
set firewall.wan_zone.output='ACCEPT'
set firewall.wan_zone.forward='REJECT'
# IMPORTANT: No NAT/Masquerading as requested
set firewall.wan_zone.masq='0'
set firewall.wan_zone.mtu_fix='1'

# Forwarding Rule from LAN to WAN
set firewall.lan_to_wan=forwarding
set firewall.lan_to_wan.src='lan'
set firewall.lan_to_wan.dest='wan'
EOF
log "Firewall configured without NAT."

# --- MWAN3 Configuration ---
uci -q batch <<EOF
# Interface definitions for mwan3
set mwan3.wan_usb=interface
set mwan3.wan_usb.enabled='1'
set mwan3.wan_usb.family='ipv4'
set mwan3.wan_usb.track_ip='8.8.8.8' '8.8.4.4'
set mwan3.wan_usb.track_method='ping'

set mwan3.wan_eth=interface
set mwan3.wan_eth.enabled='1'
set mwan3.wan_eth.family='ipv4'
set mwan3.wan_eth.track_ip='8.8.8.8' '8.8.4.4'
set mwan3.wan_eth.track_method='ping'

set mwan3.wan_wifi_poco=interface
set mwan3.wan_wifi_poco.enabled='1'
set mwan3.wan_wifi_poco.family='ipv4'
set mwan3.wan_wifi_poco.track_ip='8.8.8.8' '8.8.4.4'
set mwan3.wan_wifi_poco.track_method='ping'

set mwan3.wan_wifi_oneplus=interface
set mwan3.wan_wifi_oneplus.enabled='1'
set mwan3.wan_wifi_oneplus.family='ipv4'
set mwan3.wan_wifi_oneplus.track_ip='8.8.8.8' '8.8.4.4'
set mwan3.wan_wifi_oneplus.track_method='ping'

# Member definitions
set mwan3.wan_usb_member=member
set mwan3.wan_usb_member.interface='wan_usb'
set mwan3.wan_usb_member.metric='10'
set mwan3.wan_usb_member.weight='1'

set mwan3.wan_eth_member=member
set mwan3.wan_eth_member.interface='wan_eth'
set mwan3.wan_eth_member.metric='20'
set mwan3.wan_eth_member.weight='1'

set mwan3.wan_wifi_poco_member=member
set mwan3.wan_wifi_poco_member.interface='wan_wifi_poco'
set mwan3.wan_wifi_poco_member.metric='30'
set mwan3.wan_wifi_poco_member.weight='1'

set mwan3.wan_wifi_oneplus_member=member
set mwan3.wan_wifi_oneplus_member.interface='wan_wifi_oneplus'
set mwan3.wan_wifi_oneplus_member.metric='40'
set mwan3.wan_wifi_oneplus_member.weight='1'

# Policy definitions
set mwan3.balanced_policy=policy
set mwan3.balanced_policy.use_member='wan_usb_member wan_eth_member wan_wifi_poco_member wan_wifi_oneplus_member'
set mwan3.balanced_policy.last_resort='unreachable'

# Default rule to use the balanced policy
set mwan3.default_rule=rule
set mwan3.default_rule.dest_ip='0.0.0.0/0'
set mwan3.default_rule.proto='all'
set mwan3.default_rule.use_policy='balanced_policy'
EOF
log "MWAN3 configuration for load balancing completed."

# Commit all changes
uci commit
log "UCI changes committed."

# Restart services to apply changes
log "Restarting services..."
/etc/init.d/network restart
/etc/init.d/firewall restart
/etc/init.d/mwan3 restart

log "Custom network setup finished."
exit 0