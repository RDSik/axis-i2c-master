# Usage

## Dependencies 

`hdlmake`, `make`, `cocotb`, `vivado`, `modelsim`, `python`

## Installation

### Clone repository:
```bash
git clone --recurse-submodules https://github.com/RDSik/i2c_master.git
```

### Download pip:
```bash
https://pip.pypa.io/en/latest/installation/
```

### Download packages:
```bash
pip install six
pip install hdlmake
pip install cocotb
pip install pytest
```

### Download make (add to PATH system variable the Make bin folder: C:\Program Files (x86)\GnuWin32\bin):
```bash
winget install GnuWin32.make
```

## Build project

### Build i2c_master:
```bash
cd syn
hdlmake
make
```

### Build only vivado project:
```bash
cd syn
hdlmake
make project
```

## Simulation

### Vivado simulation using hdlmake:
```bash
cd top/sim/vivado
hdlmake
make
```

### Modelsim simulation using hdlmake:
```bash
cd top/sim/modelsim
hdlmake
make
```

### Icarus simulation using cocotb:
```bash
venv myenv
.\myenv\Scripts\activate.ps1
cd sim\cocotb
pytest test.py
cd .\sim_build_i2c_master
gtkwave .\i2c_master_top.vcd
deactivate
```
