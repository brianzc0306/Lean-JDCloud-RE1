#!/bin/bash
# OpenWrt DIY script part 2 (After Update feeds)
# https://github.com/P3TERX/Actions-OpenWrt
# 优化版 by brianzc0306

# -------------------------------
# 删除 lucky 旧包，防止冲突
rm -rf package/feeds/packages/lucky
rm -rf package/feeds/luci/luci-app-lucky
rm -rf package/lucky

# 拉新版 lucky 包
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# -------------------------------
# 删除 nikki 旧包，防止冲突
rm -rf package/feeds/luci/luci-app-nikki
rm -rf package/nikki

# 拉新版 nikki 包
git clone -b main https://github.com/nikkinikki-org/OpenWrt-nikki.git package/nikki

# -------------------------------
# 创建 uci-defaults 脚本目录
mkdir -p package/base-files/files/etc/uci-defaults

# -------------------------------
# 修改默认 LAN IP
cat > package/base-files/files/etc/uci-defaults/99-set-lan-ip <<EOF
#!/bin/sh
uci set network.lan.ipaddr='192.168.0.1'
uci commit network
EOF

# -------------------------------
# 修改主机名 Hostname
cat > package/base-files/files/etc/uci-defaults/99-set-hostname <<EOF
#!/bin/sh
uci set system.@system[0].hostname='JDCloud-ER1'
uci commit system
EOF

# -------------------------------
# 修改 root 密码
cat > package/base-files/files/etc/uci-defaults/99-set-root-password <<EOF
#!/bin/sh
# 设置 root 密码为 *@qq031453
echo -e "*@qq031453\n*@qq031453" | passwd root
echo "Root password set to *@qq031453 successfully!"
EOF

# -------------------------------
# 配置 fstab，挂载 /dev/mmcblk0p27 为 /overlay
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
# 创建启动脚本，开机挂载 /overlay
cat > package/base-files/files/etc/uci-defaults/99-set-overlay <<EOF
#!/bin/sh
# 卸载现有的 /overlay
if mountpoint -q /overlay; then
    umount /overlay
    echo "/overlay unmounted"
else
    echo "/overlay is not mounted"
fi

# 检查 /dev/mmcblk0p27 是否存在并挂载
if [ -b /dev/mmcblk0p27 ]; then
    mount /dev/mmcblk0p27 /overlay
    echo "Mounted /dev/mmcblk0p27 to /overlay"
else
    echo "/dev/mmcblk0p27 not found, overlay mount failed!"
fi
EOF

# -------------------------------
# 设置 uci-defaults 脚本权限
chmod +x package/base-files/files/etc/uci-defaults/99-set-*
