# ACNX Optimizer

> **ACNX Optimizer** (nama file: `ACNX777+ OPTIMIZER.bat`) — optimizer **PC / Laptop Windows** yang **100% offline**, tanpa install program tambahan dan tanpa download apa pun.

**ACNX Optimizer** adalah script `.bat` untuk optimasi **PC dan Laptop Windows**. Semua fitur memakai tool bawaan Windows: `powercfg`, `netsh`, `reg`, `sc`, `defrag`, dan PowerShell — jadi tidak butuh internet sama sekali.

🌐 **Situs:** https://acnx777.github.io/ACNXOptimizer/ — 📦 **Download:** [Releases](../../releases/latest)

> ⚠️ **Baca dulu:** script ini mengubah registry, service, dan jaringan Windows sebagai Administrator. **"100% offline" bukan berarti "100% aman".** Lihat bagian [Risiko & Keamanan](#️-risiko--keamanan) di bawah.

---

## ⬇️ Download

1. Buka halaman **[Releases](../../releases/latest)**.
2. Download file **`ACNX-Optimizer-v2.1.zip`**.
3. **Extract** ZIP-nya.
4. Jalankan **`ACNX777+ OPTIMIZER.bat`**.

> Versi terbaru selalu tersedia di halaman **Releases**.
> Lihat [CHANGELOG](CHANGELOG.md) untuk riwayat perubahan.

---

## ✨ Fitur

Menu berisi **10 halaman + submenu** — setiap halaman punya isi dan fungsi nyata:

| Menu | Isi |
|------|-----|
| **[1] Diagnostik Sistem** | Info OS, CPU, RAM, GPU, disk, adapter jaringan + simpan laporan ke Desktop |
| **[2] System Tweaks** | Efek visual untuk performa, GPU Scheduling, matikan telemetry / saran konten / GameDVR / Storage Sense, mouse acceleration off, long paths |
| **[3] Network Tweaks** | **Ethernet + Wi-Fi** (deteksi `IfType` 6 dan 71), aktifkan semua adapter, DNS + TCP, disable Nagle, tes ping, reset jaringan |
| **[4] GPU Tweaking** | **NVIDIA** (power limit, clock lock, persistence, Control Panel), **AMD** (Radeon Software, power plan), **Intel** (Graphics Command Center) |
| **[5] Services Tweaks** | Lihat status, tweak aman (telemetry), SysMain, Windows Search, layanan Xbox |
| **[6] Disk & RAM Cleanup** | Penggunaan disk, Disk Cleanup, defrag, bersihkan Temp/Prefetch/Update cache, trim working set, info modul RAM |
| **[7] Power Plan** | High / Balanced / Power Saver / Ultimate Performance, disk timeout, laporan baterai |
| **[8] Maintenance** | Restore Point, SFC /scannow, DISM RestoreHealth, CHKDSK, reset Windows Update, laporan driver |
| **[9] Restore Defaults** | Undo semua tweak — service, jaringan, power plan, visual, Nagle |
| **[10] Keamanan & Risiko** | Penjelasan risiko, apa yang **tidak** dilakukan script, catatan antivirus/SmartScreen, cara pakai paling aman |
| **[0] Keluar** | — |

Fitur tambahan:
- 🔒 **Otomatis minta hak Administrator** (UAC) saat dijalankan.
- 🛑 **Layar peringatan risiko** sebelum masuk menu — Anda harus mengetik `Y` untuk lanjut.
- 💾 Opsi **buat System Restore Point** dan **backup Registry** (HKLM + HKCU) sebelum tweak.
- 🌐 **Wi-Fi dan Ethernet sama-sama ON** (bukan ethernet-only).
- 📝 Log aktivitas di `C:\Optimizer Logs\Optimizer.txt`.
- 🧩 Backup registry adapter di `C:\Optimizer Backup\Network`.

---

## 📁 Dua versi

| File | Keterangan |
|------|------------|
| `ACNX777+ OPTIMIZER.bat` | Versi **berwarna** (ANSI: ungu, hijau, kuning, cyan) + emoji, **v2.1**. Versi utama / terbaru. |
| `ACNX777+ OPTIMIZER v1.bat` | Versi **klasik** (warna dasar, tampilan sederhana), **v1.1**. |

---

## ▶️ Cara pakai

1. Download file `.bat` yang diinginkan.
2. **Klik 2×** file-nya.
3. Saat muncul jendela **UAC** → klik **Yes**.
4. **Baca layar peringatan risiko** → ketik `Y` kalau sudah paham (`N` untuk keluar tanpa mengubah apa pun).
5. Pilih **Restore Point** dulu di layar Persiapan (**sangat disarankan**).
6. Pilih menu (angka), lalu ikuti instruksi.

> Untuk jalur GPU (power limit / clock lock), pastikan **driver GPU sudah terpasang**.
> Jalankan **satu menu per satu**, lalu reboot — jangan semua sekaligus.

Alternatif: klik kanan file → **Run as administrator**.

---

## 🧰 Persyaratan

- Windows 10 / Windows 11 (64-bit disarankan)
- Hak Administrator
- Tidak butuh internet (semua offline)

---

## ⚠️ Risiko & Keamanan

Script ini mengubah **registry**, **service Windows**, dan **konfigurasi jaringan** dengan hak Administrator. Karena itu **tidak ada script optimizer yang bisa disebut "100% aman"** — termasuk yang ini. Yang **100%** di sini hanya sifat **offline**-nya: script tidak mengunduh apa pun dari internet.

### Risiko utama

| Menu | Tindakan | Risiko nyata |
|------|----------|--------------|
| **[3] Reset Jaringan** | `netsh winsock reset`, `netsh int ip reset`, `ipv4/ipv6 reset` | **Seluruh stack jaringan kembali ke default.** VPN, DNS custom, IP statis, dan proxy bisa **hilang**. Wajib reboot. Sesekali Wi-Fi perlu di-setup ulang. |
| **[5] Services Tweaks** | Menonaktifkan `DiagTrack`, `dmwappushservice`, `Fax`, `SysMain`, `WSearch`, layanan Xbox | **Permanen** sampai di-restore. Windows Search mati → pencarian file/Start lambat. SysMain mati → buka aplikasi lebih lambat (khususnya HDD). Layanan Xbox mati → game Microsoft Store bisa tidak jalan. |
| **[6] Hapus Temp/Prefetch** | `del /f /s /q` + `rd /s /q` di Temp, `C:\Windows\Temp`, Prefetch, cache Windows Update | **Tidak bisa dikembalikan** (tidak masuk Recycle Bin). Tanpa Prefetch, aplikasi pertama kali dibuka lebih lambat. Cache update dihapus → update harus diunduh ulang. |
| **[4] GPU Tweaking** | `nvidia-smi -pl` (power limit), `nvidia-smi -lgc` (clock lock) | Power limit turun relatif aman. **Clock lock bisa membuat driver crash / black screen / reboot** kalau nilainya salah. |
| **[2] System Tweaks** | HAGS (`HwSchMode=2`), `NetworkThrottlingIndex` off, telemetry off | Di sebagian driver/game HAGS justru bikin **stutter**. Network throttling dimatikan bisa bikin jaringan **kurang stabil** di sebagian sistem. Matikan telemetry/service bisa **bertentangan dengan kebijakan kantor/sekolah**. |
| **Hak Administrator** | Seluruh script | Kalau script berhenti di tengah jalan, Windows bisa tertinggal **setengah tertweak**. |

### Yang TIDAK dilakukan script ini

- ✅ Tidak menyentuh boot (tidak ada `bcdedit` / `bootsect`)
- ✅ Tidak memformat atau menghapus partisi
- ✅ Tidak menghapus service (tidak ada `sc delete`) — hanya menonaktifkan
- ✅ Tidak mematikan Windows Defender atau firewall
- ✅ Tidak mematikan IPv6 (Wi-Fi tetap normal)
- ✅ Tidak mengirim data ke internet (100% offline)

### Pengaman yang tersedia

- 🛡️ **Restore Point otomatis** (layar Persiapan, atau menu [8])
- 🛡️ **Backup registry** HKLM + HKCU → `C:\Optimizer Backup\Registry`
- 🛡️ **Backup registry adapter** → `C:\Optimizer Backup\Network`
- 🛡️ **Menu [9] Restore Defaults** untuk membatalkan semua tweak
- 🛡️ Konfirmasi **Y/N** sebelum tindakan berbahaya

> **Catatan:** Restore Point hanya berisi registry dan file sistem — **BUKAN data pribadi Anda**. Kalau System Protection sedang mati, restore point bisa gagal dibuat.

### 🦠 Antivirus & SmartScreen

File `.bat` yang mengubah registry memang sering dicurigai antivirus atau diblokir Windows SmartScreen. Pada script ini umumnya **false positive**, karena:

- Sumbernya **terbuka** (open source, MIT) — silakan baca isinya sendiri.
- **100% offline** — tidak ada koneksi keluar, tidak ada download.
- Hanya memakai tool bawaan Windows (`reg`, `sc`, `netsh`, `powercfg`).

**Unduh hanya dari halaman resmi:** https://github.com/ACNX777/ACNXOptimizer/releases/latest

### Cara pakai paling aman

1. Buat **Restore Point** dulu (layar Persiapan).
2. **Tes di VM** (VirtualBox / VMware) kalau memungkinkan.
3. Jangan jalankan semua menu sekaligus — satu per satu, lalu reboot.
4. Kalau Anda tidak nyaman dengan risikonya: **jangan jalankan**.

---

## 🙏 Kredit

- **Tampilan & gaya warna** terinspirasi dari **Oneclick V8.4** oleh **Quaked** (TikTok `_Quaked_`). Kode ditulis ulang, bukan salinan.
- Terima kasih untuk komunitas optimizer Windows yang sudah berbagi ilmu.

---

## 🤝 Kontribusi

Pull request, laporan bug, dan saran fitur sangat diterima.
Silakan buka **Issue** atau kirim **Pull Request**.

---

## 📜 Lisensi

Dirilis di bawah **MIT License** — bebas dipakai, diubah, dan disebarkan (wajib mencantumkan lisensi ini).
Software disediakan **"AS IS"**, tanpa jaminan apa pun. Lihat file [LICENSE](LICENSE) untuk detail.
