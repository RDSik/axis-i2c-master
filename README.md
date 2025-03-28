[![Build project](https://github.com/RDSik/axis-i2c-master/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/RDSik/axis-i2c-master/actions/workflows/main.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/RDSik/axis-i2c_master/blob/master/LICENSE.txt)

# AXI-Stream I2C Master module

This is simple design with Xilinx AXI-Stream Data FIFO IP, AXI-Stream I2C Master and Clock Divider. 

## Clone repository:
```bash
git clone https://github.com/RDSik/axis-i2c-master.git
cd axis-i2c-master
```

## Build project
```bash
make project
```

## Simulate project
* For simulation with Xilinx FIFO, build project, use macro file(wave.do) in project dir and compile Vivado libs
* For simulation with Custom FIFO, use:
```bash
make
```