include $(TOPDIR)/rules.mk

PKG_NAME:=icwmp
PKG_VERSION:=8.4.22

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitee.com/lcwmp/icwmp.git
PKG_SOURCE_VERSION:=4d59758b7ba2a6d7710a86df3b52c765f2c68de5
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=LICENSE

PKG_FIXUP:=autoreconf
PKG_CONFIG_DEPENDS:= \
	CONFIG_CWMP_ACS_MULTI \
	CONFIG_CWMP_ACS_HDM \
	CONFIG_CWMP_DEBUG \
	CONFIG_CWMP_DEVEL_DEBUG

include $(INCLUDE_DIR)/package.mk

define Package/icwmp/default
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=TRx69
  TITLE:=TR069 CWMP client
  DEPENDS:=+libuci +libubox +libblobmsg-json +libubus +libjson-c +libcurl +mxml
endef

define Package/icwmp/config
	source "$(SOURCE)/Config_cwmp.in"
endef

TARGET_CFLAGS += \
	-D_GNU_SOURCE \
	"-DCWMP_REVISION=\\\"$(PKG_SOURCE_VERSION)\\\""

define Package/icwmp
  $(Package/icwmp/default)
  TITLE += (internal)
  VARIANT:=internal
endef

define Package/icwmp-openssl
  $(Package/icwmp/default)
  TITLE += (openssl)
  DEPENDS += +PACKAGE_icwmp-openssl:libopenssl
  VARIANT:=openssl
endef

define Package/icwmp-wolfssl
  $(Package/icwmp/default)
  TITLE += (wolfssl)
  DEPENDS += +PACKAGE_icwmp-wolfssl:libwolfssl
  CONFLICTS := icwmp-openssl
  VARIANT:=wolfssl
endef

define Package/icwmp-mbedtls
  $(Package/icwmp/default)
  TITLE += (mbedtls)
  DEPENDS += +PACKAGE_icwmp-mbedtls:libmbedtls
  CONFLICTS := icwmp-openssl icwmp-wolfssl
  VARIANT:=mbedtls
  DEFAULT_VARIANT:=1
endef

ifeq ($(BUILD_VARIANT),openssl)
CONFIGURE_ARGS += --enable-libopenssl
endif

ifeq ($(BUILD_VARIANT),wolfssl)
CONFIGURE_ARGS += --enable-libwolfssl
endif

ifeq ($(BUILD_VARIANT),mbedtls)
CONFIGURE_ARGS += --enable-libmbedtls
endif

ifeq ($(CONFIG_CWMP_ACS_MULTI),y)
CONFIGURE_ARGS += \
	--enable-acs=multi
endif

ifeq ($(CONFIG_CWMP_ACS_HDM),y)
CONFIGURE_ARGS += \
	--enable-acs=hdm
endif

USE_LOCAL=$(shell ls ./src/ 2>/dev/null >/dev/null && echo 1)
ifneq ($(USE_LOCAL),)
define Build/Prepare
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef
endif

define Package/icwmp/default/install
	$(INSTALL_DIR) $(1)/etc/icwmpd
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DIR) $(1)/etc/bbfdm/json/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/icwmpd $(1)/usr/sbin/icwmpd
	$(INSTALL_DATA) ./files/etc/config/cwmp $(1)/etc/config/cwmp
	$(INSTALL_BIN) ./files/etc/firewall.cwmp $(1)/etc/firewall.cwmp
	$(INSTALL_BIN) ./files/etc/init.d/icwmpd $(1)/etc/init.d/icwmpd
	$(INSTALL_BIN) ./files/etc/uci-defaults/85-cwmp-set-userid $(1)/etc/uci-defaults/
	$(INSTALL_BIN) ./files/etc/uci-defaults/90-cwmpfirewall $(1)/etc/uci-defaults/
	$(INSTALL_DATA) ./files/lib/upgrade/keep.d/icwmp $(1)/lib/upgrade/keep.d/icwmp
	$(INSTALL_BIN) ./files/etc/icwmpd/update.sh $(1)/etc/icwmpd/update.sh
	$(INSTALL_DATA) ./files/etc/bbfdm/json/CWMPManagementServer.json $(1)/etc/bbfdm/json/
endef

Package/icwmp-openssl/install = $(Package/icwmp/default/install)
Package/icwmp-wolfssl/install = $(Package/icwmp/default/install)
Package/icwmp-mbedtls/install = $(Package/icwmp/default/install)

$(eval $(call BuildPackage,icwmp))
$(eval $(call BuildPackage,icwmp-openssl))
$(eval $(call BuildPackage,icwmp-wolfssl))
$(eval $(call BuildPackage,icwmp-mbedtls))
