:: ============================================================
::  ACNX777+ OPTIMIZER - Oneclick Style - OFFLINE EDITION
::  Warna: ANSI. Kotak/emoji: UTF-8. 100% offline, tanpa download.
::  Network Tweaks: Ethernet (IfType 6) + WiFi (IfType 71)
:: ============================================================
:: Baris komentar di atas sengaja ditaruh paling awal.
@echo off
setlocal EnableExtensions
title ACNX777+ OPTIMIZER - Oneclick Style - Offline Edition

:: ---------- CEK ADMIN ----------
fltmc >nul 2>&1
if not "%errorlevel%"=="0" (
    powershell -NoProfile -Command "Write-Host 'ACNX777+ OPTIMIZER harus dijalankan sebagai Administrator.' -ForegroundColor White -BackgroundColor Red"
    powershell -NoProfile -Command "Write-Host 'Klik YES pada jendela UAC berikutnya!' -ForegroundColor White -BackgroundColor Red"
    timeout 3 >nul
    powershell -NoProfile Start -Verb RunAs '%0'
    exit /b 0
)

chcp 65001 >nul 2>&1 <nul

:: ---------- DEFINISI WARNA ANSI ----------
:: Karakter ESC (0x1B) ditulis sebagai byte literal, jadi tidak butuh child process.
set "Reset=[0m"
set "Black=[30m"
set "DarkRed=[31m"
set "DarkGreen=[32m"
set "DarkYellow=[33m"
set "DarkBlue=[34m"
set "DarkMagenta=[35m"
set "DarkCyan=[36m"
set "Gray=[37m"
set "DarkGray=[90m"
set "Red=[91m"
set "Green=[92m"
set "Yellow=[93m"
set "Blue=[94m"
set "Magenta=[95m"
set "Cyan=[96m"
set "White=[97m"
set "Bold=[1m"

:: ---------- FOLDER LOG & BACKUP ----------
if not exist "C:\Optimizer Logs" mkdir "C:\Optimizer Logs" >nul 2>&1
if not exist "C:\Optimizer Backup" mkdir "C:\Optimizer Backup" >nul 2>&1
echo [%DATE% %TIME%] Optimizer started. >> "C:\Optimizer Logs\Optimizer.txt"

:: ---------- PREFLIGHT ----------
:PREFLIGHT
cls
call :BANNER
echo %White%  [Persiapan]
echo.
echo   %Green%1.%White% Buat System Restore Point %DarkGray%(sangat disarankan)%Reset%
echo   %Green%2.%White% Backup Registry %DarkGray%(HKLM + HKCU)%Reset%
echo   %Green%3.%White% Langsung mulai tanpa backup
echo.
set /p "p=%Cyan%  Pilih [1-3]: "
if "%p%"=="1" goto :PF_RESTORE
if "%p%"=="2" goto :PF_REG_DO
if "%p%"=="3" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :PREFLIGHT

:PF_RESTORE
cls
call :HDR "MEMBUAT SYSTEM RESTORE POINT"
echo %Cyan%  Mengaktifkan System Protection dan membuat restore point...
echo.
powershell -NoProfile -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Optimizer Restore Point' -RestorePointType 'MODIFY_SETTINGS'"
if "%errorlevel%"=="0" (
    echo %Green%  OK - Restore point berhasil dibuat.%Reset%
) else (
    echo %Red%  GAGAL - Restore point tidak bisa dibuat.%Reset%
    echo %Yellow%  Lanjut tanpa restore point? Risiko tidak bisa undo.%Reset%
)
echo.
set /p "p=%Cyan%  Lanjut? [Y/N]: "
if /i not "%p%"=="Y" goto :PREFLIGHT
goto :MENU

:PF_REG_DO
cls
call :HDR "BACKUP REGISTRY"
echo %Cyan%  Mengekspor HKLM dan HKCU ke C:\Optimizer Backup\Registry ...
mkdir "C:\Optimizer Backup\Registry" >nul 2>&1
reg export "HKLM" "C:\Optimizer Backup\Registry\HKLM.reg" /y >nul 2>&1
reg export "HKCU" "C:\Optimizer Backup\Registry\HKCU.reg" /y >nul 2>&1
if exist "C:\Optimizer Backup\Registry\HKLM.reg" (
    echo %Green%  OK - Backup registry dibuat.%Reset%
) else (
    echo %Red%  GAGAL - Tidak bisa membuat backup registry.%Reset%
)
echo.
set /p "p=%Cyan%  Lanjut ke menu utama? [Y/N]: "
if /i not "%p%"=="Y" goto :PREFLIGHT
goto :MENU

:: ============================================================
::  MENU UTAMA
:: ============================================================
:MENU
cls
call :BANNER
echo %White%  Pilih halaman:
echo.
echo   %Green%[1] %White%Diagnostik Sistem
echo   %Green%[2] %White%System Tweaks %DarkGray%(visual, performa, telemetry)%Reset%
echo   %Green%[3] %White%Network Tweaks %DarkCyan%(Ethernet + WiFi)%Reset%
echo   %Green%[4] %White%GPU Tweaking %DarkGray%(NVIDIA / AMD / Intel)%Reset%
echo   %Green%[5] %White%Services Tweaks
echo   %Green%[6] %White%Disk dan RAM Cleanup
echo   %Green%[7] %White%Power Plan
echo   %Green%[8] %White%Maintenance %DarkGray%(SFC / DISM / Restore Point)%Reset%
echo   %Green%[9] %White%Restore Defaults %DarkGray%(undo semua tweak)%Reset%
echo   %Red%[0] %White%Keluar
echo.
set /p "m=%Cyan%  Pilih [0-9]: "
if "%m%"=="1" goto :SYSINFO
if "%m%"=="2" goto :SYSTWEAK
if "%m%"=="3" goto :NETMENU
if "%m%"=="4" goto :GPUMENU
if "%m%"=="5" goto :SVCMENU
if "%m%"=="6" goto :CLEANMENU
if "%m%"=="7" goto :POWERMENU
if "%m%"=="8" goto :MAINTMENU
if "%m%"=="9" goto :RESTOREMENU
if "%m%"=="0" goto :EXIT
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :MENU

