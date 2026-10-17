@echo off
setlocal EnableExtensions EnableDelayedExpansion
title ACNX777+ OPTIMIZER v1.1

:: ============================================================
::  ACNX777+ OPTIMIZER
::  Setiap halaman memiliki isi dan fungsi nyata.
::  Jalankan sebagai Administrator (otomatis minta elevasi).
:: ============================================================

:: ---------- CEK ADMIN ----------
net session >nul 2>&1
if %errorlevel%==0 goto :ADMIN_OK
echo.
echo   [i] Skrip ini butuh hak Administrator.
echo   [i] Meminta elevasi UAC...
timeout /t 2 >nul
powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b

:ADMIN_OK
cls

:: ============================================================
::  PERINGATAN RISIKO DAN KEAMANAN
:: ============================================================
call :HDR "PERINGATAN RISIKO DAN KEAMANAN"
echo   Script ini berjalan sebagai Administrator dan mengubah
echo   registry Windows, service Windows, dan konfigurasi jaringan.
echo.
echo   Maka dari itu script ini TIDAK bisa disebut "100%% aman".
echo.
echo   [1] Reset jaringan (menu 3)  : VPN, DNS custom, IP statis bisa hilang.
echo   [2] Matikan service (menu 7) : Windows Search / SysMain / Xbox jadi lambat.
echo   [3] Hapus file (menu 4)      : Temp, Prefetch, cache update. Tidak bisa kembali.
echo   [4] Tweak GPU (menu 2)       : clock lock salah bisa crash atau black screen.
echo   [5] Antivirus / SmartScreen bisa memperingatkan (umumnya false positive).
echo.
echo   Pengaman: Restore Point, backup registry, dan menu [10] Restore Defaults.
echo   Restore Point hanya registry dan file sistem, BUKAN data pribadi Anda.
echo.
set /p "cw1=  Ketik Y kalau sudah paham, N untuk keluar: "
if /i not "%cw1%"=="Y" exit /b
cls

:: ============================================================
::  MENU UTAMA
:: ============================================================
:MENU
color 0B
cls
call :HDR "ACNX777+ OPTIMIZER  v1.1"
echo   [1]  Diagnostik Sistem / System Info
echo   [2]  GPU Tweaking        - NVIDIA / AMD / Intel
echo   [3]  Optimasi Jaringan   - Network / Internet
echo   [4]  Optimasi Disk       - Storage / Cleanup
echo   [5]  Optimasi RAM        - Memori
echo   [6]  Power Plan          - Daya / Baterai
echo   [7]  Windows Services    - Tweaks
echo   [8]  Startup Manager
echo   [9]  Maintenance         - Restore Point / SFC / DISM
echo   [10] Restore Defaults    - Undo semua tweak
echo   [0]  Keluar
echo.
set "m="
set /p "m=  Pilih menu [0-10]: "
if not defined m goto :MENU
if "%m%"=="0"  goto :EXIT
if "%m%"=="1"  goto :SYSINFO
if "%m%"=="2"  goto :GPUMENU
if "%m%"=="3"  goto :NETMENU
if "%m%"=="4"  goto :DISKMENU
if "%m%"=="5"  goto :RAMMENU
if "%m%"=="6"  goto :POWERMENU
if "%m%"=="7"  goto :SVCMENU
if "%m%"=="8"  goto :STARTMENU
if "%m%"=="9"  goto :MAINTMENU
if "%m%"=="10" goto :RESTOREMENU
echo.
echo   [!] Pilihan tidak valid.
timeout /t 1 >nul
goto :MENU

:: ============================================================
::  1. DIAGNOSTIK SISTEM
:: ============================================================
:SYSINFO
color 0E
cls
call :HDR "DIAGNOSTIK SISTEM"
echo  -- SISTEM OPERASI --
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber,OSArchitecture | Format-List"
echo  -- CPU --
powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed | Format-List"
echo  -- RAM --
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $t=[math]::Round($os.TotalVisibleMemorySize/1MB,2); $f=[math]::Round($os.FreePhysicalMemory/1MB,2); Write-Host ('  Total RAM : ' + $t + ' GB'); Write-Host ('  Terpakai  : ' + [math]::Round($t-$f,2) + ' GB'); Write-Host ('  Bebas     : ' + $f + ' GB')"
echo  -- GPU --
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion,VideoProcessor | Format-List"
echo  -- DISK --
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{n='SizeGB';e={[math]::Round($_.Size/1GB,2)}},@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,2)}} | Format-Table -AutoSize"
echo  -- UPTIME --
powershell -NoProfile -Command "$b=(Get-CimInstance Win32_OperatingSystem).LastBootUpTime; Write-Host ('  Boot   : ' + $b); Write-Host ('  Uptime : ' + ((Get-Date)-$b).ToString())"
echo.
echo  ------------------------------------------------------------
echo   [1] Refresh   [2] Export laporan ke Desktop   [0] Kembali
echo  ------------------------------------------------------------
set "si="
set /p "si=  Pilih [0-2]: "
if "%si%"=="1" goto :SYSINFO
if "%si%"=="2" goto :SYS_EXPORT
goto :MENU

