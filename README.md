# Usage

## Dependencies 

`hdlmake`, `make`, `cocotb`, `pytest`, `vivado`, `modelsim`, `python`, `chocolatey`, `winget`

## Installation

### Download python and git:
- [Install Chocolatey on Windows 10](https://gist.github.com/lopezjurip/2a188c90284bf239197b)

### Clone repository:
```bash
git clone https://github.com/RDSik/i2c-master.git
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

## Simulation

### Icarus simulation using cocotb:
```bash
py -m venv myenv
.\myenv\Scripts\activate.ps1
cd .\sim\cocotb
py -m pytest test.py
gtkwave  .\sim_build_i2c_master\i2c_master_top.vcd
deactivate
```

### Vivado simulation using hdlmake:
```bash
cd sim/vivado
hdlmake
make
```

### Modelsim simulation using hdlmake:
```bash
cd sim/modelsim
hdlmake
make
```
