        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # SCRIPT CHECK INTERNET
        if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Host "Internet Connection Required`n" -ForegroundColor Red
        Pause
        exit
        }

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

        # FUNCTION SHOW MODERN FILE PICKER
        function Show-ModernFilePicker {
        param(
        [ValidateSet('Folder', 'File')]
        $Mode,
        [string]$fileType,
        [string]$InitialDirectory = ([Environment]::GetFolderPath('Desktop'))
        )
        if ($Mode -eq 'Folder') {
        $Title = 'Select Folder'
        $modeOption = $false
        $Filter = "Folders|`n"
        } else {
        $Title = 'Select File'
        $modeOption = $true
        if ($fileType) {
        $Filter = "$fileType Files (*.$fileType) | *.$fileType|All files (*.*)|*.*"
        } else {
        $Filter = 'All Files (*.*)|*.*'
        }
            }
        Add-Type -AssemblyName System.Windows.Forms
        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.AddExtension = $modeOption
        $OpenFileDialog.CheckFileExists = $modeOption
        $OpenFileDialog.DereferenceLinks = $true
        $OpenFileDialog.Filter = $Filter
        $OpenFileDialog.Multiselect = $false
        $OpenFileDialog.Title = $Title
        if (Test-Path $InitialDirectory) {
        $OpenFileDialog.InitialDirectory = $InitialDirectory
        } else {
        $OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
        }
        if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $OpenFileDialog.FileName
        } else {
        return $null
        }
        }

        # choose dlss 3 or 4 file
        Write-Host "1. DLSS v3"
        Write-Host "2. DLSS v4"
        Write-Host ""
        # select
        $dlssver = Read-Host -Prompt "DLSS Version?"
        Clear-Host
        # map choice
        switch ($dlssver) {
        "1" {$dlsschoice = "https://github.com/FR33THYFR33THY/Disable-Anti-Aliasing/raw/refs/heads/main/4%20DLSS%20Files/DLSS%203/nvngx_dlss.dll"}
        "2" {$dlsschoice = "https://github.com/FR33THYFR33THY/Disable-Anti-Aliasing/raw/refs/heads/main/4%20DLSS%20Files/DLSS%204/nvngx_dlss.dll"}
        default {
        Write-Host "Invalid input . . ." -ForegroundColor Red
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit
        }
        }
	
