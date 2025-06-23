#!/bin/bash
# OpenWrt DIY script part 2 (After Update feeds)
# 完整版 by brianzc0306
# 功能：拉取 lucky/nikki，修改默认配置，配置 overlay

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
# 5. 创建必要目录，防止写入文件失败
mkdir -p package/base-files/files/etc/uci-defaults
mkdir -p package/base-files/files/etc/config

# -------------------------------
# 6. 修改默认 LAN IP
cat > package/base-files/files/etc/uci-defaults/99-set-lan-ip <<EOF
#!/bin/sh
uci set network.lan.ipaddr='192.168.0.1'
uci commit network
EOF

# 7. 修改主机名
cat > package/base-files/files/etc/uci-defaults/99-set-hostname <<EOF
#!/bin/sh
uci set system.@system[0].hostname='JDCloud-ER1'
uci commit system
EOF

# 8. 修改 root 密码
cat > package/base-files/files/etc/uci-defaults/99-set-root-password <<EOF
#!/bin/sh
echo -e "*@qq031453\n*@qq031453" | passwd root
echo "Root password set to *@qq031453 successfully!"
EOF

# -------------------------------
# 9. 配置 fstab 挂载 /dev/mmcblk0p27 为 /overlay
cat > package/base-files/files/etc/config/fstab <<EOF
config global
	option anon_swap '0'
	option auto_swap '1'

config mount
	option target '/overlay'
	option device '/dev/mmcblk0p27'
	option fstype 'ext4'
	option options 'rw,sync'
	option enabled '1'

config mount
	option target '/mnt/sd'
	option device '/dev/mmcblk0p28'
	option fstype 'ext4'
	option options 'rw,sync'
	option enabled '0'
EOF

# -------------------------------
# 10. 创建启动脚本，确保开机挂载 /overlay
cat > package/base-files/files/etc/uci-defaults/99-set-overlay <<EOF
#!/bin/sh
if mountpoint -q /overlay; then
    umount /overlay
    echo "/overlay unmounted"
else
    echo "/overlay is not mounted"
fi

if [ -b /dev/mmcblk0p27 ]; then
    mount /dev/mmcblk0p27 /overlay
    echo "Mounted /dev/mmcblk0p27 to /overlay"
else
    echo "/dev/mmcblk0p27 not found, overlay mount failed!"
fi
EOF

# -------------------------------
# 11. 设置 uci-defaults 脚本执行权限
chmod +x package/base-files/files/etc/uci-defaults/99-set-*

# -------------------------------
# 12. 完成提示
echo "✅ diy-part2.sh 执行完成！"
