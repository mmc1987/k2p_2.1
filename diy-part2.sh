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

# Restore MIPS32R2 accelerated chacha/poly1305 packaging on kernel 5.10.
# lede d523e3ffee (2026-09-07) narrowed the arch-variant blocks in crypto.mk from
# "ifneq ($(KERNEL_PATCHVER),6.18)" to "ifeq ($(KERNEL_PATCHVER),6.12)", and
# 3b2ce46ad0 only restored the x86 half. ramips still defaults to 5.10, so
# arch/mips/crypto/chacha-mips.ko + poly1305-mips.ko are built but shipped by no
# kmod, and kmod-crypto-lib-chacha20poly1305 dies in find-requires.
CRYPTO_MK=package/kernel/linux/modules/crypto.mk
if [ -f "$CRYPTO_MK" ]; then
  awk '
    /^define KernelPackage\/crypto-lib-(chacha20|poly1305)$/ { want=1 }
    want && /^ifeq \(\$\(KERNEL_PATCHVER\),6\.12\)$/ {
      print "ifneq ($(KERNEL_PATCHVER),6.18)"; want=0; next
    }
    { print }
  ' "$CRYPTO_MK" > "$CRYPTO_MK.patched"

  gate_before=$(grep -c '^ifeq ($(KERNEL_PATCHVER),6.12)$' "$CRYPTO_MK")
  gate_after=$(grep -c '^ifeq ($(KERNEL_PATCHVER),6.12)$' "$CRYPTO_MK.patched")
  echo "crypto.mk 6.12 gates: $gate_before -> $gate_after"
  if [ "$gate_before" -gt "$gate_after" ]; then
    mv "$CRYPTO_MK.patched" "$CRYPTO_MK"
    grep -n 'KERNEL_PATCHVER),6.1[28])' "$CRYPTO_MK"
  else
    rm -f "$CRYPTO_MK.patched"
    echo "未命中 6.12 gate（上游可能已修复），跳过补丁"
  fi
fi