:: ============================================================
::  1. DIAGNOSTIK SISTEM
:: ============================================================
:SYSINFO
cls
call :HDR "DIAGNOSTIK SISTEM"
echo %Yellow%  -- Sistem Operasi --
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber,OSArchitecture | Format-List"
echo %Yellow%  -- CPU --
powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed | Format-List"
echo %Yellow%  -- RAM --
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $t=[math]::Round($os.TotalVisibleMemorySize/1MB,2); $f=[math]::Round($os.FreePhysicalMemory/1MB,2); Write-Host ('  Total   : ' + $t + ' GB'); Write-Host ('  Terpakai: ' + [math]::Round($t-$f,2) + ' GB'); Write-Host ('  Bebas   : ' + $f + ' GB')"
echo %Yellow%  -- GPU --
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion | Format-List"
echo %Yellow%  -- Jaringan --
powershell -NoProfile -Command "Get-NetAdapter | Select-Object Name,InterfaceDescription,Status,LinkSpeed | Format-Table -AutoSize"
echo %Yellow%  -- Disk --
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{n='SizeGB';e={[math]::Round($_.Size/1GB,2)}},@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,2)}} | Format-Table -AutoSize"
echo.
echo   %Green%[1]%White% Refresh    %Green%[2]%White% Simpan laporan ke Desktop    %Red%[0]%White% Kembali
echo.
set /p "s=%Cyan%  Pilih [0-2]: "
if "%s%"=="1" goto :SYSINFO
if "%s%"=="2" goto :SYS_EXPORT
goto :MENU

:SYS_EXPORT
set "RP=%USERPROFILE%\Desktop\Optimizer-SystemReport.txt"
echo.
echo %Cyan%  Menyimpan laporan...
powershell -NoProfile -Command "systeminfo | Out-File -Encoding UTF8 '%RP%'" >nul 2>&1
echo %Green%  OK - Laporan disimpan: %RP%
call :PAUSE_RET
goto :SYSINFO

:: ============================================================
::  2. SYSTEM TWEAKS
:: ============================================================
:SYSTWEAK
cls
call :HDR "SYSTEM TWEAKS"
echo %Cyan%  Tweaks yang akan diterapkan:
echo   %White%- Tampilkan ekstensi file dan file tersembunyi
echo   %White%- Matikan animasi, transparansi dan efek visual berat
echo   %White%- Aktifkan Hardware Accelerated GPU Scheduling dan Optimizations for Windowed Games
echo   %White%- Matikan GameDVR, Game Mode, Storage Sense
echo   %White%- Matikan telemetry, saran konten, iklan dan aktivitas
echo   %White%- Matikan mouse acceleration
echo   %White%- Aktifkan Long Paths
echo   %White%- Menu klik-kanan gaya Windows 10
echo.
echo %Yellow%  Lanjutkan? %White%[Y/N]
set /p "c=%Cyan%  Pilihan: "
if /i not "%c%"=="Y" goto :MENU
cls
call :HDR "MENERAPKAN SYSTEM TWEAKS"
echo.
echo %Green%  - Ekstensi file + file tersembunyi
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1
echo %Green%  - Efek visual untuk performa
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "200" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1
echo %Green%  - Long paths
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
echo %Green%  - GameDVR + Game Mode off
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %Green%  - GPU Scheduling + Windowed Games
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;" /f >nul 2>&1
echo %Green%  - Telemetry + saran konten off
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
echo %Green%  - Feedback + Storage Sense off
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "0" /f >nul 2>&1
echo %Green%  - Mouse acceleration off
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo %Green%  - Menu klik-kanan gaya Windows 10
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >nul 2>&1
echo %Green%  - Multimedia responsiveness + Network throttling index
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
echo.
echo %Green%  OK - System Tweaks selesai. Restart Explorer atau reboot dianjurkan.%Reset%
echo %DarkGray%  Catatan: IPv6 TIDAK dimatikan supaya WiFi tetap normal.%Reset%
echo [%DATE% %TIME%] System tweaks applied. >> "C:\Optimizer Logs\Optimizer.txt"
call :PAUSE_RET
goto :MENU

:: ============================================================
::  3. NETWORK TWEAKS  (ETHERNET + WIFI)
:: ============================================================
:NETMENU
cls
call :HDR "NETWORK - ETHERNET + WIFI"
powershell -NoProfile -Command "Get-NetAdapter | Select-Object Name,InterfaceDescription,Status,LinkSpeed | Format-Table -AutoSize"
echo   %Green%[1] %White%Aktifkan Wi-Fi + Ethernet %DarkGray%(pastikan dua-duanya ON)%Reset%
echo   %Green%[2] %White%Network Tweaks %DarkCyan%(Ethernet IfType 6 + WiFi IfType 71)%Reset%
echo   %Green%[3] %White%DNS + TCP global %DarkGray%(flush, autotuning)%Reset%
echo   %Green%[4] %White%Disable Nagle %DarkGray%(latency game)%Reset%
echo   %Green%[5] %White%Lihat konfigurasi TCP/IP
echo   %Green%[6] %White%Tes ping / latency
echo   %Yellow%[7] %White%Reset jaringan ke default
echo   %Red%[0] %White%Kembali
echo.
set /p "n=%Cyan%  Pilih [0-7]: "
if "%n%"=="1" goto :NET_ENABLE
if "%n%"=="2" goto :NET_TWEAK
if "%n%"=="3" goto :NET_DNS
if "%n%"=="4" goto :NET_NAGLE
if "%n%"=="5" goto :NET_SHOW
if "%n%"=="6" goto :NET_PING
if "%n%"=="7" goto :NET_RESET
if "%n%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :NETMENU

