# Makefile for compiling I2C drivers from local source
# Drivers: i2c_bcm2835, i2c_mux, i2c_mux_pca954x, i2c_dev

# Use installed RPi kernel headers
KERNEL_HEADERS ?= /usr/src/linux-headers-$(shell uname -r)
BUILD_DIR := $(CURDIR)/build

# Source files from our local src directory
SRC_DIR := $(CURDIR)/src/i2c
MODULE_NAMES := i2c-bcm2835 i2c-mux i2c-mux-pca954x i2c-dev

# Architecture and cross-compiler settings
ARCH := arm64
CROSS_COMPILE := aarch64-linux-gnu-

.PHONY: all clean modules install prepare

all: modules

prepare:
	@mkdir -p $(BUILD_DIR)
	@echo "obj-m := $(foreach mod,$(MODULE_NAMES),$(mod).o)" > $(BUILD_DIR)/Makefile
	@cp -r $(SRC_DIR)/* $(BUILD_DIR)/

modules: prepare
	@echo "Compiling I2C drivers using installed kernel headers..."
	$(MAKE) -C $(KERNEL_HEADERS) M=$(BUILD_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	@echo "Compilation complete. Modules available in $(BUILD_DIR)"

install: modules
	@echo "Installing I2C drivers..."
	$(MAKE) -C $(KERNEL_HEADERS) M=$(BUILD_DIR) modules_install
	depmod -a
	@echo "Installation complete"

clean:
	rm -rf $(BUILD_DIR)
	@echo "Build directory cleaned"