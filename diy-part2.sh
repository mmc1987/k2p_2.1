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
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# NOTE: the two source-tree fixes this script used to carry now live in the
# fork that REPO_URL/REPO_BRANCH point at (mmc1987/lede, fix/iwinfo-ra-backend):
#   - package/kernel/linux/modules/crypto.mk: MIPS32R2 chacha/poly1305 packaging
#   - package/network/utils/iwinfo/patches/103-ra-missing-ops.patch
#   - package/network/utils/iwinfo/patches/104-cli-null-safe-ops.patch
#   - package/system/rpcd/patches/010-iwinfo-null-safe-ops.patch
