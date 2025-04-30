# Raspberry Pi I2C Drivers

This project compiles and installs specific I2C drivers for Raspberry Pi:
- i2c_bcm2835 - BCM2835 I2C controller driver
- i2c_mux - I2C multiplexer support
- i2c_mux_pca954x - PCA954x I2C multiplexer/switch driver
- i2c_dev - I2C character device interface

## Prerequisites

- Raspberry Pi with 64-bit OS
- Installed kernel headers (`apt install linux-headers-$(uname -r)`)
- Build tools (`apt install build-essential`)

## Usage

### Compile the drivers

```bash
make
```

### Install and auto-configure

```bash
sudo make install
```

This will:
1. Compile the I2C driver modules
2. Install them to the appropriate kernel modules directory
3. Automatically configure I2C in `/boot/firmware/config.txt`
4. Load the modules immediately

### Clean build files

```bash
make clean
```

## Features

- **Kernel Module Building**: Builds modules compatible with your current kernel
- **Auto-Configuration**: Automatically enables I2C interfaces in boot config
- **Auto-Loading**: Loads the modules immediately after installation
- **Multiplexer Support**: Includes PCA954x multiplexer driver for connecting multiple I2C devices

## Post-Installation

After installation, you should see multiple I2C buses available:

```bash
i2cdetect -l
```

You may need to reboot if this is the first time enabling I2C on your system:
```
sudo reboot
```

## Scanning I2C Buses

To scan for I2C devices on a specific bus:
```
sudo i2cdetect -y <bus_number>
```

## Troubleshooting

If I2C devices aren't showing up after installation:
1. Ensure I2C is enabled in boot config
2. Verify physical connections
3. Check if the modules are loaded with `lsmod | grep i2c`
4. Reboot the system if configuration was updated 