:NET_ENABLE
cls
call :HDR "AKTIFKAN WIFI + ETHERNET"
echo %Cyan%  Mengaktifkan service jaringan penting...
sc config WlanSvc start= auto >nul 2>&1
net start WlanSvc >nul 2>&1
sc config dot3svc start= demand >nul 2>&1
sc config Dhcp start= auto >nul 2>&1
net start Dhcp >nul 2>&1
sc config Dnscache start= auto >nul 2>&1
net start Dnscache >nul 2>&1
sc config NlaSvc start= auto >nul 2>&1
net start NlaSvc >nul 2>&1
sc config netprofm start= auto >nul 2>&1
net start netprofm >nul 2>&1
sc config nsi start= auto >nul 2>&1
net start nsi >nul 2>&1
sc config WlanSvc start= auto >nul 2>&1
echo %Green%  - Service WLAN, DHCP, DNS, NLA: OK
echo %Green%  - Mengaktifkan semua adapter fisik %DarkGray%(Wi-Fi + Ethernet)%Reset%
powershell -NoProfile -Command "Get-NetAdapter | Where-Object { $_.HardwareInterface } | Enable-NetAdapter -Confirm:$false -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2; Get-NetAdapter | Select-Object Name,InterfaceDescription,Status,LinkSpeed | Format-Table -AutoSize"
echo.
echo %Green%  OK - Wi-Fi dan Ethernet dalam keadaan ON.%Reset%
echo [%DATE% %TIME%] Network adapters enabled. >> "C:\Optimizer Logs\Optimizer.txt"
call :PAUSE_RET
goto :NETMENU

:NET_TWEAK
cls
call :HDR "NETWORK TWEAKS - ETHERNET + WIFI"
echo %Cyan%  Tweaks ini berlaku untuk SEMUA adapter fisik:
echo   %White%Ethernet %DarkGray%(IfType 6)%White%  dan  Wi-Fi %DarkGray%(IfType 71)%Reset%
echo %DarkGray%  (Bukan ethernet-only. Wi-Fi ikut di-tweak.)%Reset%
echo.
echo %Yellow%  Risiko: koneksi bisa terputus sesaat. Lanjutkan? %White%[Y/N]
set /p "conf=%Cyan%  Pilihan: "
if /i not "%conf%"=="Y" goto :NETMENU
cls
call :HDR "MENERAPKAN NETWORK TWEAKS"
setlocal EnableExtensions EnableDelayedExpansion
set "NICLIST=%TEMP%\Optimizer_NIC_List.txt"
type nul > "!NICLIST!" 2>nul
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /v "*IfType" /s 2^>nul ^| findstr "HKEY"') do (
    reg query "%%a" /v "*IfType" 2>nul | findstr /r /i /c:"0x0*6$" /c:"0x0*47$" >nul && echo %%a>>"!NICLIST!"
)
if not exist "C:\Optimizer Backup\Network" mkdir "C:\Optimizer Backup\Network" >nul 2>&1
set "NICN=0"
set "NICBK=0"
for /f "usebackq delims=" %%a in ("!NICLIST!") do (
    set /a NICN+=1
    echo %Green%  📶 Adapter !NICN! : %White%%%a
    call :NIC_BACKUP "%%a"
    call :NIC_SET "%%a" "*ReceiveBuffers"            REG_SZ    2048
    call :NIC_SET "%%a" "*TransmitBuffers"           REG_SZ    1024
    call :NIC_SET "%%a" "*DeviceSleepOnDisconnect"   REG_SZ    0
    call :NIC_SET "%%a" "*EEE"                       REG_SZ    0
    call :NIC_SET "%%a" "*SelectiveSuspend"          REG_SZ    0
    call :NIC_SET "%%a" "*WakeOnMagicPacket"         REG_SZ    0
    call :NIC_SET "%%a" "*WakeOnPattern"             REG_SZ    0
    call :NIC_SET "%%a" "*PMWiFiRekeyOffload"        REG_SZ    0
    call :NIC_SET "%%a" "EnablePME"                  REG_SZ    0
    call :NIC_SET "%%a" "AutoPowerSaveModeEnabled"   REG_SZ    0
    call :NIC_SET "%%a" "EEELinkAdvertisement"       REG_SZ    0
    call :NIC_SET "%%a" "EeePhyEnable"               REG_SZ    0
    call :NIC_SET "%%a" "EnableGreenEthernet"        REG_SZ    0
    call :NIC_SET "%%a" "PowerDownPll"               REG_SZ    0
    call :NIC_SET "%%a" "PowerSavingMode"            REG_SZ    0
    call :NIC_SET "%%a" "ReduceSpeedOnPowerDown"     REG_SZ    0
    call :NIC_SET "%%a" "PnPCapabilities"            REG_DWORD 24
    echo.
)
endlocal
echo.
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo %Green%  ✔  Network Tweaks selesai untuk Ethernet dan Wi-Fi.%Reset%
echo %DarkGray%  Backup registry adapter tersimpan di C:\Optimizer Backup\Network%Reset%
echo [%DATE% %TIME%] Network tweaks applied to Ethernet + WiFi. >> "C:\Optimizer Logs\Optimizer.txt"
call :PAUSE_RET
goto :NETMENU

:NET_DNS
cls
call :HDR "DNS + TCP GLOBAL"
ipconfig /flushdns
ipconfig /registerdns >nul 2>&1
netsh int tcp set global autotuninglevel=normal
echo.
echo %Green%  OK - Cache DNS dibersihkan, autotuning normal.%Reset%
call :PAUSE_RET
goto :NETMENU

:NET_NAGLE
cls
call :HDR "DISABLE NAGLE'S ALGORITHM"
echo %Cyan%  Set TcpAckFrequency=1 dan TCPNoDelay=1 pada semua interface...
echo.
powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord -Force; Set-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord -Force }; Write-Host '  OK - Selesai. Reboot diperlukan.'"
echo.
call :PAUSE_RET
goto :NETMENU

