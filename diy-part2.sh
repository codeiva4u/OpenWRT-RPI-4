#!/bin/bash
# DIY Part 2 - Custom configuration and files setup
# कस्टम कॉन्फ़िगरेशन और फाइल सेटअप

echo "🔧 DIY Part 2: Applying custom configuration and files"

# Set default theme to argon
echo "🎨 Setting default theme to Argon"
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify default IP address if needed
echo "🌐 Setting default IP configuration"
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# Create files directory structure for custom files
echo "📁 Creating files directory structure"
mkdir -p files/etc/OpenWRT-RPI-4-main
mkdir -p files/etc/init.d
mkdir -p files/usr/bin

# Copy our custom scripts to the firmware
echo "📄 Copying custom configuration scripts"
if [ -f "${GITHUB_WORKSPACE}/ADVANCED-BRIDGE-99-network-config" ]; then
    cp "${GITHUB_WORKSPACE}/ADVANCED-BRIDGE-99-network-config" files/etc/OpenWRT-RPI-4-main/
    chmod +x files/etc/OpenWRT-RPI-4-main/ADVANCED-BRIDGE-99-network-config
fi

if [ -f "${GITHUB_WORKSPACE}/ENHANCED-MODE-99-network-selector" ]; then
    cp "${GITHUB_WORKSPACE}/ENHANCED-MODE-99-network-selector" files/etc/OpenWRT-RPI-4-main/
    chmod +x files/etc/OpenWRT-RPI-4-main/ENHANCED-MODE-99-network-selector
fi

if [ -f "${GITHUB_WORKSPACE}/mobile-hotspot-connect" ]; then
    cp "${GITHUB_WORKSPACE}/mobile-hotspot-connect" files/etc/OpenWRT-RPI-4-main/
    chmod +x files/etc/OpenWRT-RPI-4-main/mobile-hotspot-connect
fi

if [ -f "${GITHUB_WORKSPACE}/usb-tethering-detect" ]; then
    cp "${GITHUB_WORKSPACE}/usb-tethering-detect" files/etc/OpenWRT-RPI-4-main/
    chmod +x files/etc/OpenWRT-RPI-4-main/usb-tethering-detect
fi

if [ -f "${GITHUB_WORKSPACE}/AUTOSIZE-99-rootfs-resize" ]; then
    cp "${GITHUB_WORKSPACE}/AUTOSIZE-99-rootfs-resize" files/etc/OpenWRT-RPI-4-main/
    chmod +x files/etc/OpenWRT-RPI-4-main/AUTOSIZE-99-rootfs-resize
fi

# Copy older scripts for compatibility
for script in BRIDGE-MODE-99-network-config DUAL-MODE-99-network-selector FIXED-99-network-config; do
    if [ -f "${GITHUB_WORKSPACE}/$script" ]; then
        cp "${GITHUB_WORKSPACE}/$script" files/etc/OpenWRT-RPI-4-main/
        chmod +x files/etc/OpenWRT-RPI-4-main/$script
    fi
done

# Copy ALL enhanced auto-handler scripts
echo "🎯 Copying enhanced auto-handler scripts..."

for script in SMART-BRIDGE-99-auto-handler ENHANCED-MOBILE-99-connectivity MASTER-AUTO-99-config; do
    if [ -f "${GITHUB_WORKSPACE}/$script" ]; then
        cp "${GITHUB_WORKSPACE}/$script" files/etc/OpenWRT-RPI-4-main/
        chmod +x files/etc/OpenWRT-RPI-4-main/$script
        echo "✅ Copied auto-handler: $script"
    fi
done

# Copy adguard setup script
if [ -f "${GITHUB_WORKSPACE}/adguard-setup" ]; then
    cp "${GITHUB_WORKSPACE}/adguard-setup" files/etc/OpenWRT-RPI-4-main/
    chmod +x files/etc/OpenWRT-RPI-4-main/adguard-setup
    echo "✅ Copied AdGuard setup script"
fi

# Copy mobile IP ranges configuration
if [ -f "${GITHUB_WORKSPACE}/mobile_ip_ranges.conf" ]; then
    cp "${GITHUB_WORKSPACE}/mobile_ip_ranges.conf" files/etc/
    echo "✅ Copied mobile IP ranges configuration"
fi

# Create RC script to run our configuration on first boot
echo "🚀 Creating first boot configuration script"
cat > files/etc/rc.local << 'EOF'
#!/bin/sh

# Run rootfs resize on first boot
if [ ! -f /etc/.rootfs_resized ]; then
    echo "📱 Running SD card resize on first boot..."
    /etc/OpenWRT-RPI-4-main/AUTOSIZE-99-rootfs-resize
fi

# Run Master Auto-Configuration (includes everything)
if [ -f /etc/OpenWRT-RPI-4-main/MASTER-AUTO-99-config ] && [ ! -f /etc/.master_auto_config_complete ]; then
    echo "🎯 Running Master Auto-Configuration..."
    /etc/OpenWRT-RPI-4-main/MASTER-AUTO-99-config
fi

# Run network mode configuration
if [ -f /etc/OpenWRT-RPI-4-main/ENHANCED-MODE-99-network-selector ]; then
    echo "🌐 Running network mode configuration..."
    /etc/OpenWRT-RPI-4-main/ENHANCED-MODE-99-network-selector
fi

exit 0
EOF

chmod +x files/etc/rc.local

# Create default network mode file
echo "🔧 Setting default network mode"
mkdir -p files/etc
echo "advanced_bridge" > files/etc/network_mode

# Create welcome message
echo "📝 Creating welcome message"
cat > files/etc/banner << 'EOF'
  ____                  __        __  ______    __  ___ ____  ______ __ __
 / __ \____  ___  ____ /  |  /   |  \ \____ \  |  ||  ||    \|      T  T  \
(  (__/ __ )|   \/   |/   | /  ) |   ||   ___/  |  ||  ||  D  )     |  |  |
 \_ __|   |\| |  |  (_)    |/  /  |   ||  |__   |__||__||    /|_    /  |  |
(_____ \  | |  |  |    )   |  /   |   | \____ \ |  ||  ||    \  |  ||  :  |
      ) ) |\|  |  |   |    | /    |___|/      ) )|  ||  ||  .  \ |  ||     |
/\___/ /  | \     |___\____)      ____||_____/ / |__||__||__|\_| |__| \____,
\______/   |   |     |       |    |    |   \__/                     

🌉 Advanced Bridge Mode Raspberry Pi 4 Router
📱 Mobile Hotspot & USB Tethering Support
🛡️ AdGuard Home DNS Protection

🔧 Change network mode: echo "router|bridge|advanced_bridge" > /etc/network_mode && reboot
📱 Mobile hotspot config: /etc/mobile_hotspots.conf
🔌 USB tethering config: /etc/usb_tethering.conf

🌐 Web Interface: http://192.168.1.1 (router) / http://192.168.100.1 (bridge mgmt)

EOF

# Set timezone to India
echo "🌍 Setting timezone"
mkdir -p files/etc/config
cat > files/etc/config/system << 'EOF'
config system
	option ttylogin '0'
	option log_size '64'
	option urandom_seed '0'
	option timezone 'IST-5:30'
	option zonename 'Asia/Kolkata'

config timeserver 'ntp'
	option enabled '1'
	option enable_server '0'
	list server '0.openwrt.pool.ntp.org'
	list server '1.openwrt.pool.ntp.org'
	list server '2.openwrt.pool.ntp.org'
	list server '3.openwrt.pool.ntp.org'
EOF

echo "✅ Custom configuration completed"