:SYS_EXPORT
set "RP=%USERPROFILE%\Desktop\SystemReport.txt"
powershell -NoProfile -Command "systeminfo | Out-File -Encoding UTF8 '%RP%'" >nul 2>&1
echo.
echo   [OK] Laporan disimpan di: %RP%
echo.
pause
goto :SYSINFO

:: ============================================================
::  2. GPU TWEAKING
:: ============================================================
:GPUMENU
color 0A
cls
call :HDR "GPU TWEAKING"
echo   GPU terdeteksi:
echo   ------------------------------------------------------------
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host ('   - ' + $_.Name) }"
echo   ------------------------------------------------------------
echo.
echo   [1] NVIDIA  - Info, Power Limit, Clock Lock, Control Panel
echo   [2] AMD     - Info, Radeon Software, Power Tuning
echo   [3] Intel   - Info, Graphics Command Center
echo   [4] Detail lengkap semua GPU
echo   [0] Kembali
echo.
set "g="
set /p "g=  Pilih [0-4]: "
if "%g%"=="0" goto :MENU
if "%g%"=="1" goto :GPU_NVIDIA
if "%g%"=="2" goto :GPU_AMD
if "%g%"=="3" goto :GPU_INTEL
if "%g%"=="4" goto :GPU_DETAIL
goto :GPUMENU

:GPU_DETAIL
color 0A
cls
call :HDR "DETAIL GPU"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select-Object Name,VideoProcessor,@{n='VRAM_GB';e={[math]::Round($_.AdapterRAM/1GB,2)}},DriverVersion,DriverDate,CurrentHorizontalResolution,CurrentVerticalResolution,CurrentRefreshRate,Status | Format-List"
echo.
pause
goto :GPUMENU

:: ---------- NVIDIA ----------
:GPU_NVIDIA
color 0A
cls
call :HDR "NVIDIA GPU TWEAKING"
where nvidia-smi >nul 2>&1
if errorlevel 1 goto :NV_NOSMI
echo   [OK] nvidia-smi terdeteksi.
echo.
nvidia-smi
echo.
echo   [1] Set Power Limit
echo   [2] Query Power Limit / Clock saat ini
echo   [3] Kunci GPU Clock / Reset
echo   [4] Aktifkan Persistence Mode
echo   [5] Buka NVIDIA Control Panel
echo   [0] Kembali
echo.
set "n="
set /p "n=  Pilih [0-5]: "
if "%n%"=="0" goto :GPUMENU
if "%n%"=="1" goto :NV_PL
if "%n%"=="2" goto :NV_QUERY
if "%n%"=="3" goto :NV_CLOCK
if "%n%"=="4" goto :NV_PERSIST
if "%n%"=="5" goto :NV_CP
goto :GPU_NVIDIA

:NV_NOSMI
echo.
echo   [!] nvidia-smi tidak ditemukan.
echo       - Driver NVIDIA mungkin belum terpasang, atau
echo       - GPU ini bukan NVIDIA.
echo.
echo   [1] Coba buka NVIDIA Control Panel
echo   [0] Kembali
echo.
set "nn="
set /p "nn=  Pilih [0-1]: "
if "%nn%"=="1" goto :NV_CP
goto :GPUMENU

:NV_QUERY
cls
call :HDR "NVIDIA - QUERY"
nvidia-smi -q -d POWER | findstr /i "Power Limit"
echo.
nvidia-smi -q -d CLOCK | findstr /i "Graphics SM Memory"
echo.
pause
goto :GPU_NVIDIA

:NV_PL
cls
call :HDR "NVIDIA - SET POWER LIMIT"
echo   Batas power limit perangkat ini:
echo   ------------------------------------------------------------
nvidia-smi -q -d POWER | findstr /i "Power Limit"
echo   ------------------------------------------------------------
echo   Masukkan nilai watt (contoh: 150). Kosongkan untuk batal.
echo.
set "pl="
set /p "pl=  Watt: "
if not defined pl goto :GPU_NVIDIA
nvidia-smi -pm 1 >nul 2>&1
nvidia-smi -pl %pl%
if errorlevel 1 echo.
if errorlevel 1 echo   [!] GAGAL. Nilai di luar rentang aman, atau driver menolak.
if errorlevel 1 echo       Cek nilai Min/Max pada tabel di atas.
echo.
pause
goto :GPU_NVIDIA

:NV_CLOCK
cls
call :HDR "NVIDIA - CLOCK LOCK"
echo   Masukkan batas clock MHz. Format: MIN,MAX  (contoh: 300,1800)
echo   Ketik RESET untuk mengembalikan ke default.
echo.
set "cl="
set /p "cl=  Clock: "
if not defined cl goto :GPU_NVIDIA
if /i "%cl%"=="RESET" goto :NV_CLOCK_RESET
nvidia-smi -lgc %cl%
echo.
pause
goto :GPU_NVIDIA

