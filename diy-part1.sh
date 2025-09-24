#!/bin/bash
# DIY Part 1 - Custom feeds and packages setup
# कस्टम फीड्स और पैकेज सेटअप

echo "🔧 DIY Part 1: Setting up custom feeds and packages"

# Add luci-theme-argon theme
echo "🎨 Adding Argon theme"
echo "src-git argon https://github.com/jerrykuku/luci-theme-argon.git" >> feeds.conf.default

# Add AdGuard Home
echo "🛡️ Adding AdGuard Home feed"
echo "src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome.git" >> feeds.conf.default

# Add additional useful packages
echo "📦 Adding extra package feeds"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git" >> feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default

# Mobile connectivity packages (already in main feeds, just ensure they're available)
echo "📱 Ensuring mobile connectivity packages are available"
# These will be installed via .config file

echo "✅ Custom feeds configuration completed"