Write-Host "Installing: NvidiaProfileInspector . . ."
# check for file
if (-Not (Test-Path -Path "$env:SystemRoot\Temp\inspector.exe")) {
# unblock drs files
$path = "C:\ProgramData\NVIDIA Corporation\Drs"
Get-ChildItem -Path $path -Recurse | Unblock-File
# download inspector
IWR "https://github.com/FR33THYFR33THY/Ultimate-Files/raw/refs/heads/main/inspector.exe" -OutFile "$env:SystemRoot\Temp\inspector.exe"
# enable nvidia legacy sharpen
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\ControlSet001\Services\nvlddmkm\Parameters\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f | Out-Null
} else {
# skip
}
Clear-Host

        # FUNCTION SHOW MENU
        function show-menu {
	    Clear-Host
        Write-Host "1. Disable TAA"
	    Write-Host "2. Revert (Default)"
        Write-Host "3. DLSS Overlay On"
        Write-Host "4. DLSS Overlay Off (Default)"
	    Write-Host "5. Read Only"
	    Write-Host "6. Inspector"
	    Write-Host ""
	                  }
    	show-menu
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-6]$') {
        switch ($choice) {
        1 {

Clear-Host
Write-Host "Disable TAA"
# revert read only nvdrsdb0.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb0.bin" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null
# revert read only nvdrsdb1.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb1.bin" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null
# create config for inspector
$MultilineComment = @"
<?xml version="1.0" encoding="utf-16"?>
<ArrayOfProfile>
  <Profile>
    <ProfileName>Base Profile</ProfileName>
    <Executeables />
    <Settings>
      <ProfileSetting>
        <SettingNameInfo> </SettingNameInfo>
        <SettingID>390467</SettingID>
        <SettingValue>2</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Negative LOD bias</SettingNameInfo>
        <SettingID>1686376</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Trilinear optimization</SettingNameInfo>
        <SettingID>3066610</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync Tear Control</SettingNameInfo>
        <SettingID>5912412</SettingID>
        <SettingValue>2525368439</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred refresh rate</SettingNameInfo>
        <SettingID>6600001</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Maximum pre-rendered frames</SettingNameInfo>
        <SettingID>8102046</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Anisotropic filter optimization</SettingNameInfo>
        <SettingID>8703344</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync</SettingNameInfo>
        <SettingID>11041231</SettingID>
        <SettingValue>1620202130</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Shader disk cache maximum size</SettingNameInfo>
        <SettingID>11306135</SettingID>
        <SettingValue>4294967295</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Quality</SettingNameInfo>
        <SettingID>13510289</SettingID>
        <SettingValue>20</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Anisotropic sample optimization</SettingNameInfo>
        <SettingID>15151633</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Display the VRR Indicator</SettingNameInfo>
        <SettingID>268604728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Flag to control smooth AFR behavior</SettingNameInfo>
        <SettingID>270198627</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic filtering setting</SettingNameInfo>
        <SettingID>270426537</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Power management mode</SettingNameInfo>
        <SettingID>274197361</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Gamma correction</SettingNameInfo>
        <SettingID>276652957</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Mode</SettingNameInfo>
        <SettingID>276757595</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>FRL Low Latency</SettingNameInfo>
        <SettingID>277041152</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Frame Rate Limiter</SettingNameInfo>
        <SettingID>277041154</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Frame Rate Limiter for NVCPL</SettingNameInfo>
        <SettingID>277041162</SettingID>
        <SettingValue>357</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Toggle the VRR global feature</SettingNameInfo>
        <SettingID>278196567</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>VRR requested state</SettingNameInfo>
        <SettingID>278196727</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>G-SYNC</SettingNameInfo>
        <SettingID>279476687</SettingID>
        <SettingValue>4</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override DLSS-SR performance mode</SettingNameInfo>
        <SettingID>279951208</SettingID>
        <SettingValue>4</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override DLSS-RR performance mode</SettingNameInfo>
        <SettingID>280859683</SettingID>
        <SettingValue>4</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override scaling ratio for DLSS-RR</SettingNameInfo>
        <SettingID>281531554</SettingID>
        <SettingValue>1120403456</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic filtering mode</SettingNameInfo>
        <SettingID>282245910</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Setting</SettingNameInfo>
        <SettingID>282555346</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override DLSS-SR presets</SettingNameInfo>
        <SettingID>283385331</SettingID>
        <SettingValue>6</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override DLSS mode to be DLAA</SettingNameInfo>
        <SettingID>283385332</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override scaling ratio for DLSS-SR</SettingNameInfo>
        <SettingID>283385333</SettingID>
        <SettingValue>1120403456</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Override DLSS-RR preset</SettingNameInfo>
        <SettingID>283385335</SettingID>
        <SettingValue>6</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Enable DLSS-SR override</SettingNameInfo>
        <SettingID>283385345</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>CUDA Sysmem Fallback Policy</SettingNameInfo>
        <SettingID>283962569</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Enable G-SYNC globally</SettingNameInfo>
        <SettingID>294973784</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>OpenGL GDI compatibility</SettingNameInfo>
        <SettingID>544392611</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Threaded optimization</SettingNameInfo>
        <SettingID>549528094</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred OpenGL GPU</SettingNameInfo>
        <SettingID>550564838</SettingID>
        <SettingValue>id,2.0:268410DE,00000100,GF - (400,2,161,24564) @ (0)</SettingValue>
        <ValueType>String</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vulkan/OpenGL present method</SettingNameInfo>
        <SettingID>550932728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
    </Settings>
  </Profile>
</ArrayOfProfile>
"@
Set-Content -Path "$env:SystemRoot\Temp\disabletaa.nip" -Value $MultilineComment -Force
# import config
Start-Process -wait "$env:SystemRoot\Temp\inspector.exe" -ArgumentList "$env:SystemRoot\Temp\disabletaa.nip"
# select dlss file to replace
Write-Host "" 
Write-Host "Open the folder with the highest number, open files folder then select the XXX_XXXXXXX.bin file" -ForegroundColor Red
$file = Show-ModernFilePicker -Mode File -InitialDirectory "$env:ProgramData\NVIDIA\NGX\models\dlss\versions"
# move file to backup
Move-Item -Path $file -Destination "C:\ProgramData\NVIDIA\NGX\models\dlss\versions" -ErrorAction SilentlyContinue | Out-Null
# get file name
$filename = [System.IO.Path]::GetFileName($file)
Clear-Host
Write-Host "Disable TAA"
# download custom dlss file and rename it
Get-FileFromWeb -URL $dlsschoice -File $file
Clear-Host
Write-Host "Disable TAA: Loaded"
Write-Host ""
Write-Host "Open game, turn DLSS/DLAA on" -ForegroundColor Red
Write-Host "ctl+alt+f6 x2 = JITTER_DEBUG_JITTER . . ." -ForegroundColor Red
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
show-menu

          }
        2 {

Clear-Host
Write-Host "Revert (Default)"
# revert read only nvdrsdb0.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb0.bin" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null
# revert read only nvdrsdb1.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb1.bin" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null
# create config for inspector
$MultilineComment = @"
<?xml version="1.0" encoding="utf-16"?>
<ArrayOfProfile>
  <Profile>
    <ProfileName>Base Profile</ProfileName>
    <Executeables />
    <Settings>
      <ProfileSetting>
        <SettingNameInfo> </SettingNameInfo>
        <SettingID>390467</SettingID>
        <SettingValue>2</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Negative LOD bias</SettingNameInfo>
        <SettingID>1686376</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Trilinear optimization</SettingNameInfo>
        <SettingID>3066610</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync Tear Control</SettingNameInfo>
        <SettingID>5912412</SettingID>
        <SettingValue>2525368439</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred refresh rate</SettingNameInfo>
        <SettingID>6600001</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Maximum pre-rendered frames</SettingNameInfo>
        <SettingID>8102046</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Anisotropic filter optimization</SettingNameInfo>
        <SettingID>8703344</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync</SettingNameInfo>
        <SettingID>11041231</SettingID>
        <SettingValue>1620202130</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Shader disk cache maximum size</SettingNameInfo>
        <SettingID>11306135</SettingID>
        <SettingValue>4294967295</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Quality</SettingNameInfo>
        <SettingID>13510289</SettingID>
        <SettingValue>20</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture filtering - Anisotropic sample optimization</SettingNameInfo>
        <SettingID>15151633</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Display the VRR Indicator</SettingNameInfo>
        <SettingID>268604728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Flag to control smooth AFR behavior</SettingNameInfo>
        <SettingID>270198627</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic filtering setting</SettingNameInfo>
        <SettingID>270426537</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Power management mode</SettingNameInfo>
        <SettingID>274197361</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Gamma correction</SettingNameInfo>
        <SettingID>276652957</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Mode</SettingNameInfo>
        <SettingID>276757595</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>FRL Low Latency</SettingNameInfo>
        <SettingID>277041152</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Frame Rate Limiter</SettingNameInfo>
        <SettingID>277041154</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Frame Rate Limiter for NVCPL</SettingNameInfo>
        <SettingID>277041162</SettingID>
        <SettingValue>357</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Toggle the VRR global feature</SettingNameInfo>
        <SettingID>278196567</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>VRR requested state</SettingNameInfo>
        <SettingID>278196727</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>G-SYNC</SettingNameInfo>
        <SettingID>279476687</SettingID>
        <SettingValue>4</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic filtering mode</SettingNameInfo>
        <SettingID>282245910</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Setting</SettingNameInfo>
        <SettingID>282555346</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>CUDA Sysmem Fallback Policy</SettingNameInfo>
        <SettingID>283962569</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Enable G-SYNC globally</SettingNameInfo>
        <SettingID>294973784</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>OpenGL GDI compatibility</SettingNameInfo>
        <SettingID>544392611</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Threaded optimization</SettingNameInfo>
        <SettingID>549528094</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred OpenGL GPU</SettingNameInfo>
        <SettingID>550564838</SettingID>
        <SettingValue>id,2.0:268410DE,00000100,GF - (400,2,161,24564) @ (0)</SettingValue>
        <ValueType>String</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vulkan/OpenGL present method</SettingNameInfo>
        <SettingID>550932728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
    </Settings>
  </Profile>
</ArrayOfProfile>
"@
Set-Content -Path "$env:SystemRoot\Temp\revert.nip" -Value $MultilineComment -Force
# import config
Start-Process -wait "$env:SystemRoot\Temp\inspector.exe" -ArgumentList "$env:SystemRoot\Temp\revert.nip"
# select dlss file to revert
Write-Host ""
Write-Host "Select the XXX_XXXXXXX.bin backup file here" -ForegroundColor Red
Write-Host "C:\ProgramData\NVIDIA\NGX\models\dlss\versions" -ForegroundColor Red
$backup = Show-ModernFilePicker -Mode File -InitialDirectory "$env:ProgramData\NVIDIA\NGX\models\dlss\versions"
Clear-Host
Write-Host "Revert (Default)"
# select dlss file to replace
Write-Host "" 
Write-Host "Open the folder with the highest number, open files folder then select the XXX_XXXXXXX.bin file" -ForegroundColor Red
$replace = Show-ModernFilePicker -Mode File -InitialDirectory "$env:ProgramData\NVIDIA\NGX\models\dlss\versions"
# move backup file back
Move-Item -Path $backup -Destination $replace -Force -ErrorAction SilentlyContinue | Out-Null
Clear-Host
Write-Host "Revert (Default) . . ."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
show-menu

          }
        3 {

Clear-Host
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "ShowDlssIndicator" /t REG_DWORD /d "1024" /f | Out-Null
Write-Host "DLSS Overlay: On . . ."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
show-menu

          }
        4 {
		
Clear-Host
cmd.exe /c "reg delete `"HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore`" /v `"ShowDlssIndicator`" /f >nul 2>&1"
Write-Host "DLSS Overlay: Off (Default) . . ."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
show-menu

          }
        5 {

Clear-Host
# read only nvdrsdb0.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb0.bin" -Name IsReadOnly -Value $true -ErrorAction SilentlyContinue | Out-Null
# read only nvdrsdb1.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb1.bin" -Name IsReadOnly -Value $true -ErrorAction SilentlyContinue | Out-Null
Write-Host "Read Only"
Write-Host ""
Write-Host "nvdrsdb0.bin & nvdrsdb1.bin set to read only"
Write-Host "Press any key to continue . . ."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
show-menu

          }
        6 {

Clear-Host
Write-Host "Inspector"
# revert read only nvdrsdb0.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb0.bin" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null
# revert read only nvdrsdb1.bin
Set-ItemProperty -Path "$env:SystemDrive\ProgramData\NVIDIA Corporation\Drs\nvdrsdb1.bin" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null
# open inspector
Start-Process -wait "$env:SystemRoot\Temp\inspector.exe"
show-menu

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-6)." } }
