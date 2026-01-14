# ESP32-S3 Squeezelite Audio Project

## 📋 Project Overview

**Project Name:** ESP32S3AUDIO_NATIVE (Squeezelite-ESP32)  
**Target Hardware:** ESP32-S3 N16R8 (16MB Flash, 8MB PSRAM Octal)  
**ESP-IDF Version:** v4.4.8 (REQUIRED - cspot/Spotify incompatible with v5.x)  
**Last Updated:** 2026-01-12  
**Status:** ✅ WORKING

## ⚠️ CRITICAL FILES - DO NOT DELETE!

| File | Why it's critical |
|------|-------------------|
| `sdkconfig` | Main config - ESP32-S3, 16MB Flash, PSRAM Octal |
| `partitions.csv` | 16MB partition layout with ota_0 |
| `sdkconfig.esp32s3` | Backup of critical settings |
| `flash_with_env.ps1` | Flashes to ota_0 (0x1D0000) |

**⚠️ WARNING:** `sdkconfig.defaults` is OLD (for ESP32 4MB) - IGNORE IT! Use `sdkconfig` only!

## 🎵 Features

- **Squeezelite** - LMS (Logitech Media Server) compatible player
- **Spotify Connect** (CSpot) - Native Spotify streaming
- **AirPlay** - Apple AirPlay receiver
- **I2S Audio Output** - DAC connection (BCK:17, WS:18, DO:19)
- **OTA Updates** - Over-the-air firmware updates supported
- **Web Interface** - Configuration via browser

## ⚙️ Hardware Configuration

```
MCU:        ESP32-S3
Flash:      16MB (GD chip, QIO mode, 80MHz)
PSRAM:      8MB Octal (AP Memory, 40MHz)
            - CONFIG_SPIRAM_MODE_OCT=y
            - CONFIG_SPIRAM_SPEED_40M=y
I2S DAC:    BCK=GPIO17, WS=GPIO18, DO=GPIO19
```

## 📦 Partition Table (16MB Flash)

```
# Name      Type    SubType   Offset      Size        Description
nvs         data    nvs       0x9000      0x40000     256KB - NVS storage
otadata     data    ota       0x49000     0x2000      8KB - OTA boot info
phy_init    data    phy       0x4B000     0x1000      4KB - WiFi calibration
recovery    app     factory   0x50000     0x180000    1.5MB - Recovery (factory)
ota_0       app     ota_0     0x1D0000    0xC30000    ~12MB - Main Squeezelite app
settings    data    nvs       0xE00000    0x200000    2MB - Settings storage
```

**IMPORTANT:** Main application (squeezelite.bin) MUST be flashed to `ota_0` partition at address `0x1D0000`, NOT to recovery!

## 🔧 Build & Flash Commands

### Using PowerShell Scripts (Recommended)

```powershell
# Build project
.\build_with_env.ps1

# Flash to device (automatically targets ota_0)
.\flash_with_env.ps1 -Port COM13 -Baud 460800

# Full flash (bootloader + partition table + ota_data + app)
.\flash_with_env.ps1 -Port COM13 -Baud 460800 -FullFlash

# Monitor serial output
.\monitor_with_env.ps1 -Port COM13
```

### Manual Commands (ESP-IDF 4.4)

```powershell
# Setup environment
$env:IDF_PATH = "C:\Espressif\frameworks\esp-idf-v4.4"
$env:IDF_PYTHON_ENV_PATH = "C:\Espressif\python_env\idf4.4_py3.9_env"
$env:Path = "C:\Espressif\tools\xtensa-esp32s3-elf\esp-2021r2-patch5-8.4.0\xtensa-esp32s3-elf\bin;C:\Espressif\tools\cmake\3.23.1\bin;C:\Espressif\tools\ninja\1.10.2;$env:IDF_PYTHON_ENV_PATH\Scripts;$env:IDF_PATH\tools;C:\WINDOWS\system32;C:\WINDOWS"

# Build
idf.py build

# Flash to ota_0 partition
python C:\Espressif\frameworks\esp-idf-v4.4\components\esptool_py\esptool\esptool.py `
    -p COM13 -b 460800 --chip esp32s3 write_flash --flash_mode dio --flash_freq 80m `
    0x0 build\bootloader\bootloader.bin `
    0x8000 build\partition_table\partition-table.bin `
    0x49000 build\ota_data_initial.bin `
    0x1D0000 build\squeezelite.bin
