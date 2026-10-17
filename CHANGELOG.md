# Changelog

Semua perubahan penting pada proyek ini didokumentasikan di file ini.
Format mengikuti [Keep a Changelog](https://keepachangelog.com/id/1.1.0/) dan [Semantic Versioning](https://semver.org/lang/id/).

## [2.1.0] - 2026-10-17

### Ditambahkan
- 🛑 **Layar peringatan risiko & keamanan** sebelum menu utama. Anda harus mengetik `Y` untuk lanjut; `N` keluar tanpa mengubah apa pun.
- 🆕 Menu **[10] Keamanan & Risiko** — halaman penjelasan lengkap: risiko per menu, apa yang **tidak** dilakukan script, pengaman yang tersedia, catatan antivirus/SmartScreen, dan cara pakai paling aman.
- ⚠️ Bagian **"Risiko & Keamanan"** di README (tabel risiko, daftar "yang tidak dilakukan script", cara pakai aman).
- ⚠️ Peringatan risiko ringkas di versi **klasik v1.1**.

### Diubah
- 🔢 Nomor versi: **v2.0 → v2.1** (versi berwarna), **v1.0 → v1.1** (versi klasik).
- 📝 Klaim keamanan dibuat lebih jujur: **"100% offline" ≠ "100% aman"**.
- 🧭 Menu utama sekarang `[0-10]` (sebelumnya `[0-9]`).

### Keamanan
- Tidak ada perubahan pada tweak. Rilis ini **hanya menambah peringatan dan informasi risiko**.
- Tetap: tidak menyentuh boot, tidak memformat partisi, tidak `sc delete`, tidak mematikan Defender/firewall, tidak mematikan IPv6.

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
