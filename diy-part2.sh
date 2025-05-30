#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
#git clone https://github.com/ophub/luci-app-amlogic.git package/lean/luci-app-amlogic
#git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/lean/passwall-packages
#git clone https://github.com/xiaorouji/openwrt-passwall.git package/lean/luci-app-passwall
#git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

rm -rf package/feeds/packages/lucky      # 删除官方 feed 中的包
rm -rf package/feeds/luci/luci-app-lucky # 删除 Luci feed 中的包
