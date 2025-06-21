#!/bin/bash
# OpenWrt DIY script part 2 (After Update feeds)
# https://github.com/P3TERX/Actions-OpenWrt

# 删除 lucky 旧包，避免冲突
rm -rf package/feeds/packages/lucky
rm -rf package/feeds/luci/luci-app-lucky

# 克隆最新 lucky 包
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

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

# 设置执行权限
chmod +x package/base-files/files/etc/uci-defaults/99-set-*
