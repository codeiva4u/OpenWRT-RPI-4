#!/bin/sh

# Enable AdGuard Home
uci set adguardhome.global.enabled '1'

# Disable dnsmasq to avoid port conflicts
uci set dhcp.@dnsmasq[0].port='0'

# Set AdGuard Home as the primary DNS resolver
uci -q delete dhcp.@dnsmasq[0].server
uci add_list dhcp.@dnsmasq[0].server='127.0.0.1#5353'

# Add a firewall rule to redirect all DNS traffic to AdGuard Home
# This ensures all devices on the network use AdGuard, even if they have a hardcoded DNS
uci set firewall.adguard_dns_rule=rule
uci set firewall.adguard_dns_rule.name='AdGuard_DNS_Redirect'
uci set firewall.adguard_dns_rule.src='lan'
uci set firewall.adguard_dns_rule.proto='tcp udp'
uci set firewall.adguard_dns_rule.src_dport='53'
uci set firewall.adguard_dns_rule.dest_ip='127.0.0.1'
uci set firewall.adguard_dns_rule.dest_port='5353'
uci set firewall.adguard_dns_rule.target='DNAT'

# Commit all changes
uci commit dhcp
uci commit firewall

# Reload services
/etc/init.d/dnsmasq restart
/etc/init.d/firewall reload

exit 0