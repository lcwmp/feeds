include $(TOPDIR)/rules.mk

PKG_NAME:=libbbfdm
PKG_VERSION:=6.8.6

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitee.com/lcwmp/lbbf.git
PKG_SOURCE_VERSION:=a517b0b29ec8c34b8492b88bc887582e7d55a524
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/libbbf_api
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=TRx69
  TITLE:=Library for libbbfdm API
endef

define Package/libbbfdm/default
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=TRx69
  TITLE:=Library for broadband forum data model support
  DEPENDS:=+libuci +libubox +libubus +libblobmsg-json +libjson-c +libtrace +libcurl
endef

define Package/libbbfdm
  $(Package/libbbfdm/default)
  TITLE += (internal)
  VARIANT:=internal
endef

define Package/libbbfdm-mbedtls
  $(Package/libbbfdm/default)
  TITLE += (mbedtls)
  DEPENDS += +PACKAGE_libbbfdm-mbedtls:libmbedtls
  VARIANT:=mbedtls
  DEFAULT_VARIANT:=1
endef

define Package/libbbfdm-openssl
  $(Package/libbbfdm/default)
  TITLE += (openssl)
  DEPENDS += +PACKAGE_libbbfdm-openssl:libopenssl
  CONFLICTS := libbbfdm-mbedtls
  VARIANT:=openssl
endef

define Package/libbbfdm-wolfssl
  $(Package/libbbfdm/default)
  TITLE += (wolfssl)
  DEPENDS += +PACKAGE_libbbfdm-wolfssl:libwolfssl
  CONFLICTS := libbbfdm-mbedtls libbbfdm-openssl
  VARIANT:=wolfssl
endef

define Package/libbbfdm/config
	source "$(SOURCE)/Config_bbfdm.in"
endef

define Package/libbbf_api/description
 Library contains the API(UCI, UBUS, JSON, CLI and Browse) of libbbfdm
endef

define Package/libbbfdm/description
 Library contains the data model tree. It includes TR181, TR104 and TR143 data models
endef

USE_LOCAL=$(shell ls ./src/ 2>/dev/null >/dev/null && echo 1)
ifneq ($(USE_LOCAL),)
define Build/Prepare
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef
endif

CMAKE_OPTIONS += \
	-DBBF_TR181=ON

ifeq ($(CONFIG_BBF_TR104),y)
CMAKE_OPTIONS += \
	-DBBF_TR104=ON
endif

ifeq ($(CONFIG_BBF_TR143),y)
CMAKE_OPTIONS += \
	-DBBF_TR143=ON
endif

ifeq ($(CONFIG_BBF_VENDOR_EXTENSION),y)
CMAKE_OPTIONS += \
	-DBBF_VENDOR_EXTENSION=ON

CMAKE_OPTIONS += \
	-DBBF_VENDOR_LIST:String="$(CONFIG_BBF_VENDOR_LIST)" \
	-DBBF_VENDOR_PREFIX:String="$(CONFIG_BBF_VENDOR_PREFIX)" \
	-DBBF_MAX_OBJECT_INSTANCES:Integer=$(CONFIG_BBF_MAX_OBJECT_INSTANCES)

endif ##CONFIG_BBF_VENDOR_EXTENSION

ifeq ($(CONFIG_BBFDM_ENABLE_JSON_PLUGIN),y)
CMAKE_OPTIONS += \
	-DBBF_JSON_PLUGIN=ON
endif

ifeq ($(CONFIG_BBFDM_ENABLE_DOTSO_PLUGIN),y)
CMAKE_OPTIONS += \
	-DBBF_DOTSO_PLUGIN=ON
endif

ifeq ($(BUILD_VARIANT),openssl)
CMAKE_OPTIONS += -DWITH_OPENSSL=ON
endif

ifeq ($(BUILD_VARIANT),wolfssl)
CMAKE_OPTIONS += -DWITH_WOLFSSL=ON
endif

ifeq ($(BUILD_VARIANT),mbedtls)
CMAKE_OPTIONS += -DWITH_MBEDTLS=ON
endif

define Package/libbbf_api/install
	$(INSTALL_DIR) $(1)/lib
endef

define Package/libbbfdm/default/install
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_DIR) $(1)/usr/share/bbfdm
	$(INSTALL_DIR) $(1)/etc/bbfdm
	$(INSTALL_DIR) $(1)/etc/bbfdm/dmmap
	$(INSTALL_DIR) $(1)/etc/bbfdm/json
	$(INSTALL_DIR) $(1)/usr/lib/bbfdm
	$(CP) $(PKG_BUILD_DIR)/libbbfdm.so $(1)/lib/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/* $(1)/usr/share/bbfdm
endef

define Package/libbbfdm/default/prerm
	#!/bin/sh
	rm -rf /etc/bbfdm/dmmap/*
	exit 0
endef

Package/libbbfdm-openssl/prerm = $(Package/libbbfdm/default/prerm)
Package/libbbfdm-wolfssl/prerm = $(Package/libbbfdm/default/prerm)
Package/libbbfdm-mbedtls/prerm = $(Package/libbbfdm/default/prerm)

Package/libbbfdm-openssl/install = $(Package/libbbfdm/default/install)
Package/libbbfdm-wolfssl/install = $(Package/libbbfdm/default/install)
Package/libbbfdm-mbedtls/install = $(Package/libbbfdm/default/install)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/include/libbbfdm
	$(INSTALL_DIR) $(1)/usr/include/libbbf_api
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/include/*.h $(1)/usr/include/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/*.h $(1)/usr/include/libbbfdm/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/libbbf_api/*.h $(1)/usr/include/libbbf_api/
	$(CP) $(PKG_BUILD_DIR)/libbbfdm.so $(1)/usr/lib/
	touch $(1)/usr/lib/libbbf_api.so
endef

$(eval $(call BuildPackage,libbbf_api))
$(eval $(call BuildPackage,libbbfdm))
$(eval $(call BuildPackage,libbbfdm-openssl))
$(eval $(call BuildPackage,libbbfdm-wolfssl))
$(eval $(call BuildPackage,libbbfdm-mbedtls))