:NET_SHOW
cls
call :HDR "KONFIGURASI TCP/IP"
netsh int tcp show global
echo.
call :PAUSE_RET
goto :NETMENU

:NET_PING
cls
call :HDR "TES PING / LATENCY"
echo %Cyan%  Ping 8.8.8.8:
ping -n 4 8.8.8.8
echo.
echo %Cyan%  Ping google.com:
ping -n 4 google.com
echo.
echo %Cyan%  Tracert 5 hop:
tracert -h 5 -w 1000 8.8.8.8
echo.
call :PAUSE_RET
goto :NETMENU

:NET_RESET
cls
call :HDR "RESET JARINGAN KE DEFAULT"
echo %Yellow%  Tindakan ini me-reset stack jaringan ke default Windows.
echo %Yellow%  Koneksi terputus sementara dan perlu reboot.%Reset%
echo.
set /p "rc=%Cyan%  Lanjutkan? [Y/N]: "
if /i not "%rc%"=="Y" goto :NETMENU
netsh winsock reset
netsh int ip reset
netsh int ipv4 reset
netsh int ipv6 reset
netsh int tcp set heuristics default >nul 2>&1
netsh int tcp reset >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo.
echo %Green%  OK - Selesai. Silakan reboot.%Reset%
call :PAUSE_RET
goto :NETMENU

:: ============================================================
::  4. GPU TWEAKING
:: ============================================================
:GPUMENU
cls
call :HDR "GPU TWEAKING"
echo %Cyan%  GPU terdeteksi:
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host ('   - ' + $_.Name) }"
echo.
echo   %Green%[1] %White%NVIDIA  %DarkGray%- Info, Power Limit, Clock Lock, Control Panel%Reset%
echo   %Green%[2] %White%AMD     %DarkGray%- Info, Radeon Software, Power Tuning%Reset%
echo   %Green%[3] %White%Intel   %DarkGray%- Info, Graphics Command Center%Reset%
echo   %Green%[4] %White%Detail lengkap semua GPU
echo   %Red%[0] %White%Kembali
echo.
set /p "g=%Cyan%  Pilih [0-4]: "
if "%g%"=="1" goto :GPU_NVIDIA
if "%g%"=="2" goto :GPU_AMD
if "%g%"=="3" goto :GPU_INTEL
if "%g%"=="4" goto :GPU_DETAIL
if "%g%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :GPUMENU

:GPU_DETAIL
cls
call :HDR "DETAIL GPU"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select-Object Name,VideoProcessor,@{n='VRAM_GB';e={[math]::Round($_.AdapterRAM/1GB,2)}},DriverVersion,DriverDate,CurrentHorizontalResolution,CurrentVerticalResolution,CurrentRefreshRate,Status | Format-List"
call :PAUSE_RET
goto :GPUMENU

:GPU_NVIDIA
cls
call :HDR "NVIDIA GPU TWEAKING"
where nvidia-smi >nul 2>&1
if errorlevel 1 goto :NV_NOSMI
echo %Green%  OK - nvidia-smi terdeteksi.%Reset%
echo.
nvidia-smi
echo.
echo   %Green%[1]%White% Set Power Limit        %Green%[2]%White% Query Power Limit / Clock
echo   %Green%[3]%White% Kunci / Reset GPU Clock %Green%[4]%White% Aktifkan Persistence Mode
echo   %Green%[5]%White% Buka NVIDIA Control Panel %Red%[0]%White% Kembali
echo.
set /p "n=%Cyan%  Pilih [0-5]: "
if "%n%"=="1" goto :NV_PL
if "%n%"=="2" goto :NV_QUERY
if "%n%"=="3" goto :NV_CLOCK
if "%n%"=="4" goto :NV_PERSIST
if "%n%"=="5" goto :NV_CP
if "%n%"=="0" goto :GPUMENU
goto :GPU_NVIDIA

:NV_NOSMI
echo.
echo %Yellow%  nvidia-smi tidak ditemukan.
echo   Driver NVIDIA mungkin belum terpasang, atau GPU bukan NVIDIA.%Reset%
echo.
echo   %Green%[1]%White% Coba buka NVIDIA Control Panel   %Red%[0]%White% Kembali
echo.
set /p "nn=%Cyan%  Pilih [0-1]: "
if "%nn%"=="1" goto :NV_CP
goto :GPUMENU

:NV_QUERY
cls
call :HDR "NVIDIA - QUERY"
nvidia-smi -q -d POWER | findstr /i "Power Limit"
echo.
nvidia-smi -q -d CLOCK | findstr /i "Graphics SM Memory"
echo.
call :PAUSE_RET
goto :GPU_NVIDIA

:NV_PL
cls
call :HDR "NVIDIA - SET POWER LIMIT"
echo %Cyan%  Batas power limit perangkat ini:
nvidia-smi -q -d POWER | findstr /i "Power Limit"
echo.
echo %White%  Masukkan nilai watt, contoh 150. Kosongkan untuk batal.
set /p "pl=%Cyan%  Watt: "
if not defined pl goto :GPU_NVIDIA
nvidia-smi -pm 1 >nul 2>&1
nvidia-smi -pl %pl%
if errorlevel 1 echo %Red%  GAGAL - nilai di luar rentang aman atau driver menolak.%Reset%
echo.
call :PAUSE_RET
goto :GPU_NVIDIA

:NV_CLOCK
cls
call :HDR "NVIDIA - CLOCK LOCK"
echo %White%  Masukkan batas clock MHz dengan format MIN,MAX, contoh 300,1800.
echo %White%  Ketik RESET untuk kembali ke default.
echo.
set /p "cl=%Cyan%  Clock: "
if not defined cl goto :GPU_NVIDIA
if /i "%cl%"=="RESET" goto :NV_CLOCK_RESET
nvidia-smi -lgc %cl%
echo.
call :PAUSE_RET
goto :GPU_NVIDIA

