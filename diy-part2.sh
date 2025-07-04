#!/bin/bash
# OpenWrt DIY script part 2 (After Update feeds)
# 完整版 by brianzc0306
# 功能：拉取 lucky/nikki，删除旧的 miniupnpd 包并拉取支持 nftables 的版本，修改默认配置

# -------------------------------
# 1. 删除旧的 lucky 包，避免冲突
rm -rf package/feeds/packages/lucky
rm -rf package/feeds/luci/luci-app-lucky
rm -rf package/lucky

# 2. 拉取最新 lucky 包
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# -------------------------------
# 3. 删除旧的 nikki 包，避免冲突
rm -rf package/feeds/luci/luci-app-nikki
rm -rf package/nikki

# 4. 拉取最新 nikki 包
git clone -b main https://github.com/nikkinikki-org/OpenWrt-nikki.git package/nikki

# -------------------------------
# 5. 删除旧的 miniupnpd 包，避免冲突
#rm -rf package/feeds/packages/miniupnpd
#rm -rf package/miniupnpd

# 6. 修正：克隆支持 nftables 的 miniupnpd 版本
#echo "正在克隆 miniupnpd (nftables 版本)..."
#git clone --depth=1 https://github.com/openwrt/packages.git package/miniupnpd-temp
#mv package/miniupnpd-temp/net/miniupnpd package/
#rm -rf package/miniupnpd-temp

# -------------------------------
# 7. 创建必要目录，防止写入文件失败
mkdir -p package/base-files/files/etc/uci-defaults
mkdir -p package/base-files/files/etc/config

# -------------------------------
# 8. 修改默认 LAN IP
cat > package/base-files/files/etc/uci-defaults/99-set-lan-ip <<EOF
#!/bin/sh
uci set network.lan.ipaddr='192.168.0.1'
uci commit network
EOF

# 9. 修改主机名
cat > package/base-files/files/etc/uci-defaults/99-set-hostname <<EOF
#!/bin/sh
uci set system.@system[0].hostname='JDCloud-ER1'
uci commit system
EOF

# 10. 修改 root 密码
cat > package/base-files/files/etc/uci-defaults/99-set-root-password <<EOF
#!/bin/sh
echo -e "*@qq031453\n*@qq031453" | passwd root
echo "Root password set to *@qq031453 successfully!"
EOF

# -------------------------------
