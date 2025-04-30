# I2C Drivers Compilation

This project compiles specific I2C drivers from the Linux kernel source:
- i2c_bcm2835
- i2c_mux
- i2c_mux_pca954x
- i2c_dev

## Prerequisites

- Linux/macOS environment
- GCC compiler and build tools
- Make
- curl
- tar with xz support

## Usage

### Compile all drivers

```bash
make
```

This will:
1. Download the Linux kernel source (version 6.1.0)
2. Configure it for module building
3. Compile the specified I2C driver modules

### Clean build files

```bash
make clean
```

### Remove all downloaded and generated files

```bash
make distclean
```

## Output

The compiled kernel modules will be available in the `build/` directory:
- i2c-bcm2835.ko
- i2c-mux.ko
- i2c-mux-pca954x.ko
- i2c-dev.ko

## Notes

- The Makefile is configured to use Linux kernel version 6.1.0. You can modify the `KERNEL_VERSION` variable to use a different version.
- You may need to adjust the configuration process depending on your target system.
- Building kernel modules requires appropriate kernel headers and development tools. 