:NV_CLOCK_RESET
nvidia-smi -rgc
echo.
echo %Green%  OK - GPU clock kembali ke default.%Reset%
call :PAUSE_RET
goto :GPU_NVIDIA

:NV_PERSIST
echo.
nvidia-smi -pm 1
echo.
echo %Green%  OK - Persistence Mode aktif.%Reset%
call :PAUSE_RET
goto :GPU_NVIDIA

:NV_CP
echo.
echo %Cyan%  Membuka NVIDIA Control Panel...
start "" "C:\Program Files\NVIDIA Corporation\Control Panel Client\nvcplui.exe" >nul 2>&1
if errorlevel 1 start "" nvcplui.exe >nul 2>&1
if errorlevel 1 start "" control.exe >nul 2>&1
call :PAUSE_RET
goto :GPU_NVIDIA

:GPU_AMD
cls
call :HDR "AMD GPU TWEAKING"
echo %Yellow%  -- Info GPU AMD --
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'AMD|Radeon|ATI' } | Select-Object Name,DriverVersion,VideoProcessor | Format-List"
echo %Cyan%  Rekomendasi di AMD Software:
echo   %White%- Gaming - Graphics - Radeon Anti-Lag : Enabled
echo   %White%- Radeon Chill : Disabled
echo   %White%- Performance - Tuning - Auto Tuning : mode stabil
echo   %White%- Untuk laptop pakai mode daya High Performance
echo.
echo   %Green%[1]%White% Buka AMD Radeon Software   %Green%[2]%White% Power Plan High Performance
echo   %Green%[3]%White% Info driver AMD           %Red%[0]%White% Kembali
echo.
set /p "a=%Cyan%  Pilih [0-3]: "
if "%a%"=="1" goto :AMD_OPEN
if "%a%"=="2" goto :AMD_PWR
if "%a%"=="3" goto :AMD_INFO
if "%a%"=="0" goto :GPUMENU
goto :GPU_AMD

:AMD_OPEN
echo.
echo %Cyan%  Membuka AMD Radeon Software...
if exist "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe" start "" "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe"
if exist "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe" goto :AMD_DONE
setlocal DisableDelayedExpansion
start "" "shell:AppsFolder\AdvancedMicroDevicesInc-2.AMDRadeonSoftware_0a9344xs7nr4m!App" >nul 2>&1
endlocal
:AMD_DONE
call :PAUSE_RET
goto :GPU_AMD

:AMD_PWR
echo.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo %Green%  OK - Power Plan High Performance aktif.%Reset%
call :PAUSE_RET
goto :GPU_AMD

:AMD_INFO
cls
call :HDR "AMD - DRIVER INFO"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'AMD|Radeon|ATI' } | Select-Object Name,DriverVersion,DriverDate | Format-List"
call :PAUSE_RET
goto :GPU_AMD

:GPU_INTEL
cls
call :HDR "INTEL GPU TWEAKING"
echo %Yellow%  -- Info GPU Intel --
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'Intel' } | Select-Object Name,DriverVersion,VideoProcessor | Format-List"
echo %Cyan%  Rekomendasi:
echo   %White%- Intel Graphics Command Center - System - Power - Maximum Performance
echo   %White%- Matikan penghemat daya panel saat dicolok
echo.
echo   %Green%[1]%White% Buka Intel Graphics Command Center %Green%[2]%White% Power Plan High Performance
echo   %Green%[3]%White% Info driver Intel                 %Red%[0]%White% Kembali
echo.
set /p "i=%Cyan%  Pilih [0-3]: "
if "%i%"=="1" goto :INTEL_OPEN
if "%i%"=="2" goto :INTEL_PWR
if "%i%"=="3" goto :INTEL_INFO
if "%i%"=="0" goto :GPUMENU
goto :GPU_INTEL

:INTEL_OPEN
echo.
echo %Cyan%  Membuka Intel Graphics Command Center...
if exist "C:\Windows\System32\igfxEM.exe" start "" "C:\Windows\System32\igfxEM.exe"
if exist "C:\Windows\System32\igfxEM.exe" goto :INTEL_DONE
setlocal DisableDelayedExpansion
start "" "shell:AppsFolder\AppUp.IntelGraphicsExperience_8j3eq9eme6ctt!App" >nul 2>&1
endlocal
:INTEL_DONE
call :PAUSE_RET
goto :GPU_INTEL

:INTEL_PWR
echo.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo %Green%  OK - Power Plan High Performance aktif.%Reset%
call :PAUSE_RET
goto :GPU_INTEL

:INTEL_INFO
cls
call :HDR "INTEL - DRIVER INFO"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'Intel' } | Select-Object Name,DriverVersion,DriverDate | Format-List"
call :PAUSE_RET
goto :GPU_INTEL

:: ============================================================
::  5. SERVICES TWEAKS
:: ============================================================
:SVCMENU
cls
call :HDR "WINDOWS SERVICES TWEAKS"
echo %DarkGray%  Catatan: WlanSvc dan driver Wi-Fi TIDAK pernah dimatikan di sini.%Reset%
echo   %Green%[1]%White% Lihat status service terkait
echo   %Green%[2]%White% Tweak AMAN %DarkGray%(matikan telemetry + Fax)%Reset%
echo   %Green%[3]%White% Nonaktifkan SysMain %DarkGray%(untuk SSD)%Reset%
echo   %Green%[4]%White% Nonaktifkan Windows Search %DarkGray%(indexing)%Reset%
echo   %Green%[5]%White% Nonaktifkan layanan Xbox
echo   %Red%[0]%White% Kembali
echo.
set /p "s=%Cyan%  Pilih [0-5]: "
if "%s%"=="1" goto :SVC_SHOW
if "%s%"=="2" goto :SVC_SAFE
if "%s%"=="3" goto :SVC_SYSMAIN
if "%s%"=="4" goto :SVC_SEARCH
if "%s%"=="5" goto :SVC_XBOX
if "%s%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :SVCMENU

