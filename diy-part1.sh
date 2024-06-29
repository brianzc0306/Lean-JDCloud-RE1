#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git amlogic https://github.com/ophub/luci-app-amlogic' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/passwall' >>feeds.conf.default
echo 'src-git passwall-packages https://github.com/xiaorouji/passwall-packages' >>feeds.conf.default
echo 'src-git lucky https://github.com/gdy666/luci-app-lucky/lucky' >>feeds.conf.default
