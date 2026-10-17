# Changelog

Semua perubahan penting pada proyek ini didokumentasikan di file ini.
Format mengikuti [Keep a Changelog](https://keepachangelog.com/id/1.1.0/) dan [Semantic Versioning](https://semver.org/lang/id/).

## [2.0.0] - 2026-10-17

### Ditambahkan
- 🎨 Versi **berwarna** (ANSI: ungu, hijau, kuning, cyan) + emoji + banner, bergaya Oneclick.
- 🌐 Halaman **Network Tweaks untuk Ethernet (IfType 6) DAN Wi-Fi (IfType 71)**.
- 🔌 Menu **Aktifkan Wi-Fi + Ethernet** (mengaktifkan semua adapter fisik).
- 🖥️ Submenu **GPU: NVIDIA / AMD / Intel** + detail lengkap semua GPU.
- 💾 Opsi buat System Restore Point dan backup Registry (HKLM + HKCU).
- 📝 Log aktivitas di `C:\Optimizer Logs`.
- 🧩 Backup registry adapter di `C:\Optimizer Backup\Network`.

### Diperbaiki
- `chcp 65001` tidak lagi menelan input.
- Jeda halaman memakai `set /p` (bukan `pause`) sehingga navigasi konsisten.
- Perbaikan deteksi adapter jaringan dan syntax pada blok tweak.

### Keamanan
- **IPv6 tidak dimatikan** agar Wi-Fi tetap normal.
- Service `WlanSvc` dan driver Wi-Fi **tidak pernah dimatikan**.
- 100% offline — tanpa download program/tool tambahan.

## [1.0.0] - 2026-10-17

### Ditambahkan
- Rilis awal: 10 halaman (Diagnostik, GPU, Jaringan, Disk, RAM, Power Plan, Services, Startup Manager, Maintenance, Restore Defaults).