:SVC_SHOW
cls
call :HDR "STATUS SERVICE"
for %%S in (DiagTrack dmwappushservice SysMain WSearch WlanSvc dot3svc "XblAuthManager" "XblGameSave" "XboxNetApiSvc" Fax) do (
    echo %Yellow%  --- %%~S ---%Reset%
    sc query "%%~S" | findstr /i "STATE"
)
echo.
call :PAUSE_RET
goto :SVCMENU

:SVC_SAFE
cls
call :HDR "TWEAK AMAN - TELEMETRY OFF"
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc stop Fax >nul 2>&1
sc config Fax start= disabled >nul 2>&1
echo %Green%  OK - DiagTrack, dmwappushservice dan Fax dinonaktifkan.%Reset%
call :PAUSE_RET
goto :SVCMENU

:SVC_SYSMAIN
cls
call :HDR "NONAKTIFKAN SYSMAIN"
echo %Yellow%  SysMain berguna pada HDD, boleh dimatikan pada SSD.
set /p "sm=%Cyan%  Lanjutkan? [Y/N]: "
if /i not "%sm%"=="Y" goto :SVCMENU
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
echo %Green%  OK - SysMain dinonaktifkan.%Reset%
call :PAUSE_RET
goto :SVCMENU

:SVC_SEARCH
cls
call :HDR "NONAKTIFKAN WINDOWS SEARCH"
set /p "ws=%Cyan%  Pencarian jadi lambat. Lanjutkan? [Y/N]: "
if /i not "%ws%"=="Y" goto :SVCMENU
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
echo %Green%  OK - Windows Search dinonaktifkan.%Reset%
call :PAUSE_RET
goto :SVCMENU

:SVC_XBOX
cls
call :HDR "NONAKTIFKAN LAYANAN XBOX"
set /p "xb=%Cyan%  Hanya jika tidak pakai Game Pass. Lanjutkan? [Y/N]: "
if /i not "%xb%"=="Y" goto :SVCMENU
sc stop "XblAuthManager" >nul 2>&1
sc config "XblAuthManager" start= disabled >nul 2>&1
sc stop "XblGameSave" >nul 2>&1
sc config "XblGameSave" start= disabled >nul 2>&1
sc stop "XboxNetApiSvc" >nul 2>&1
sc config "XboxNetApiSvc" start= disabled >nul 2>&1
echo %Green%  OK - Layanan Xbox dinonaktifkan.%Reset%
call :PAUSE_RET
goto :SVCMENU

:: ============================================================
::  6. DISK DAN RAM CLEANUP
:: ============================================================
:CLEANMENU
cls
call :HDR "DISK DAN RAM CLEANUP"
echo   %Green%[1]%White% Lihat penggunaan disk
echo   %Green%[2]%White% Disk Cleanup %DarkGray%(cleanmgr)%Reset%
echo   %Green%[3]%White% Optimize / Defrag drive sistem
echo   %Green%[4]%White% Bersihkan Temp + Prefetch + Update Cache
echo   %Green%[5]%White% Lihat penggunaan RAM + top proses
echo   %Green%[6]%White% Trim Working Set %DarkGray%(lepas RAM)%Reset%
echo   %Green%[7]%White% Info modul RAM
echo   %Red%[0]%White% Kembali
echo.
set /p "d=%Cyan%  Pilih [0-7]: "
if "%d%"=="1" goto :CLN_DISKUSAGE
if "%d%"=="2" goto :CLN_DISKCLEAN
if "%d%"=="3" goto :CLN_DEFRAG
if "%d%"=="4" goto :CLN_TEMP
if "%d%"=="5" goto :CLN_RAMVIEW
if "%d%"=="6" goto :CLN_RAMTRIM
if "%d%"=="7" goto :CLN_RAMMODULE
if "%d%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :CLEANMENU

:CLN_DISKUSAGE
cls
call :HDR "PENGGUNAAN DISK"
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{n='SizeGB';e={[math]::Round($_.Size/1GB,2)}},@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,2)}},@{n='UsedPct';e={[math]::Round((($_.Size-$_.FreeSpace)/$_.Size)*100,1)}} | Format-Table -AutoSize"
echo.
call :PAUSE_RET
goto :CLEANMENU

:CLN_DISKCLEAN
cls
call :HDR "DISK CLEANUP"
echo %Cyan%  Membuka Disk Cleanup untuk %SystemDrive% ...
cleanmgr /d %SystemDrive%
echo.
echo %Green%  OK - Jendela Disk Cleanup dibuka.%Reset%
call :PAUSE_RET
goto :CLEANMENU

:CLN_DEFRAG
cls
call :HDR "OPTIMIZE / DEFRAG"
echo %Cyan%  Mengoptimalkan %SystemDrive%, otomatis sesuai SSD/HDD...
echo.
defrag %SystemDrive% /O /V
echo.
echo %Green%  OK - Selesai.%Reset%
call :PAUSE_RET
goto :CLEANMENU

:CLN_TEMP
cls
call :HDR "BERSIHKAN TEMP / PREFETCH / UPDATE CACHE"
echo %Cyan%  Membersihkan Temp user...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
echo %Cyan%  Membersihkan Windows Temp...
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" >nul 2>&1
echo %Cyan%  Membersihkan Prefetch...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo %Cyan%  Membersihkan cache Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo.
echo %Green%  OK - Selesai.%Reset%
call :PAUSE_RET
goto :CLEANMENU

