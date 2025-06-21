#!/bin/bash
# OpenWrt DIY script part 2 (After Update feeds)
# https://github.com/P3TERX/Actions-OpenWrt

# 删除 lucky 旧包，避免冲突
rm -rf package/feeds/packages/lucky
rm -rf package/feeds/luci/luci-app-lucky

# 创建 uci-defaults 脚本
mkdir -p package/base-files/files/etc/uci-defaults

# 1️⃣ 修改默认 LAN IP
cat > package/base-files/files/etc/uci-defaults/99-set-lan-ip <<EOF
#!/bin/sh
uci set network.lan.ipaddr='192.168.0.1'
uci commit network
EOF

# 2️⃣ 修改主机名 Hostname
cat > package/base-files/files/etc/uci-defaults/99-set-hostname <<EOF
#!/bin/sh
uci set system.@system[0].hostname='JDCloud-ER1'
uci commit system
EOF

# 3️⃣ 修改 root 密码（示例密码：12345678）
cat > package/base-files/files/etc/uci-defaults/99-set-root-password <<EOF
#!/bin/sh
PASSWD=\$(openssl passwd -1 '*@qq031453')
uci set system.@system[0].password="\$PASSWD"
uci commit system
EOF

# 4️⃣ 配置 fstab，挂载 /dev/mmcblk0p27 为 /overlay
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
EOF

# 5️⃣ 创建一个启动脚本，确保开机后挂载 /overlay
cat > package/base-files/files/etc/uci-defaults/99-set-overlay <<EOF
#!/bin/sh

# 检查 /dev/mmcblk0p27 是否存在并挂载为 /overlay
if [ -b /dev/mmcblk0p27 ]; then
    mount /dev/mmcblk0p27 /overlay
    echo "Mounted /dev/mmcblk0p27 to /overlay"
else
    echo "/dev/mmcblk0p27 not found, overlay mount failed!"
fi
EOF

# 6️⃣ 设置执行权限
chmod +x package/base-files/files/etc/uci-defaults/99-set-*

# 7️⃣ 打印调试信息
echo "diy-part2.sh executed successfully!"
