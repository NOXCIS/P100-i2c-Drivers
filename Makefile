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
	@echo "Creating specific Kbuild file..."
	@echo "# Automatically generated Kbuild file" > $(BUILD_DIR)/Kbuild
	@echo "obj-m += busses/i2c-bcm2835.o" >> $(BUILD_DIR)/Kbuild
	@echo "obj-m += i2c-mux.o" >> $(BUILD_DIR)/Kbuild
	@echo "obj-m += muxes/i2c-mux-pca954x.o" >> $(BUILD_DIR)/Kbuild
	@echo "obj-m += i2c-dev.o" >> $(BUILD_DIR)/Kbuild

modules: prepare
	@echo "Compiling I2C drivers using installed kernel headers..."
	$(MAKE) -C $(KERNEL_HEADERS) M=$(BUILD_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	@echo "Compilation complete. Modules available in $(BUILD_DIR)"

install: modules
	@echo "Installing I2C drivers..."
	$(MAKE) -C $(KERNEL_HEADERS) M=$(BUILD_DIR) modules_install
	depmod -a
	@echo "Configuring I2C in boot config..."
	@if ! grep -q "dtparam=i2c_arm=on" /boot/firmware/config.txt; then \
		echo "# Enable I2C controllers (added by I2C driver installer)" | sudo tee -a /boot/firmware/config.txt > /dev/null; \
		echo "dtparam=i2c_arm=on" | sudo tee -a /boot/firmware/config.txt > /dev/null; \
		echo "dtparam=i2c0=on" | sudo tee -a /boot/firmware/config.txt > /dev/null; \
		echo "dtparam=i2c1=on" | sudo tee -a /boot/firmware/config.txt > /dev/null; \
		echo "Boot configuration updated. Reboot required to apply changes."; \
	else \
		echo "I2C already enabled in boot config"; \
	fi
	@echo "Loading I2C drivers..."
	modprobe -r i2c_bcm2835 i2c_mux i2c_mux_pca954x i2c_dev || true
	modprobe i2c_bcm2835
	modprobe i2c_mux
	modprobe i2c_mux_pca954x
	modprobe i2c_dev
	@echo "Installation complete"

clean:
	rm -rf $(BUILD_DIR)
	@echo "Build directory cleaned"