:CLN_RAMVIEW
cls
call :HDR "PENGGUNAAN RAM"
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $t=[math]::Round($os.TotalVisibleMemorySize/1MB,2); $f=[math]::Round($os.FreePhysicalMemory/1MB,2); Write-Host ('  Total: ' + $t + ' GB   Bebas: ' + $f + ' GB   Terpakai: ' + [math]::Round((($t-$f)/$t)*100,1) + ' persen'); Write-Host ''; Get-Process | Sort-Object WS -Descending | Select-Object -First 10 Name,@{n='RAM_MB';e={[math]::Round($_.WS/1MB,1)}},Id | Format-Table -AutoSize"
echo.
call :PAUSE_RET
goto :CLEANMENU

:CLN_RAMTRIM
cls
call :HDR "TRIM WORKING SET"
echo %Cyan%  Melepaskan working set proses yang tidak aktif...
powershell -NoProfile -Command "Get-Process | Where-Object { $_.WorkingSet64 -gt 20MB } | ForEach-Object { try { $_.MaxWorkingSet = $_.MaxWorkingSet } catch {} }; Write-Host '  OK - Working set di-trim.'"
echo.
call :PAUSE_RET
goto :CLEANMENU

:CLN_RAMMODULE
cls
call :HDR "INFO MODUL RAM"
powershell -NoProfile -Command "Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel,DeviceLocator,@{n='SizeGB';e={[math]::Round($_.Capacity/1GB,2)}},Speed,Manufacturer | Format-Table -AutoSize"
echo.
call :PAUSE_RET
goto :CLEANMENU

:: ============================================================
::  7. POWER PLAN
:: ============================================================
:POWERMENU
cls
call :HDR "POWER PLAN"
echo   %Green%[1]%White% Tampilkan semua skema daya
echo   %Green%[2]%White% High Performance
echo   %Green%[3]%White% Balanced
echo   %Green%[4]%White% Power Saver
echo   %Green%[5]%White% Aktifkan Ultimate Performance
echo   %Green%[6]%White% Hard disk tidak pernah sleep %DarkGray%(AC)%Reset%
echo   %Green%[7]%White% Laporan baterai
echo   %Red%[0]%White% Kembali
echo.
set /p "p=%Cyan%  Pilih [0-7]: "
if "%p%"=="1" goto :PWR_LIST
if "%p%"=="2" goto :PWR_HIGH
if "%p%"=="3" goto :PWR_BAL
if "%p%"=="4" goto :PWR_SAVER
if "%p%"=="5" goto :PWR_ULT
if "%p%"=="6" goto :PWR_DISK
if "%p%"=="7" goto :PWR_BAT
if "%p%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :POWERMENU

:PWR_LIST
cls
call :HDR "SKEMA DAYA"
powercfg /list
echo.
call :PAUSE_RET
goto :POWERMENU

:PWR_HIGH
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo.
echo %Green%  OK - High Performance aktif.%Reset%
call :PAUSE_RET
goto :POWERMENU

:PWR_BAL
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo.
echo %Green%  OK - Balanced aktif.%Reset%
call :PAUSE_RET
goto :POWERMENU

:PWR_SAVER
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1
echo.
echo %Green%  OK - Power Saver aktif.%Reset%
call :PAUSE_RET
goto :POWERMENU

:PWR_ULT
cls
call :HDR "ULTIMATE PERFORMANCE"
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if errorlevel 1 echo %Yellow%  Tidak didukung pada edisi ini, memakai High Performance.%Reset%
if errorlevel 1 powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo.
echo %Green%  OK - Power plan performa tinggi aktif.%Reset%
call :PAUSE_RET
goto :POWERMENU

:PWR_DISK
powercfg /change disk-timeout-ac 0 >nul 2>&1
powercfg /change disk-timeout-dc 0 >nul 2>&1
echo.
echo %Green%  OK - Hard disk timeout AC/DC diset ke 0.%Reset%
call :PAUSE_RET
goto :POWERMENU

:PWR_BAT
cls
call :HDR "LAPORAN BATERAI"
powercfg /batteryreport /output "%USERPROFILE%\Desktop\Optimizer-battery-report.html" >nul 2>&1
echo %Green%  Laporan baterai: Desktop\Optimizer-battery-report.html%Reset%
echo.
powercfg /a
echo.
call :PAUSE_RET
goto :POWERMENU

:: ============================================================
::  8. MAINTENANCE
:: ============================================================
:MAINTMENU
cls
call :HDR "MAINTENANCE"
echo   %Green%[1]%White% Buat System Restore Point
echo   %Green%[2]%White% SFC /scannow
echo   %Green%[3]%White% DISM RestoreHealth
echo   %Green%[4]%White% Jadwalkan CHKDSK pada reboot
echo   %Green%[5]%White% Reset komponen Windows Update
echo   %Green%[6]%White% Laporan driver
echo   %Red%[0]%White% Kembali
echo.
set /p "mt=%Cyan%  Pilih [0-6]: "
if "%mt%"=="1" goto :MNT_RESTORE
if "%mt%"=="2" goto :MNT_SFC
if "%mt%"=="3" goto :MNT_DISM
if "%mt%"=="4" goto :MNT_CHKDSK
if "%mt%"=="5" goto :MNT_WU
if "%mt%"=="6" goto :MNT_DRV
if "%mt%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
goto :MAINTMENU

:MNT_RESTORE
cls
call :HDR "BUAT SYSTEM RESTORE POINT"
powershell -NoProfile -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Optimizer Restore Point' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo %Green%  OK - Lihat daftar restore point di rstrui.exe%Reset%
call :PAUSE_RET
goto :MAINTMENU

:MNT_SFC
cls
call :HDR "SFC /SCANNOW"
echo %Cyan%  Memindai integritas file sistem, mohon tunggu...
sfc /scannow
echo.
echo %Green%  OK - Selesai.%Reset%
call :PAUSE_RET
goto :MAINTMENU

:MNT_DISM
cls
call :HDR "DISM RESTORE HEALTH"
echo %Cyan%  Menjalankan DISM /RestoreHealth, proses lama...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo %Green%  OK - Selesai.%Reset%
call :PAUSE_RET
goto :MAINTMENU

