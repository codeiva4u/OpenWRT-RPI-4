# 🚀 Advanced OpenWRT for Raspberry Pi 4

**🌉 Advanced Bridge Mode with Mobile Connectivity**

एक complete OpenWRT firmware जो Raspberry Pi 4 को एक powerful router/bridge में बदल देती है।

## ✨ Features

### 🌐 **Network Modes**
- **Router Mode** - Traditional NAT gateway with DHCP server
- **Basic Bridge Mode** - Simple transparent bridge
- **Advanced Bridge Mode** - Smart bridge with mobile connectivity

### 📱 **Mobile Connectivity**
- **Mobile Hotspot Auto-Connect** - Automatically connects to configured mobile hotspots
- **USB Tethering Support** - Auto-detects and configures Android/iPhone USB tethering
- **Multi-source Internet** - Seamlessly switches between Ethernet, WiFi, and mobile connections

### 🛡️ **Security & Features**
- **AdGuard Home** - Built-in DNS ad-blocking and privacy protection
- **WiFi Bridge** - WiFi clients can connect and get bridged internet
- **Auto SD Resize** - Automatically expands to use full SD card capacity
- **Luci Argon Theme** - Beautiful modern web interface

### 🔧 **Advanced Features**
- **GitHub Actions Build** - Automatically builds and releases firmware
- **Multiple Architecture Support** - Optimized for Raspberry Pi 4
- **Hindi Language Support** - Comments and messages in Hindi
- **Comprehensive Logging** - Detailed logs for troubleshooting

## 🎯 Use Cases

### **🌉 Advanced Bridge Mode**
Perfect when you want:
- Raspberry Pi के Ethernet port को main router के WAN port से connect करना
- WiFi clients को भी bridge के through internet access देना
- Mobile hotspot से automatic internet backup
- USB से mobile phone tethering
- No NAT, no local DHCP - पूरी तरह transparent

### **🌐 Router Mode** 
Traditional use cases:
- Internet connection sharing
- Local DHCP server
- AdGuard Home DNS filtering
- WiFi Access Point

## 📦 What's Included

### **Core Scripts:**
- `ADVANCED-BRIDGE-99-network-config` - Advanced bridge configuration
- `ENHANCED-MODE-99-network-selector` - Intelligent mode switching
- `mobile-hotspot-connect` - Mobile hotspot auto-connection service
- `usb-tethering-detect` - USB tethering auto-detection service
- `AUTOSIZE-99-rootfs-resize` - SD card auto-resize script
- `adguard-setup` - AdGuard Home auto-installer

### **Build System:**
- `.github/workflows/build-openwrt.yml` - Automated build workflow
- `diy-part1.sh` - Custom feeds setup
- `diy-part2.sh` - Custom configuration and files
- `.config` - Complete build configuration

## 🚀 Quick Start

### **Option 1: Download Pre-built Firmware**
1. Go to [Releases](../../releases)
2. Download latest `openwrt-*.img` file
3. Flash to SD card using Raspberry Pi Imager or Balena Etcher
4. Boot Raspberry Pi 4

### **Option 2: Build Your Own**
1. Fork this repository
2. Go to **Actions** tab
3. Click **"Build OpenWRT for Raspberry Pi 4"**
4. Click **"Run workflow"**
5. Wait for build to complete (~2-3 hours)
6. Download firmware from **Releases**

## ⚙️ Initial Setup

### **First Boot:**
1. SD card will automatically resize to full capacity
2. System will configure in **Advanced Bridge Mode** by default
3. Connect Ethernet cable to your main router

### **Access Web Interface:**
- **Advanced Bridge Mode**: http://192.168.100.1 (emergency management)
- **Router Mode**: http://192.168.1.1
- **Default credentials**: No password initially

### **WiFi Configuration:**
- **AP SSID**: `Pi-Bridge-WiFi` 
- **Password**: `bridge@123`

## 🔧 Configuration

### **Switch Network Modes:**
```bash
# Switch to Advanced Bridge Mode
echo "advanced_bridge" > /etc/network_mode && reboot

# Switch to Router Mode  
echo "router" > /etc/network_mode && reboot

# Switch to Basic Bridge Mode
echo "bridge" > /etc/network_mode && reboot
```