:NV_CLOCK_RESET
nvidia-smi -rgc
echo.
echo   [OK] GPU clock dikembalikan ke default.
pause
goto :GPU_NVIDIA

:NV_PERSIST
echo.
nvidia-smi -pm 1
echo.
echo   [OK] Persistence Mode diaktifkan. Clock lebih stabil.
pause
goto :GPU_NVIDIA

:NV_CP
echo.
echo   Membuka NVIDIA Control Panel...
start "" "C:\Program Files\NVIDIA Corporation\Control Panel Client\nvcplui.exe" >nul 2>&1
if errorlevel 1 start "" nvcplui.exe >nul 2>&1
if errorlevel 1 start "" control.exe >nul 2>&1
echo   [OK] Jika panel tidak muncul, buka manual dari tray icon NVIDIA.
timeout /t 2 >nul
goto :GPU_NVIDIA

:: ---------- AMD ----------
:GPU_AMD
color 0C
cls
call :HDR "AMD GPU TWEAKING"
echo   -- Info GPU AMD --
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'AMD|Radeon|ATI' } | Select-Object Name,DriverVersion,VideoProcessor | Format-List"
echo   -- Rekomendasi performa --
echo   1. Buka AMD Software dan set:
echo        Gaming ^> Graphics ^> Radeon Anti-Lag : Enabled
echo        Gaming ^> Graphics ^> Radeon Chill     : Disabled
echo        Gaming ^> Graphics ^> Image Sharpening : Aktifkan bila perlu
echo        Performance ^> Tuning ^> Auto Tuning  : pilih mode yang stabil
echo   2. Untuk laptop: pastikan mode daya "High Performance".
echo.
echo   [1] Buka AMD Radeon Software
echo   [2] Set Power Plan High Performance
echo   [3] Info driver AMD saja
echo   [0] Kembali
echo.
set "a="
set /p "a=  Pilih [0-3]: "
if "%a%"=="0" goto :GPUMENU
if "%a%"=="1" goto :AMD_OPEN
if "%a%"=="2" goto :AMD_PWR
if "%a%"=="3" goto :AMD_INFO
goto :GPU_AMD

:AMD_OPEN
echo.
echo   Membuka AMD Radeon Software...
if exist "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe" start "" "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe"
if exist "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe" goto :AMD_DONE
setlocal DisableDelayedExpansion
start "" "shell:AppsFolder\AdvancedMicroDevicesInc-2.AMDRadeonSoftware_0a9344xs7nr4m!App" >nul 2>&1
endlocal
:AMD_DONE
echo   [OK] Jika tidak muncul, buka manual lewat Start Menu "AMD Software".
timeout /t 2 >nul
goto :GPU_AMD

:AMD_PWR
echo.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo   [OK] Power Plan diubah ke High Performance.
pause
goto :GPU_AMD

:AMD_INFO
cls
call :HDR "AMD - DRIVER INFO"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'AMD|Radeon|ATI' } | Select-Object Name,DriverVersion,DriverDate | Format-List"
pause
goto :GPU_AMD

:: ---------- INTEL ----------
:GPU_INTEL
color 09
cls
call :HDR "INTEL GPU TWEAKING"
echo   -- Info GPU Intel --
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'Intel' } | Select-Object Name,DriverVersion,VideoProcessor | Format-List"
echo   -- Rekomendasi performa Intel --
echo   1. Intel Graphics Command Center:
echo        System ^> Power ^> Power Plan : Maximum Performance
echo   2. Nonaktifkan penghemat daya panel untuk laptop saat dicolok.
echo   3. Untuk game: aktifkan "XeSS" bila didukung di menu game.
echo.
echo   [1] Buka Intel Graphics Command Center
echo   [2] Set Power Plan High Performance
echo   [3] Info driver Intel saja
echo   [0] Kembali
echo.
set "i="
set /p "i=  Pilih [0-3]: "
if "%i%"=="0" goto :GPUMENU
if "%i%"=="1" goto :INTEL_OPEN
if "%i%"=="2" goto :INTEL_PWR
if "%i%"=="3" goto :INTEL_INFO
goto :GPU_INTEL

:INTEL_OPEN
echo.
echo   Membuka Intel Graphics Command Center...
if exist "C:\Windows\System32\igfxEM.exe" start "" "C:\Windows\System32\igfxEM.exe"
if exist "C:\Windows\System32\igfxEM.exe" goto :INTEL_DONE
setlocal DisableDelayedExpansion
start "" "shell:AppsFolder\AppUp.IntelGraphicsExperience_8j3eq9eme6ctt!App" >nul 2>&1
endlocal
:INTEL_DONE
echo   [OK] Jika tidak muncul, buka manual lewat Start Menu.
timeout /t 2 >nul
goto :GPU_INTEL

:INTEL_PWR
echo.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo   [OK] Power Plan diubah ke High Performance.
pause
goto :GPU_INTEL