```

## 📁 Project Structure

```
source/
├── CMakeLists.txt          # Main CMake configuration
├── partitions.csv          # Partition table (16MB layout)
├── sdkconfig               # ESP-IDF configuration
├── build_with_env.ps1      # Build script (IDF 4.4)
├── flash_with_env.ps1      # Flash script (targets ota_0)
├── monitor_with_env.ps1    # Serial monitor script
├── PROJECT_INFO.md         # This file
├── main/                   # Main application source
├── components/             # ESP-IDF components
│   ├── squeezelite/        # Squeezelite core
│   ├── spotify/            # CSpot (Spotify Connect)
│   ├── raop/               # AirPlay support
│   └── ...
└── build/                  # Build output
    ├── squeezelite.bin     # Main application (~2.1MB)
    ├── bootloader/
    ├── partition_table/
    └── ota_data_initial.bin
```

## 🔄 Change History

### 2026-01-12 - MAJOR FIX: Partition Table & Boot

**Problem:** Device was booting to RECOVERY mode instead of Squeezelite main app

**Root Cause:** 
1. Original partition table missing `ota_0` partition
2. Default `idf.py flash` was flashing to `recovery` (factory) partition at 0x50000
3. Recovery partition too small (1.5MB) for full Squeezelite app (~2.1MB)

**Solution:**
1. Redesigned partition table for 16MB flash with proper ota_0 partition
2. Modified flash_with_env.ps1 to use esptool directly and target ota_0 (0x1D0000)
3. Flash addresses:
   - Bootloader: 0x0
   - Partition table: 0x8000
   - OTA data: 0x49000
   - **Squeezelite app: 0x1D0000 (ota_0)**

### 2026-01-12 - PSRAM Fix

**Problem:** Guru Meditation Error: StoreProhibited during boot

**Solution:** Enabled PSRAM with Octal 40MHz mode in sdkconfig:
```
CONFIG_SPIRAM=y
CONFIG_SPIRAM_MODE_OCT=y
CONFIG_SPIRAM_SPEED_40M=y
```

## 🌐 Network Configuration

- **WiFi SSID:** SGC (saved in NVS)
- **IP Address:** 192.168.1.155 (DHCP)
- **mDNS Name:** squeezelite-141694
- **LMS Server:** 192.168.1.14:3483

## 📡 Services Running

| Service | Port | Status |
|---------|------|--------|
| HTTP Server | 80 | ✅ Running |
| Spotify (CSpot) | 80 (ZeroConf) | ✅ Running |
| AirPlay | 9000 | ✅ Running |
| Telnet | - | ❌ Disabled |
| LMS Connection | 3483 | ✅ Connected |

## 📝 TODO / Future Improvements

- [ ] Configure I2C for display support
- [ ] Add LED status indicators
- [ ] Configure SPI for additional peripherals
- [ ] Add battery monitoring (if needed)
- [ ] Test OTA update functionality
- [ ] Add recovery mode web interface
- [ ] Configure display driver (optional)

## ⚠️ Known Issues / Warnings

1. **addr2line warning in monitor** - Monitor uses wrong toolchain prefix (`xtensa-esp32-elf-` instead of `xtensa-esp32s3-elf-`). This is cosmetic only and doesn't affect operation.

2. **Factory partition not bootable** - Expected warning, recovery partition is intentionally small. Device boots from ota_0.

3. **No I2C/SPI configured** - Hardware not connected, can be configured if display/peripherals added.

## 🔑 Critical Configuration Notes

1. **ESP-IDF Version:** MUST use v4.4.x (not v5.x) - cspot library incompatible with v5.x
2. **PSRAM:** MUST be enabled in Octal 40MHz mode for ESP32-S3 N16R8
3. **Flash Address:** ALWAYS flash main app to 0x1D0000 (ota_0), NOT 0x50000 (recovery)
4. **C++ Exceptions:** Must be enabled for cspot compatibility
5. **NVS:** Do not erase nvs partition - contains WiFi credentials and settings

## 📊 Memory Usage (at boot)

```
Heap internal: 260KB free (min: 260KB)
Heap external: 8.3MB free (min: 8.3MB) - PSRAM
DMA: 252KB free
SPIRAM: 8MB total, pool reserved: 32KB internal + 8192KB external
```

## 🎛️ Audio Configuration (autoexec)

```
squeezelite -o I2S -b 500:2000 -d all=info -C 30 -W
```

- `-o I2S` - I2S output device
- `-b 500:2000` - Buffer sizes (stream:output)
- `-d all=info` - Debug level info for all components
- `-C 30` - Close output after 30 seconds of silence
- `-W` - Synchronize audio with server time

## 📚 References

- [Squeezelite-ESP32 GitHub](https://github.com/sle118/squeezelite-esp32)
- [ESP-IDF v4.4 Documentation](https://docs.espressif.com/projects/esp-idf/en/v4.4/)
- [ESP32-S3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf)
