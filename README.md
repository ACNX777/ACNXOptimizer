# ACNX Optimizer

> **ACNX Optimizer** (nama file: `ACNX777+ OPTIMIZER.bat`) — optimizer **PC / Laptop Windows** yang **100% offline**, tanpa install program tambahan dan tanpa download apa pun.

**ACNX Optimizer** adalah script `.bat` untuk optimasi **PC dan Laptop Windows**. Semua fitur memakai tool bawaan Windows: `powercfg`, `netsh`, `reg`, `sc`, `defrag`, dan PowerShell — jadi tidak butuh internet sama sekali.

🌐 **Situs:** https://acnx777.github.io/ACNXOptimizer/ — 📦 **Download:** [Releases](../../releases/latest)

---

## ⬇️ Download

1. Buka halaman **[Releases](../../releases/latest)**.
2. Download file **`ACNX-Optimizer-v2.0.zip`**.
3. **Extract** ZIP-nya.
4. Jalankan **`ACNX777+ OPTIMIZER.bat`**.

> Versi terbaru selalu tersedia di halaman **Releases**.
> Lihat [CHANGELOG](CHANGELOG.md) untuk riwayat perubahan.

---

## ✨ Fitur

Menu berisi **9 halaman + submenu** — setiap halaman punya isi dan fungsi nyata:

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
| **[0] Keluar** | — |

Fitur tambahan:
- 🔒 **Otomatis minta hak Administrator** (UAC) saat dijalankan.
- 💾 Opsi **buat System Restore Point** dan **backup Registry** (HKLM + HKCU) sebelum tweak.
- 🌐 **Wi-Fi dan Ethernet sama-sama ON** (bukan ethernet-only).
- 📝 Log aktivitas di `C:\Optimizer Logs\Optimizer.txt`.
- 🧩 Backup registry adapter di `C:\Optimizer Backup\Network`.

---

## 📁 Dua versi

| File | Keterangan |
|------|------------|
| `ACNX777+ OPTIMIZER.bat` | Versi **berwarna** (ANSI: ungu, hijau, kuning, cyan) + emoji. Versi utama / terbaru. |
| `ACNX777+ OPTIMIZER v1.bat` | Versi **klasik** v1.0 (warna dasar, tampilan sederhana). |

---

## ▶️ Cara pakai

1. Download file `.bat` yang diinginkan.
2. **Klik 2×** file-nya.
3. Saat muncul jendela **UAC** → klik **Yes**.
4. Pilih menu (angka), lalu ikuti instruksi.

> Untuk jalur GPU (power limit / clock lock), pastikan **driver GPU sudah terpasang**.
> Untuk hasil maksimal, **restart PC** setelah tweak.

Alternatif: klik kanan file → **Run as administrator**.

---

## 🧰 Persyaratan

- Windows 10 / Windows 11 (64-bit disarankan)
- Hak Administrator
- Tidak butuh internet (semua offline)

---

## ⚠️ Peringatan / Disclaimer

Script ini mengubah **registry, service Windows, dan konfigurasi jaringan**.

- Gunakan **dengan risiko Anda sendiri**. Selalu buat **Restore Point** dulu (opsi ada di dalam script).
- Beberapa tweak bersifat agresif (menonaktifkan telemetry / service). Tidak semua cocok untuk semua PC.
- Software ini disediakan **"AS IS"** tanpa jaminan apa pun — lihat [LICENSE](LICENSE).
- **IPv6 tidak dimatikan** agar Wi-Fi tetap normal.

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
Lihat file [LICENSE](LICENSE) untuk detail.