:INTEL_INFO
cls
call :HDR "INTEL - DRIVER INFO"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'Intel' } | Select-Object Name,DriverVersion,DriverDate | Format-List"
pause
goto :GPU_INTEL

:: ============================================================
::  3. OPTIMASI JARINGAN
:: ============================================================
:NETMENU
color 0A
cls
call :HDR "OPTIMASI JARINGAN"
echo   [1] Flush DNS + Register DNS
echo   [2] Tampilkan konfigurasi TCP saat ini
echo   [3] Set TCP Autotuning Normal (aman/rekomendasi)
echo   [4] Profil latency rendah (agresif)
echo   [5] Reset Winsock + TCP/IP (butuh reboot)
echo   [6] Tes ping / latency
echo   [7] Disable Nagle's Algorithm (latency game)
echo   [8] Tampilkan konfigurasi IP / adapter
echo   [0] Kembali
echo.
set "nt="
set /p "nt=  Pilih [0-8]: "
if "%nt%"=="0" goto :MENU
if "%nt%"=="1" goto :NET_FLUSH
if "%nt%"=="2" goto :NET_SHOW
if "%nt%"=="3" goto :NET_NORMAL
if "%nt%"=="4" goto :NET_AGGR
if "%nt%"=="5" goto :NET_RESET
if "%nt%"=="6" goto :NET_PING
if "%nt%"=="7" goto :NET_NAGLE
if "%nt%"=="8" goto :NET_IP
goto :NETMENU

:NET_FLUSH
cls
call :HDR "FLUSH DNS"
ipconfig /flushdns
ipconfig /registerdns
netsh winsock show catalog >nul 2>&1
echo.
echo   [OK] Cache DNS dibersihkan.
pause
goto :NETMENU

:NET_SHOW
cls
call :HDR "KONFIGURASI TCP/IP SAAT INI"
netsh int tcp show global
echo.
pause
goto :NETMENU

:NET_NORMAL
cls
call :HDR "TCP AUTOTUNING - NORMAL"
netsh int tcp set global autotuninglevel=normal
echo.
echo   [OK] Autotuning diatur ke normal.
pause
goto :NETMENU

:NET_AGGR
cls
call :HDR "PROFIL LATENCY RENDAH"
echo   Menerapkan profil agresif...
netsh int tcp set heuristics disabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=disabled
netsh int tcp set global ecncapability=disabled
netsh int tcp set global timestamps=disabled
netsh int tcp set supplemental Internet congestionprovider=ctcp
echo.
echo   [OK] Profil latency rendah diterapkan.
echo   [i] Gunakan menu Restore Defaults untuk mengembalikan.
pause
goto :NETMENU

:NET_RESET
cls
call :HDR "RESET WINSOCK + TCP/IP"
echo   [!] Tindakan ini me-reset stack jaringan ke default Windows.
echo       Koneksi akan terputus sementara. Perlu reboot.
echo.
set "rc="
set /p "rc=  Lanjutkan? [Y/N]: "
if /i not "%rc%"=="Y" goto :NETMENU
netsh winsock reset
netsh int ip reset
netsh int ipv4 reset
netsh int ipv6 reset
ipconfig /flushdns
echo.
echo   [OK] Selesai. Silakan reboot.
pause
goto :NETMENU

:NET_PING
cls
call :HDR "TES PING / LATENCY"
echo   Ping ke 8.8.8.8 (Google DNS):
ping -n 4 8.8.8.8
echo.
echo   Ping ke google.com (DNS + koneksi):
ping -n 4 google.com
echo.
echo   Tracert ringkas (5 hop pertama):
tracert -h 5 -w 1000 8.8.8.8
echo.
pause
goto :NETMENU

:NET_NAGLE
cls
call :HDR "DISABLE NAGLE'S ALGORITHM"
echo   Mengatur TcpAckFrequency=1 dan TCPNoDelay=1 pada semua interface...
echo.
powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord -Force; Set-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord -Force }; Write-Host '   [OK] Selesai. Reboot diperlukan.'"
echo.
pause
goto :NETMENU

:NET_IP
cls
call :HDR "KONFIGURASI IP / ADAPTER"
ipconfig /all
echo.
pause
goto :NETMENU

:: ============================================================
::  4. OPTIMASI DISK
:: ============================================================
:DISKMENU
color 0A
cls
call :HDR "OPTIMASI DISK / STORAGE"
echo   [1] Lihat penggunaan disk
echo   [2] Disk Cleanup (cleanmgr)
echo   [3] Optimize / Defrag drive sistem
echo   [4] Bersihkan Temp, Prefetch, Update Cache
echo   [5] DISM Component Cleanup
echo   [6] SFC /scannow
echo   [0] Kembali
echo.
set "d="
set /p "d=  Pilih [0-6]: "
if "%d%"=="0" goto :MENU
if "%d%"=="1" goto :DISK_USAGE
if "%d%"=="2" goto :DISK_CLEAN
if "%d%"=="3" goto :DISK_OPT
if "%d%"=="4" goto :DISK_TEMP
if "%d%"=="5" goto :DISK_DISM
if "%d%"=="6" goto :DISK_SFC
goto :DISKMENU