### **Configure Mobile Hotspots:**
Edit `/etc/mobile_hotspots.conf`:
```
# Format: SSID|Password|Priority(1-10)
AndroidAP|password123|9
iPhone|hotspot123|8
Airtel_123|mobile123|7
Jio_4G|jiopassword|6
```

### **USB Tethering Configuration:**
Edit `/etc/usb_tethering.conf`:
```bash
# Enable different device types
ENABLE_ANDROID=1
ENABLE_IPHONE=1
ENABLE_RNDIS=1

# Auto-bridge in bridge mode
AUTO_BRIDGE=1
```

## 📱 Mobile Connectivity Services

### **Mobile Hotspot Service:**
```bash
mobile-hotspot-connect start    # Start service
mobile-hotspot-connect status   # Check status
mobile-hotspot-connect stop     # Stop service
```

### **USB Tethering Service:**
```bash
usb-tethering-detect start      # Start service
usb-tethering-detect list       # List detected devices
usb-tethering-detect status     # Check status
```

## 🛡️ AdGuard Home

### **Setup:**
```bash
adguard-setup install          # Install and configure
```

### **Access:**
- **Web Interface**: http://192.168.1.1:3000
- **Default credentials**: admin / admin123
- **DNS Server**: 192.168.1.1:53

### **Features:**
- Pre-configured with Indian ad filters
- Malware and tracking protection
- Detailed query logs and statistics
- Family-safe browsing options

## 🌉 Advanced Bridge Mode Setup

### **Physical Connections:**
1. **Ethernet**: Connect Pi's LAN port to main router's WAN port
2. **WiFi**: Configure mobile hotspot credentials
3. **USB**: Connect mobile phone with USB tethering enabled

### **How It Works:**
```
Internet → Main Router → Pi (Bridge) → WiFi Clients
     ↗️ Mobile Hotspot → Pi (Bridge) → WiFi Clients  
     ↗️ USB Tethering → Pi (Bridge) → WiFi Clients
```

### **Traffic Flow:**
- All traffic passes through transparently
- No NAT translation
- WiFi clients get IP from main router's DHCP
- Mobile connections provide automatic backup

## 📊 Monitoring and Logs

### **System Logs:**
```bash
tail -f /var/log/mobile_hotspot_connect.log    # Mobile hotspot logs
tail -f /var/log/usb_tethering_detect.log      # USB tethering logs
tail -f /var/log/rootfs_resize.log             # SD resize logs
tail -f /var/log/adguard_setup.log             # AdGuard setup logs
```

### **Network Status:**
```bash
cat /etc/network_mode                          # Current mode
ip route                                       # Routing table
brctl show                                     # Bridge interfaces
iwconfig                                       # WiFi status
```

## 🛠️ Troubleshooting

### **Common Issues:**

**Bridge mode not working:**
```bash
# Check bridge status
brctl show br-br_master
# Restart network
/etc/init.d/network restart
```

**Mobile hotspot not connecting:**
```bash
# Check configuration
cat /etc/mobile_hotspots.conf
# Restart service
mobile-hotspot-connect restart
```

**USB tethering not detected:**
```bash
# Check USB devices
lsusb
# List network interfaces  
usb-tethering-detect list
```

**AdGuard not working:**
```bash
# Check service status
adguard-setup status
# Restart service
adguard-setup restart
```

## 🔧 Build Configuration

### **Included Packages:**
- **Network**: Advanced bridge utilities, WiFi management
- **Mobile**: USB tethering drivers, mobile hotspot tools  
- **Security**: AdGuard Home, firewall utilities
- **System**: SD card tools, monitoring utilities
- **UI**: Luci with Argon theme

### **Custom Features:**
- Hindi language support in scripts
- Automatic service management
- Intelligent mode switching
- Comprehensive logging

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/new-feature`)
3. Commit changes (`git commit -am 'Add new feature'`)
4. Push to branch (`git push origin feature/new-feature`) 
5. Create Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🆘 Support

- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **Documentation**: [Wiki](../../wiki)

## 🙏 Credits

- **OpenWRT Team** - Base firmware
- **AdGuard Team** - DNS filtering solution
- **Community Contributors** - Various packages and themes

---

## 🎉 Ready to Use!

आपका Advanced OpenWRT Raspberry Pi 4 Router तैयार है! 

**Happy Routing! 🚀**