:MNT_CHKDSK
cls
call :HDR "JADWALKAN CHKDSK"
echo %Yellow%  CHKDSK pada drive sistem berjalan saat reboot.
set /p "ck=%Cyan%  Lanjutkan? [Y/N]: "
if /i not "%ck%"=="Y" goto :MAINTMENU
echo Y | chkdsk %SystemDrive% /F
echo.
echo %Green%  OK - CHKDSK dijadwalkan pada reboot berikutnya.%Reset%
call :PAUSE_RET
goto :MAINTMENU

:MNT_WU
cls
call :HDR "RESET WINDOWS UPDATE"
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
echo %Green%  OK - Komponen Windows Update direset. Reboot dianjurkan.%Reset%
call :PAUSE_RET
goto :MAINTMENU

:MNT_DRV
cls
call :HDR "LAPORAN DRIVER"
powershell -NoProfile -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName } | Select-Object DeviceName,DriverVersion,DriverDate | Sort-Object DeviceName | Format-Table -AutoSize"
echo.
call :PAUSE_RET
goto :MAINTMENU

:: ============================================================
::  9. RESTORE DEFAULTS
:: ============================================================
:RESTOREMENU
cls
call :HDR "RESTORE DEFAULTS"
echo   %Green%[1]%White% Kembalikan semua service ke default
echo   %Green%[2]%White% Kembalikan jaringan ke default
echo   %Green%[3]%White% Power plan ke Balanced
echo   %Green%[4]%White% Kembalikan tweak visual Windows
echo   %Green%[5]%White% Hapus tweak Nagle
echo   %Green%[6]%White% Buka System Restore %DarkGray%(rstrui)%Reset%
echo   %Red%[0]%White% Kembali
echo.
set /p "rs=%Cyan%  Pilih [0-6]: "
if "%rs%"=="1" goto :RST_SVC
if "%rs%"=="2" goto :RST_NET
if "%rs%"=="3" goto :RST_PWR
if "%rs%"=="4" goto :RST_VISUAL
if "%rs%"=="5" goto :RST_NAGLE
if "%rs%"=="6" goto :RST_OPEN
if "%rs%"=="0" goto :MENU
echo %Red%  Pilihan tidak valid.%Reset%
timeout 2 >nul
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
sc config "XblAuthManager" start= demand >nul 2>&1
sc config "XblGameSave" start= demand >nul 2>&1
sc config "XboxNetApiSvc" start= demand >nul 2>&1
sc config WlanSvc start= auto >nul 2>&1
echo %Green%  OK - Service dikembalikan ke default.%Reset%
call :PAUSE_RET
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
powershell -NoProfile -Command "Get-NetAdapter | Where-Object { $_.HardwareInterface } | Enable-NetAdapter -Confirm:$false -ErrorAction SilentlyContinue"
echo %Green%  OK - Jaringan dikembalikan ke default dan adapter diaktifkan.%Reset%
call :PAUSE_RET
goto :RESTOREMENU

:RST_PWR
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo.
echo %Green%  OK - Power plan: Balanced.%Reset%
call :PAUSE_RET
goto :RESTOREMENU

:RST_VISUAL
cls
call :HDR "RESTORE VISUAL WINDOWS"
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >nul 2>&1
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
echo %Green%  OK - Tweak visual dikembalikan ke default Windows.%Reset%
call :PAUSE_RET
goto :RESTOREMENU

:RST_NAGLE
cls
call :HDR "HAPUS TWEAK NAGLE"
powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Remove-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -ErrorAction SilentlyContinue; Remove-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -ErrorAction SilentlyContinue }; Write-Host '  OK - Tweak Nagle dihapus. Reboot diperlukan.'"
echo.
call :PAUSE_RET
goto :RESTOREMENU

:RST_OPEN
echo.
start "" rstrui.exe
timeout 2 >nul
goto :RESTOREMENU

:: ============================================================
::  KELUAR
:: ============================================================
:EXIT
cls
call :BANNER
echo %Green%  Terima kasih. Optimasi selesai. Reboot dianjurkan.
echo %DarkGray%  Log: C:\Optimizer Logs\Optimizer.txt%Reset%
echo.
timeout 4 >nul
echo [%DATE% %TIME%] Optimizer exited. >> "C:\Optimizer Logs\Optimizer.txt"
endlocal
exit /b 0

:: ============================================================
::  SUBROUTINE
:: ============================================================
:BANNER
echo.
echo %Magenta%  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄%Reset%
echo %Magenta%  ▌  %Cyan%ACNX777+ OPTIMIZER%Magenta%   %Yellow%Oneclick Style%Magenta%   %Green%Offline%Reset%
echo %Magenta%  ▌  %DarkGray%Ethernet + WiFi Edition  v2.0%Magenta%            %DarkGray%by ACNX777+%Reset%
echo %Magenta%  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀%Reset%
echo.
goto :eof

:HDR
echo.
echo %Magenta%════════════════════════════════════════════════════════════════%Reset%
echo %Magenta%  %White%%~1%Reset%
echo %Magenta%════════════════════════════════════════════════════════════════%Reset%
echo.
goto :eof

:PAUSE_RET
echo.
set /p "REPLY=%DarkGray%  Tekan Enter untuk kembali ke menu... %Reset%"
goto :eof

:NIC_BACKUP
set /a NICBK+=1
reg export "%~1" "C:\Optimizer Backup\Network\Network_%NICBK%.reg" /y >nul 2>&1
goto :eof

:NIC_SET
reg query "%~1" /v "%~2" >nul 2>&1
if errorlevel 1 goto :eof
reg add "%~1" /v "%~2" /t %~3 /d %~4 /f >nul 2>&1
echo   %Yellow%- %~2 %Green%diset ke %~4%Reset%
goto :eof