:DISK_USAGE
cls
call :HDR "PENGGUNAAN DISK"
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{n='SizeGB';e={[math]::Round($_.Size/1GB,2)}},@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,2)}},@{n='UsedPct';e={[math]::Round((($_.Size-$_.FreeSpace)/$_.Size)*100,1)}} | Format-Table -AutoSize"
echo.
pause
goto :DISKMENU

:DISK_CLEAN
cls
call :HDR "DISK CLEANUP"
echo   Membuka Disk Cleanup untuk drive %SystemDrive% ...
cleanmgr /d %SystemDrive%
echo.
echo   [OK] Jendela Disk Cleanup telah dibuka.
pause
goto :DISKMENU

:DISK_OPT
cls
call :HDR "OPTIMIZE / DEFRAG"
echo   Mengoptimalkan %SystemDrive% (otomatis sesuaikan SSD/HDD)...
echo.
defrag %SystemDrive% /O /V
echo.
echo   [OK] Selesai.
pause
goto :DISKMENU

:DISK_TEMP
cls
call :HDR "BERSIHKAN TEMP / PREFETCH / UPDATE CACHE"
echo   Membersihkan file sementara...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" >nul 2>&1
echo   [OK] Temp dibersihkan.
echo.
echo   Membersihkan Prefetch...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo   [OK] Prefetch dibersihkan.
echo.
echo   Membersihkan cache Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo   [OK] Selesai.
pause
goto :DISKMENU

:DISK_DISM
cls
call :HDR "DISM COMPONENT CLEANUP"
echo   Menjalankan DISM cleanup. Proses ini memakan waktu...
echo.
DISM /Online /Cleanup-Image /StartComponentCleanup
echo.
echo   [OK] Selesai.
pause
goto :DISKMENU

:DISK_SFC
cls
call :HDR "SFC / SCANNNOW"
echo   Memindai integritas file sistem. Mohon tunggu...
echo.
sfc /scannow
echo.
echo   [OK] Selesai.
pause
goto :DISKMENU

:: ============================================================
::  5. OPTIMASI RAM
:: ============================================================
:RAMMENU
color 0A
cls
call :HDR "OPTIMASI RAM / MEMORI"
echo   [1] Lihat penggunaan memori + top 10 proses
echo   [2] Trim Working Set (lepas RAM terpakai)
echo   [3] Kosongkan Standby Memory
echo   [4] Bersihkan Temp user
echo   [5] Info detail modul RAM
echo   [0] Kembali
echo.
set "r="
set /p "r=  Pilih [0-5]: "
if "%r%"=="0" goto :MENU
if "%r%"=="1" goto :RAM_VIEW
if "%r%"=="2" goto :RAM_TRIM
if "%r%"=="3" goto :RAM_STANDBY
if "%r%"=="4" goto :RAM_TEMP
if "%r%"=="5" goto :RAM_MODULE
goto :RAMMENU

:RAM_VIEW
cls
call :HDR "PENGGUNAAN MEMORI"
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $t=[math]::Round($os.TotalVisibleMemorySize/1MB,2); $f=[math]::Round($os.FreePhysicalMemory/1MB,2); Write-Host ('  Total: ' + $t + ' GB   Bebas: ' + $f + ' GB   Terpakai: ' + [math]::Round((($t-$f)/$t)*100,1) + ' pct'); Write-Host ''; Get-Process | Sort-Object WS -Descending | Select-Object -First 10 Name,@{n='RAM_MB';e={[math]::Round($_.WS/1MB,1)}},Id | Format-Table -AutoSize"
echo.
pause
goto :RAMMENU

:RAM_TRIM
cls
call :HDR "TRIM WORKING SET"
echo   Melepaskan working set proses yang tidak aktif...
powershell -NoProfile -Command "Get-Process | Where-Object { $_.WorkingSet64 -gt 20MB } | ForEach-Object { try { $_.MaxWorkingSet = $_.MaxWorkingSet } catch {} }; Write-Host '   [OK] Working set di-trim.'"
echo.
pause
goto :RAMMENU

:RAM_STANDBY
cls
call :HDR "KOSONGKAN STANDBY MEMORY"
where EmptyStandbyList.exe >nul 2>&1
if not errorlevel 1 goto :RAM_STANDBY_RUN
if exist "%SystemRoot%\System32\EmptyStandbyList.exe" goto :RAM_STANDBY_RUN
echo   [!] Alat EmptyStandbyList.exe tidak ditemukan.
echo.
echo   Cara mengaktifkan fitur ini:
echo   1. Unduh "EmptyStandbyList.exe" dari Sysinternals/RAMMap.
echo   2. Letakkan di folder yang ada di PATH, atau di C:\Windows\System32.
echo   3. Jalankan ulang menu ini.
echo.
echo   Catatan: standby memory NORMAL dan tidak berbahaya.
echo   Windows akan memakainya kembali bila dibutuhkan.
echo.
pause
goto :RAMMENU

