# Squeezelite-ESP32 Web Flash

Pliki firmware do flashowania przez przeglądarkę na ESP32-S3 N16R8.

## 📦 Zawartość

| Plik | Rozmiar | Opis |
|------|---------|------|
| `squeezelite_esp32s3_full.bin` | ~4MB | **GŁÓWNY** - Połączony plik (wszystko w jednym) |
| `bootloader.bin` | ~21KB | Bootloader |
| `partition-table.bin` | ~3KB | Tabela partycji |
| `ota_data_initial.bin` | ~8KB | Dane OTA |
| `squeezelite.bin` | ~2.1MB | Aplikacja główna |

## 🚀 Flashowanie przez Web

### Metoda 1: ESP Web Tools (jeden plik - NAJŁATWIEJSZE)

1. Otwórz: https://web.esptool.io/
2. Kliknij **Connect**
3. Wybierz port COM urządzenia
4. Kliknij **Erase Flash** (zalecane przy pierwszej instalacji)
5. Kliknij **Program**
6. Wybierz `squeezelite_esp32s3_full.bin`
7. Adres: **0x0**
8. Kliknij **Program**

### Metoda 2: Adafruit ESPTool (jeden plik)

1. Otwórz: https://adafruit.github.io/Adafruit_WebSerial_ESPTool/
2. Connect → wybierz port
3. Ustaw offset: `0x0`
4. Wybierz: `squeezelite_esp32s3_full.bin`
5. Program

### Metoda 3: Osobne pliki (zaawansowane)

Jeśli web flasher obsługuje wiele plików, użyj:

| Plik | Offset (hex) | Offset (dec) |
|------|--------------|--------------|
| `bootloader.bin` | 0x0 | 0 |
| `partition-table.bin` | 0x8000 | 32768 |
| `ota_data_initial.bin` | 0x49000 | 299008 |
| `squeezelite.bin` | 0x1D0000 | 1900544 |

## ⚠️ Wymagania sprzętowe

- **MCU:** ESP32-S3
- **Flash:** 16MB (minimum)
- **PSRAM:** 8MB Octal (zalecane N16R8)

## 🔧 Po flashowaniu

1. Urządzenie uruchomi się i utworzy hotspot WiFi: `squeezelite-XXXXXX`
2. Połącz się z hotspotem
3. Otwórz http://192.168.4.1 w przeglądarce
4. Skonfiguruj WiFi i ustawienia audio

## 📡 Funkcje

- ✅ Squeezelite (LMS player)
- ✅ Spotify Connect (CSpot)
- ✅ AirPlay
- ✅ I2S DAC output (GPIO 17/18/19)
- ✅ Web UI configuration
- ✅ OTA updates

## 📋 Informacje o buildzie

- **ESP-IDF:** v4.4.8
- **Data:** 2026-01-12
- **Target:** ESP32-S3 N16R8
- **Flash mode:** DIO 80MHz
- **PSRAM:** Octal 40MHz

## 🔗 Przydatne linki

- [ESP Web Flasher](https://web.esptool.io/)
- [Adafruit WebSerial ESPTool](https://adafruit.github.io/Adafruit_WebSerial_ESPTool/)
- [Squeezelite-ESP32 GitHub](https://github.com/sle118/squeezelite-esp32)
