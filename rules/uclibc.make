# -*-makefile-*-
# $Id: template 6001 2006-08-12 10:15:00Z mkl $
#
# Copyright (C) 2006, 2008 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UCLIBC) += uclibc

#
# Paths and names
#
UCLIBC_VERSION	:= $(call remove_quotes,$(PTXCONF_UCLIBC_VERSION))
UCLIBC_MD5	:= $(call remove_quotes,$(PTXCONF_UCLIBC_MD5))
UCLIBC		:= uClibc-$(UCLIBC_VERSION)
UCLIBC_SUFFIX	:= tar.bz2
UCLIBC_URL	:= http://www.uclibc.org/downloads/$(UCLIBC).$(UCLIBC_SUFFIX)
UCLIBC_SOURCE	:= $(SRCDIR)/$(UCLIBC).$(UCLIBC_SUFFIX)
UCLIBC_DIR	:= $(BUILDDIR)/$(UCLIBC)
UCLIBC_CONFIG	:= $(call remove_quotes, $(PTXDIST_PLATFORMCONFIGDIR)/config/$(PTXCONF_UCLIBC_CONFIG))


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(UCLIBC_SOURCE):
	@$(call targetinfo)
	@$(call get, UCLIBC)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

UCLIBC_PATH	:= PATH=$(CROSS_PATH)
UCLIBC_ENV 	:= KCONFIG_NOTIMESTAMP=1 $(HOST_ENV_CC)

UCLIBC_MAKEVARS	:= \
	CROSS=$(COMPILER_PREFIX) \
	HOSTCC="$(HOSTCC)" \
	DEVEL_PREFIX=/usr/ \
	PREFIX=$(SYSROOT) \
	KERNEL_SOURCE=$(SYSROOT)/usr \
	RUNTIME_PREFIX=/ \
	SHARED_LIB_LOADER_PREFIX=/lib

$(STATEDIR)/uclibc.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/uclibc.compile:
	@$(call targetinfo)
	cd $(UCLIBC_DIR) && $(UCLIBC_PATH) $(MAKE) $(UCLIBC_MAKEVARS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/uclibc.install:
	@$(call targetinfo)
	cd $(UCLIBC_DIR) && \
		$(UCLIBC_PATH) $(MAKE) $(UCLIBC_MAKEVARS) \
		install DEVEL_PREFIX=/usr/ PREFIX=$(SYSROOT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/uclibc.targetinstall:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

uclibc_clean:
	rm -rf $(STATEDIR)/uclibc.*
	rm -rf $(UCLIBC_DIR)

# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

uclibc_oldconfig uclibc_menuconfig: $(STATEDIR)/uclibc.extract
	@if test -e $(UCLIBC_CONFIG); then \
		cp $(UCLIBC_CONFIG) $(UCLIBC_DIR)/.config; \
	fi

	@cd $(UCLIBC_DIR) && \
		$(UCLIBC_PATH) $(UCLIBC_ENV) $(MAKE) $(UCLIBC_MAKEVARS) $(subst uclibc_,,$@)

	@if cmp -s $(UCLIBC_DIR)/.config $(UCLIBC_CONFIG); then \
		echo "uclibc configuration unchanged"; \
	else \
		cp $(UCLIBC_DIR)/.config $(UCLIBC_CONFIG); \
	fi

# vim: syntax=make