:RAM_STANDBY_RUN
EmptyStandbyList.exe standbylist workingset modifiedpagelist priority0standbylist >nul 2>&1
echo   [OK] Standby memory dibersihkan.
pause
goto :RAMMENU

:RAM_TEMP
cls
call :HDR "BERSIHKAN TEMP USER"
del /f /s /q "%TEMP%\*.*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Temp\*.*" >nul 2>&1
echo   [OK] Temp user dibersihkan.
pause
goto :RAMMENU

:RAM_MODULE
cls
call :HDR "INFO MODUL RAM"
powershell -NoProfile -Command "Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel,DeviceLocator,@{n='SizeGB';e={[math]::Round($_.Capacity/1GB,2)}},Speed,Manufacturer | Format-Table -AutoSize"
echo.
pause
goto :RAMMENU

:: ============================================================
::  6. POWER PLAN
:: ============================================================
:POWERMENU
color 0A
cls
call :HDR "POWER PLAN / DAYA"
echo   [1] Tampilkan semua skema daya
echo   [2] High Performance
echo   [3] Balanced (seimbang)
echo   [4] Power Saver (hemat baterai)
echo   [5] Aktifkan Ultimate Performance
echo   [6] Hard disk tidak pernah sleep (AC)
echo   [7] Lihat baterai / status daya
echo   [0] Kembali
echo.
set "p="
set /p "p=  Pilih [0-7]: "
if "%p%"=="0" goto :MENU
if "%p%"=="1" goto :PWR_LIST
if "%p%"=="2" goto :PWR_HIGH
if "%p%"=="3" goto :PWR_BAL
if "%p%"=="4" goto :PWR_SAVER
if "%p%"=="5" goto :PWR_ULT
if "%p%"=="6" goto :PWR_DISK
if "%p%"=="7" goto :PWR_BAT
goto :POWERMENU

:PWR_LIST
cls
call :HDR "SKEMA DAYA"
powercfg /list
echo.
pause
goto :POWERMENU

:PWR_HIGH
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo.
echo   [OK] High Performance aktif.
pause
goto :POWERMENU

:PWR_BAL
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
echo.
echo   [OK] Balanced aktif.
pause
goto :POWERMENU

:PWR_SAVER
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
echo.
echo   [OK] Power Saver aktif.
pause
goto :POWERMENU

:PWR_ULT
cls
call :HDR "ULTIMATE PERFORMANCE"
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if errorlevel 1 echo   [!] Tidak didukung pada edisi Windows ini. Menggunakan High Performance.
if errorlevel 1 powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if errorlevel 1 goto :PWR_ULT_DONE
echo.
echo   [OK] Ultimate Performance aktif.
:PWR_ULT_DONE
pause
goto :POWERMENU

:PWR_DISK
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0
echo.
echo   [OK] Hard disk timeout AC/DC diset ke 0 (tidak pernah sleep).
pause
goto :POWERMENU

:PWR_BAT
cls
call :HDR "STATUS BATERAI / DAYA"
powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html" >nul 2>&1
echo   Laporan baterai dibuat di Desktop: battery-report.html
echo.
powercfg /a
echo.
pause
goto :POWERMENU

:: ============================================================
::  7. WINDOWS SERVICES
:: ============================================================
:SVCMENU
color 0A
cls
call :HDR "WINDOWS SERVICES TWEAKS"
echo   [1] Lihat status service terkait tweak
echo   [2] Terapkan tweak AMAN (matikan telemetry)
echo   [3] Nonaktifkan SysMain / Superfetch (SSD)
echo   [4] Nonaktifkan Windows Search (Indexing)
echo   [5] Nonaktifkan layanan Xbox
echo   [6] Kembalikan semua service ke default
echo   [0] Kembali
echo.
set "s="
set /p "s=  Pilih [0-6]: "
if "%s%"=="0" goto :MENU
if "%s%"=="1" goto :SVC_SHOW
if "%s%"=="2" goto :SVC_SAFE
if "%s%"=="3" goto :SVC_SYSMAIN
if "%s%"=="4" goto :SVC_SEARCH
if "%s%"=="5" goto :SVC_XBOX
if "%s%"=="6" goto :SVC_DEFAULT
goto :SVCMENU

:SVC_SHOW
cls
call :HDR "STATUS SERVICE"
echo   --- DiagTrack ---
sc query DiagTrack | findstr /i "STATE"
echo   --- dmwappushservice ---
sc query dmwappushservice | findstr /i "STATE"
echo   --- SysMain ---
sc query SysMain | findstr /i "STATE"
echo   --- WSearch ---
sc query WSearch | findstr /i "STATE"
echo   --- XblAuthManager ---
sc query XblAuthManager | findstr /i "STATE"
echo   --- XblGameSave ---
sc query XblGameSave | findstr /i "STATE"
echo   --- XboxNetApiSvc ---
sc query XboxNetApiSvc | findstr /i "STATE"
echo   --- Fax ---
sc query Fax | findstr /i "STATE"
echo.
pause
goto :SVCMENU

