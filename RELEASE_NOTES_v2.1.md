# ACNX Optimizer v2.1 — Peringatan Risiko & Keamanan

Rilis ini **tidak mengubah tweak apa pun**. Yang ditambahkan hanya **peringatan dan informasi risiko**, supaya pengguna tahu persis apa yang akan diubah sebelum menjalankannya.

> **"100% offline" bukan berarti "100% aman".** Script ini mengubah registry, service, dan jaringan Windows dengan hak Administrator. Sekarang hal itu dikatakan terus terang di dalam script.

## ✨ Yang baru di v2.1

- 🛑 **Layar peringatan risiko** muncul sebelum menu utama.
  Anda harus mengetik `Y` untuk lanjut. Ketik `N` untuk keluar **tanpa mengubah apa pun**.
- 🆕 **Menu [10] Keamanan & Risiko** — halaman penjelasan lengkap yang bisa dibuka kapan saja:
  - Risiko per menu (reset jaringan, service, hapus file, GPU clock lock, tweak sistem)
  - **Apa yang TIDAK dilakukan** script (boot, partisi, `sc delete`, Defender, firewall, IPv6)
  - Pengaman yang tersedia (Restore Point, backup registry, menu [9])
  - Catatan **antivirus / SmartScreen** (false positive)
  - Cara pakai paling aman
- 📄 **README** punya bagian **"Risiko & Keamanan"** dengan tabel risiko lengkap.
- ⚠️ Versi **klasik v1.1** juga mendapat peringatan risiko ringkas.

## ⚠️ Ringkasan risiko yang dijelaskan

| Menu | Risiko |
|------|--------|
| [3] Reset Jaringan | VPN, DNS custom, IP statis bisa hilang. Wajib reboot. |
| [5] Services Tweaks | Windows Search / SysMain / layanan Xbox jadi lambat. Permanen sampai di-restore. |
| [6] Hapus Temp/Prefetch | Tidak bisa dikembalikan. Aplikasi pertama kali lebih lambat. |
| [4] GPU Clock Lock | Nilai salah bisa bikin driver crash / black screen. |
| [2] System Tweaks | HAGS bisa bikin stutter; telemetry/service mati bisa bertentangan dengan kebijakan kantor. |

## ✅ Yang TIDAK dilakukan script

- Tidak menyentuh boot (tidak ada `bcdedit` / `bootsect`)
- Tidak memformat atau menghapus partisi
- Tidak menghapus service (tidak ada `sc delete`)
- Tidak mematikan Windows Defender atau firewall
- Tidak mematikan IPv6 (Wi-Fi tetap normal)
- Tidak mengirim data ke internet (100% offline)

## ⬇️ File di rilis ini

| File | Keterangan |
|------|------------|
| `ACNX-Optimizer-v2.1.zip` | Paket lengkap: 2 script + README + LICENSE + CHANGELOG |

## ▶️ Cara pakai

1. Download `ACNX-Optimizer-v2.1.zip` lalu **Extract**.
2. Klik 2× **`ACNX777+ OPTIMIZER.bat`**.
3. Saat muncul **UAC** → klik **Yes**.
4. **Baca layar peringatan risiko** → ketik `Y` kalau sudah paham.
5. Buat **Restore Point** di layar Persiapan (**sangat disarankan**).
6. Pilih menu (angka).

## 🧰 Persyaratan

- Windows 10 / Windows 11
- Hak Administrator
- Tidak butuh internet

## 🙏 Kredit

Tampilan terinspirasi **Oneclick V8.4** oleh **Quaked** (TikTok `_Quaked_`). Kode ditulis ulang.

## 📜 Lisensi

MIT License. Software disediakan **"AS IS"** tanpa jaminan apa pun.
