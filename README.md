# Usage

## Dependencies 

`hdlmake`, `make`, `vivado`, `modelsim`, `python`, `chocolatey`, `winget`

## Installation

### Download python and git:
- [Install Chocolatey on Windows 10](https://gist.github.com/lopezjurip/2a188c90284bf239197b)

### Clone repository:
```bash
git clone https://github.com/RDSik/axis-i2c-slave.git
cd axis-i2c-slave
```

### Download packages:
```bash
pip install six
pip install hdlmake
```

### Download make (add to PATH system variable the Make bin folder: C:\Program Files (x86)\GnuWin32\bin):
```bash
winget install GnuWin32.make
```

## Build project

```bash
cd syn/
hdlmake
make
```