:SVC_SAFE
cls
call :HDR "TWEAK AMAN - MATIKAN TELEMETRY"
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc stop Fax >nul 2>&1
sc config Fax start= disabled >nul 2>&1
echo   [OK] DiagTrack, dmwappushservice, dan Fax dinonaktifkan.
pause
goto :SVCMENU

:SVC_SYSMAIN
cls
call :HDR "NONAKTIFKAN SYSMAIN"
echo   Catatan: SysMain berguna pada HDD, tapi bisa dimatikan pada SSD.
echo.
set "sm="
set /p "sm=  Lanjutkan? [Y/N]: "
if /i not "%sm%"=="Y" goto :SVCMENU
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
echo   [OK] SysMain dinonaktifkan.
pause
goto :SVCMENU

:SVC_SEARCH
cls
call :HDR "NONAKTIFKAN WINDOWS SEARCH"
echo   Catatan: Windows Search akan mati; pencarian Start Menu jadi lambat.
echo.
set "ws="
set /p "ws=  Lanjutkan? [Y/N]: "
if /i not "%ws%"=="Y" goto :SVCMENU
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
echo   [OK] Windows Search dinonaktifkan.
pause
goto :SVCMENU

:SVC_XBOX
cls
call :HDR "NONAKTIFKAN LAYANAN XBOX"
echo   Catatan: matikan hanya jika tidak memakai Xbox Game Pass / game Xbox.
echo.
set "xb="
set /p "xb=  Lanjutkan? [Y/N]: "
if /i not "%xb%"=="Y" goto :SVCMENU
sc stop XblAuthManager >nul 2>&1
sc config XblAuthManager start= disabled >nul 2>&1
sc stop XblGameSave >nul 2>&1
sc config XblGameSave start= disabled >nul 2>&1
sc stop XboxNetApiSvc >nul 2>&1
sc config XboxNetApiSvc start= disabled >nul 2>&1
echo   [OK] Layanan Xbox dinonaktifkan.
pause
goto :SVCMENU

:SVC_DEFAULT
cls
call :HDR "KEMBALIKAN SERVICE KE DEFAULT"
goto :RST_SVC

:: ============================================================
::  8. STARTUP MANAGER
:: ============================================================
:STARTMENU
color 0A
cls
call :HDR "STARTUP MANAGER"
echo   [1] Tampilkan item startup
echo   [2] Buka Task Manager (tab Startup)
echo   [3] Buka msconfig
echo   [4] Buka folder Startup user
echo   [0] Kembali
echo.
set "st="
set /p "st=  Pilih [0-4]: "
if "%st%"=="0" goto :MENU
if "%st%"=="1" goto :START_LIST
if "%st%"=="2" goto :START_TASKMGR
if "%st%"=="3" goto :START_MSCONFIG
if "%st%"=="4" goto :START_FOLDER
goto :STARTMENU

:START_LIST
cls
call :HDR "ITEM STARTUP"
powershell -NoProfile -Command "Get-CimInstance Win32_StartupCommand | Select-Object Name,Location,Command | Format-Table -AutoSize -Wrap"
echo.
pause
goto :STARTMENU

:START_TASKMGR
echo.
echo   Membuka Task Manager...
start "" taskmgr.exe
echo   [i] Klik tab "Startup apps" untuk mengelola.
timeout /t 2 >nul
goto :STARTMENU

:START_MSCONFIG
echo.
start "" msconfig.exe
echo   [i] Gunakan tab "Services" dan "Startup".
timeout /t 2 >nul
goto :STARTMENU

:START_FOLDER
echo.
start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
echo   [i] Letakkan shortcut di folder ini untuk auto-start. Hapus untuk menonaktifkan.
timeout /t 2 >nul
goto :STARTMENU

:: ============================================================
::  9. MAINTENANCE
:: ============================================================
:MAINTMENU
color 0A
cls
call :HDR "MAINTENANCE"
echo   [1] Buat System Restore Point
echo   [2] SFC /scannow
echo   [3] DISM RestoreHealth
echo   [4] Jadwalkan CHKDSK pada reboot
echo   [5] Reset komponen Windows Update
echo   [6] Update semua driver via Windows Update (buat laporan)
echo   [0] Kembali
echo.
set "mt="
set /p "mt=  Pilih [0-6]: "
if "%mt%"=="0" goto :MENU
if "%mt%"=="1" goto :MNT_RESTORE
if "%mt%"=="2" goto :DISK_SFC
if "%mt%"=="3" goto :MNT_DISM
if "%mt%"=="4" goto :MNT_CHKDSK
if "%mt%"=="5" goto :MNT_WU
if "%mt%"=="6" goto :MNT_DRV
goto :MAINTMENU

:MNT_RESTORE
cls
call :HDR "BUAT SYSTEM RESTORE POINT"
echo   Mengaktifkan System Protection dan membuat restore point...
echo.
powershell -NoProfile -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Optimizer Restore Point' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo   [OK] Restore point dibuat, lihat di: rstrui.exe
pause
goto :MAINTMENU

