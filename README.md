# 🎵 Squeezelite-ESP32S3 (ESP-IDF 4.4)

[![ESP-IDF](https://img.shields.io/badge/ESP--IDF-v4.4.8-blue)](https://github.com/espressif/esp-idf)
[![ESP32-S3](https://img.shields.io/badge/ESP32--S3-N16R8-green)](https://www.espressif.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🇵🇱 Opis (Polski)

Fork projektu [squeezelite-esp32](https://github.com/sle118/squeezelite-esp32) zoptymalizowany dla **ESP32-S3 N16R8** (16MB Flash, 8MB PSRAM Octal) z ESP-IDF v4.4.8.

### ✨ Funkcje

- 🎶 **Logitech Media Server (LMS)** - pełna obsługa odtwarzacza Squeezelite
- 📱 **Spotify Connect** - streaming bezpośrednio ze Spotify (cspot)
- 🎧 **AirPlay** - obsługa AirPlay 1
- 📻 **Bluetooth** - odbiornik audio Bluetooth A2DP
- 🌐 **Web UI** - konfiguracja przez przeglądarkę
- 💡 **LED WS2812** - wskaźnik statusu RGB
- 🔊 **I2S DAC** - wyjście audio wysokiej jakości

### 🛠️ Wymagania

- **ESP-IDF v4.4.x** (wymagane dla kompatybilności z cspot/Spotify)
- **ESP32-S3** z minimum 4MB PSRAM (zalecane N16R8)
- **I2S DAC** (np. PCM5102, MAX98357A, UDA1334A)

### 📦 Szybki start

1. **Zainstaluj ESP-IDF v4.4:**
   ```powershell
   # Windows - użyj ESP-IDF Tools Installer
   ```

2. **Sklonuj repozytorium:**
   ```bash
   git clone https://github.com/kruzio1985/squeezelite-esp32s3-4.4.git
   cd squeezelite-esp32s3-4.4
   ```

3. **Skompiluj i wgraj:**
   ```powershell
   # Windows PowerShell
   .\build_with_env.ps1
   .\flash_with_env.ps1 -Port COM13 -Baud 460800
   ```

4. **Pierwsza konfiguracja:**
   - Podłącz się do WiFi hotspotu: `squeezelite-XXXXXX`
   - Otwórz `http://192.168.4.1`
   - Skonfiguruj WiFi i ustawienia audio

### ⚙️ Konfiguracja I2S DAC

Domyślna konfiguracja (NVS key: `dac_config`):
```
model=I2S,bck=17,ws=18,do=19
```

### 💡 Konfiguracja LED Status

W NVS Editor dodaj klucz `set_GPIO`:
```
48=green:ws2812
```

### 📊 Mapa partycji (16MB Flash)

| Partycja | Typ | Adres | Rozmiar |
|----------|-----|-------|---------|
| bootloader | - | 0x0 | 48KB |
| nvs | data | 0x9000 | 256KB |
| ota_0 | app | 0x1D0000 | ~7MB |
| ota_1 | app | 0x8E0000 | ~7MB |

### 🔗 Linki

- [Oryginalny projekt](https://github.com/sle118/squeezelite-esp32)
- [Logitech Media Server](https://lms-community.github.io/)
- [ESP-IDF Documentation](https://docs.espressif.com/projects/esp-idf/)

---

## 🇬🇧 Description (English)

A fork of [squeezelite-esp32](https://github.com/sle118/squeezelite-esp32) optimized for **ESP32-S3 N16R8** (16MB Flash, 8MB PSRAM Octal) with ESP-IDF v4.4.8.

### ✨ Features

- 🎶 **Logitech Media Server (LMS)** - full Squeezelite player support
- 📱 **Spotify Connect** - direct streaming from Spotify (cspot)
- 🎧 **AirPlay** - AirPlay 1 support
- 📻 **Bluetooth** - Bluetooth A2DP audio receiver
- 🌐 **Web UI** - browser-based configuration
- 💡 **WS2812 LED** - RGB status indicator
- 🔊 **I2S DAC** - high-quality audio output

### 🛠️ Requirements

- **ESP-IDF v4.4.x** (required for cspot/Spotify compatibility)
- **ESP32-S3** with minimum 4MB PSRAM (N16R8 recommended)
- **I2S DAC** (e.g., PCM5102, MAX98357A, UDA1334A)

### 📦 Quick Start

1. **Install ESP-IDF v4.4:**
   ```bash
   # Follow Espressif installation guide
   ```

2. **Clone repository:**
   ```bash
   git clone https://github.com/kruzio1985/squeezelite-esp32s3-4.4.git
   cd squeezelite-esp32s3-4.4
   ```

3. **Build and flash:**
   ```bash
   idf.py build
   idf.py -p /dev/ttyUSB0 flash
   ```

4. **First-time setup:**
   - Connect to WiFi hotspot: `squeezelite-XXXXXX`
   - Open `http://192.168.4.1`
   - Configure WiFi and audio settings

### ⚙️ I2S DAC Configuration

Default configuration (NVS key: `dac_config`):
```
model=I2S,bck=17,ws=18,do=19
```

### 💡 Status LED Configuration

In NVS Editor, add key `set_GPIO`:
```
48=green:ws2812
```

### 📄 License

This project is based on [squeezelite-esp32](https://github.com/sle118/squeezelite-esp32) and maintains the same license terms.

### 🙏 Credits

- [sle118/squeezelite-esp32](https://github.com/sle118/squeezelite-esp32) - Original project
- [feelfreelinux/cspot](https://github.com/feelfreelinux/cspot) - Spotify Connect implementation
- [ralph-irving/squeezelite](https://github.com/ralph-irving/squeezelite) - Original Squeezelite
