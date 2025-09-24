# 🔄 Automated Weekly OpenWrt Builds

## 🎯 Overview
यह system **automatically** हर हफ्ते OpenWrt के नए updates को check करता है और जब भी कोई नया update available होता है, तो automatically latest firmware build करता है।

## ⚙️ कैसे काम करता है

### 🔍 **Weekly Check Process**
```yaml
Schedule: Every Sunday at 2:00 AM UTC (7:30 AM IST)
Trigger: GitHub Actions Cron Job
```

### 📋 **Step-by-Step Process:**

1. **🔍 Update Check**
   - OpenWrt master branch की latest commit check करता है
   - Last built commit से compare करता है
   - `.openwrt-commit` file में tracking रखता है

2. **✅ Build Decision**
   ```bash
   IF (new_commit != old_commit) THEN
       🚀 Start automatic build
   ELSE
       ℹ️ Log "No updates found"
   ```

3. **🔨 Auto-Build Process**
   - Latest OpenWrt source download करता है
   - Custom packages और themes add करता है
   - Configuration apply करता है
   - Firmware build करता है

4. **📦 Release Creation**
   - `weekly-YYYYMMDD-buildid` tag के साथ release बनाता है
   - Factory और Sysupgrade images upload करता है
   - Detailed build information include करता है

## 📅 **Build Types**

### 1. **🔄 Weekly Automatic Builds**
- **When**: हर रविवार सुबह (अगर updates हैं)
- **Tag Format**: `weekly-20241124-12345678`
- **Trigger**: Automatic (OpenWrt updates)

### 2. **⚡ Manual/Push Builds** 
- **When**: Code changes पर या manual trigger
- **Tag Format**: `openwrt-rpi4-20241124-12345678`
- **Trigger**: Manual या configuration changes

## 🎛️ **Manual Controls**

### Force Weekly Build
```bash
# GitHub Actions में जाकर "Weekly Auto-Update" workflow को manually run करें
# Options:
# - force_build: true (updates ना हो तो भी build करे)
# - check_branch: master (कौन सी branch check करे)
```

### Skip Weekly Build
```bash
# .openwrt-commit file को manually update करके latest commit डाल दें
echo "latest_commit_hash" > .openwrt-commit
git commit -m "Skip weekly build - manual commit update"
```

## 📊 **Release Management**

### 📦 **Release Types:**
- **Weekly Releases**: `weekly-*` tags - Auto-cleanup (केवल latest 3 रखता है)
- **Manual Releases**: `openwrt-rpi4-*` tags - Auto-cleanup (केवल latest 5 रखता है)

### 🗑️ **Auto-Cleanup:**
```yaml
Weekly Releases: Keep latest 3
Manual Releases: Keep latest 5
Old releases automatically deleted
```

## 📋 **Build Information**

### 📄 **प्रत्येक release में included:**
```
📁 openwrt-rpi4-factory.img.gz    - Fresh installations
📁 openwrt-rpi4-sysupgrade.img.gz - Upgrades  
📄 build-info.txt                 - Detailed build info
```

### 📊 **Build Info Contains:**
- Build date & time
- OpenWrt version & commit hash
- Previous commit (what changed)
- Build trigger reason
- Complete change summary

## 🔧 **Configuration Files**

### 📁 **Key Files:**
```
.github/workflows/weekly-auto-build.yml  - Weekly automation
.github/workflows/fast-build.yml         - Manual/Push builds  
.openwrt-commit                          - Commit tracking
.config                                  - OpenWrt configuration
files/                                   - Custom files & scripts
```

## 🚀 **Setup Instructions**

### 1. **Enable Automated Builds**
```bash
# Repository में ये files already हैं, बस commit करें:
git add .
git commit -m "🔄 Enable automated weekly OpenWrt builds"
git push origin main
```

### 2. **First Run**
```bash
# Manual trigger करके test करें:
# 1. GitHub → Actions → "Weekly OpenWrt Auto-Update"  
# 2. "Run workflow" → force_build: true
```

### 3. **Verify Setup**
- ✅ Weekly workflow का schedule check करें
- ✅ `.openwrt-commit` file exist करे
- ✅ GitHub secrets properly configured हों

## 📈 **Monitoring & Logs**

### 🔍 **Check Build Status:**
```bash
# GitHub Actions page पर जाकर:
# - "Weekly OpenWrt Auto-Update" - weekly builds
# - "Fast OpenWrt Build" - manual builds
```

### 📊 **Build History:**
```bash
# Releases page पर:
# - weekly-* tags = Automatic builds
# - openwrt-rpi4-* tags = Manual builds
```

## 🛠️ **Troubleshooting**

### ❌ **Build Fails:**
1. Check GitHub Actions logs
2. Verify OpenWrt upstream is accessible
3. Check if configuration is valid

### ⏸️ **Builds Not Triggering:**
1. Verify cron schedule is correct
2. Check if `.openwrt-commit` is being updated
3. Ensure GitHub Actions are enabled

### 🔄 **Force Update:**
```bash
# Manual trigger के साथ:
force_build: true
```

## 💡 **Benefits**

### ✅ **Advantages:**
- 🤖 **Fully Automated** - No manual intervention needed
- 🔄 **Always Updated** - Latest security patches & features
- 📦 **Clean Releases** - Organized and well-documented
- ⚡ **Efficient** - Only builds when needed
- 🛡️ **Reliable** - Comprehensive error handling

### 🎯 **Use Cases:**
- **Home Users**: Always latest firmware without manual work
- **Developers**: Automated testing with latest OpenWrt
- **Enterprise**: Consistent update schedule
- **Community**: Regular builds for others to use

---

## 🎉 **Result**

**हर रविवार सुबह**, अगर OpenWrt में कोई नया update होगा, तो automatically आपको GitHub Releases में latest firmware मिल जाएगा! 🚀

**No manual work needed - completely automated!** ✨