:MNT_DISM
cls
call :HDR "DISM RESTORE HEALTH"
echo   Menjalankan DISM /RestoreHealth. Proses lama, mohon tunggu...
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo   [OK] Selesai.
pause
goto :MAINTMENU

:MNT_CHKDSK
cls
call :HDR "JADWALKAN CHKDSK"
echo   [!] CHKDSK pada drive sistem akan berjalan saat reboot.
echo.
set "ck="
set /p "ck=  Lanjutkan? [Y/N]: "
if /i not "%ck%"=="Y" goto :MAINTMENU
echo Y | chkdsk %SystemDrive% /F
echo.
echo   [OK] CHKDSK dijadwalkan pada reboot berikutnya.
pause
goto :MAINTMENU

:MNT_WU
cls
call :HDR "RESET WINDOWS UPDATE"
echo   Menghentikan layanan dan mereset folder update...
net stop wuauserv >nul 2>&1
net stop cryptSvc >nul 2>&1
net stop bits >nul 2>&1
net stop msiserver >nul 2>&1
ren "%SystemRoot%\SoftwareDistribution" SoftwareDistribution.old >nul 2>&1
ren "%SystemRoot%\System32\catroot2" catroot2.old >nul 2>&1
net start wuauserv >nul 2>&1
net start cryptSvc >nul 2>&1
net start bits >nul 2>&1
net start msiserver >nul 2>&1
echo.
echo   [OK] Komponen Windows Update direset. Reboot direkomendasikan.
pause
goto :MAINTMENU

:MNT_DRV
cls
call :HDR "LAPORAN DRIVER"
powershell -NoProfile -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName } | Select-Object DeviceName,DriverVersion,DriverDate | Sort-Object DeviceName | Format-Table -AutoSize"
echo.
echo   [i] Gunakan Windows Update atau situs vendor untuk update driver.
pause
goto :MAINTMENU

:: ============================================================
::  10. RESTORE DEFAULTS
:: ============================================================
:RESTOREMENU
color 0E
cls
call :HDR "RESTORE DEFAULTS / UNDO"
echo   [1] Kembalikan semua service ke default
echo   [2] Reset jaringan ke default
echo   [3] Set power plan ke Balanced
echo   [4] Hapus tweak Nagle's Algorithm
echo   [5] Buka System Restore (rstrui)
echo   [0] Kembali
echo.
set "rs="
set /p "rs=  Pilih [0-5]: "
if "%rs%"=="0" goto :MENU
if "%rs%"=="1" goto :RST_SVC
if "%rs%"=="2" goto :RST_NET
if "%rs%"=="3" goto :RST_PWR
if "%rs%"=="4" goto :RST_NAGLE
if "%rs%"=="5" goto :RST_OPEN
goto :RESTOREMENU

:RST_SVC
cls
call :HDR "RESTORE SERVICE KE DEFAULT"
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1
sc config dmwappushservice start= demand >nul 2>&1
sc config Fax start= demand >nul 2>&1
sc config SysMain start= auto >nul 2>&1
sc start SysMain >nul 2>&1
sc config WSearch start= delayed-auto >nul 2>&1
sc start WSearch >nul 2>&1
sc config XblAuthManager start= demand >nul 2>&1
sc config XblGameSave start= demand >nul 2>&1
sc config XboxNetApiSvc start= demand >nul 2>&1
echo   [OK] Service dikembalikan ke default.
pause
if "%m%"=="7" goto :MENU
goto :RESTOREMENU

:RST_NET
cls
call :HDR "RESET JARINGAN KE DEFAULT"
netsh int tcp set heuristics default >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=default >nul 2>&1
netsh int tcp set global rss=default >nul 2>&1
netsh int tcp set global ecncapability=default >nul 2>&1
netsh int tcp set global timestamps=default >nul 2>&1
netsh int tcp reset >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo   [OK] Konfigurasi jaringan dikembalikan ke default.
pause
goto :RESTOREMENU

:RST_PWR
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
echo.
echo   [OK] Power plan: Balanced.
pause
goto :RESTOREMENU

:RST_NAGLE
cls
call :HDR "HAPUS TWEAK NAGLE"
powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Remove-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -ErrorAction SilentlyContinue; Remove-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -ErrorAction SilentlyContinue }; Write-Host '   [OK] Tweak Nagle dihapus. Reboot diperlukan.'"
echo.
pause
goto :RESTOREMENU

:RST_OPEN
echo.
start "" rstrui.exe
timeout /t 2 >nul
goto :RESTOREMENU

:: ============================================================
::  HEADER & EXIT
:: ============================================================
:HDR
echo ================================================================
echo    %~1
echo ================================================================
echo.
goto :eof

:EXIT
color 07
cls
echo.
echo   Terima kasih. Optimasi selesai. Reboot dianjurkan.
echo.
timeout /t 3 >nul
endlocal
exit /b
