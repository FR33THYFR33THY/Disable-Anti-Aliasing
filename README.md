# Disable-Anti-Aliasing

## Description
Ability to disable Anti-Aliasing in modern games that support DLSS and/or DLAA.<br>
Use case for when native options to disable Anti-Aliasing are unavailable.<br>

Original guide from [TheHybred](<https://www.reddit.com/r/MotionClarity/comments/1d206jv/disable_forced_antialiasing_with_dlss>).<br>
More in depth DLAA/DLSS modding and information from [emoose](<https://github.com/emoose/DLSSTweaks>).<br>
CustomSettingNames-DLSS.zip [here](<https://github.com/Orbmu2k/nvidiaProfileInspector/issues/156>).<br>
Info on presets [here](<https://developer.nvidia.com/blog/nvidia-dlss-updates-for-super-resolution-and-unreal-engine>).

## How It Works
Replace DLSS files with a developer's version and toggle debug keyboard shortcuts.

## Requirements
- DLSS supported game.<br>
- DLSS supported graphics card.

## What Is DLSS & DLAA
[NVIDIA](<https://developer.nvidia.com/rtx/streamline#:~:text=NVIDIA%20DLAA%20is%20an%20AI,higher%20levels%20of%20image%20quality.>)<br>
[Wikipedia](<https://en.wikipedia.org/wiki/Deep_learning_super_sampling>)

## Standard Method

1. Run "DLSS Indicator.reg"
2. Copy and replace "nvngx_dlss.dll" in game folder
3. Use "Force DLAA.ps1" to force all DLSS presets in native
4. Open game and enable DLSS or DLAA
5. Press "Ctrl-Alt-F6" 2x = "JITTER_DEBUG_JITTER" to disable Anti Aliasing
6. Experiment with "Ctrl-Alt-F7" 1x = "Sharpen On/Off" if viable
7. Experiment with DLAA/DLSS sharpen in game graphic options if viable

## Advanced Method

1. Run "Signature Override.reg"
2. Copy and replace "nvngx_dlss.dll" in game folder
3. Copy "DLSSTweaks.ini" and "nvngx.dll" in game folder
4. Open game and enable DLSS
5. Press "Ctrl-Alt-F6" 2x = "JITTER_DEBUG_JITTER" to disable Anti Aliasing
6. Experiment with "Ctrl-Alt-F7" 1x = "Sharpen On/Off" if viable
7. Experiment with DLAA/DLSS sharpen in game graphic options if viable

## Note
Some game launchers like Battle.net verify files on startup.<br>
It is recommended to open the game launcher first before moving or replacing files.<br>
You may need to copy the files after each time you start the game launcher.

Standard method will be the only option if anti cheat is blocking "DLSSTweaks.ini" and "nvngx.dll".<br>
Some games do not accept custom DLSS files. Anti-cheat systems will block you from enabling DLSS in the game, such as in The Finals.

To turn off the dev overlay text, run "Revert DLSS Indicator.reg" and edit "DLSSTweaks.ini" with the following settings:
- OverrideDlssHud=-1
- DisableDevWatermark=true

## Revert
1. Run "Revert DLSS Indicator.reg"
2. Run "Revert Signature Override.reg"
3. Delete "nvngx_dlss.dll", "DLSSTweaks.ini", "nvngx.dll" & "dlsstweaks.log" files in game folder
4. Scan and repair or verify files in game launcher
5. Run "Force DLAA.ps1" use default option

## Benchmarks
COD 1080p low<br>
2042 1080p/4k low<br>
7800x3d 4090<br>
OBS game capture<br>

![image](https://github.com/fr33thytweaks/Disable-Anti-Aliasing/assets/168888348/044d2417-d410-49f2-a099-442c679efaf5)

![Picture1](https://github.com/user-attachments/assets/bf004ca6-2f5a-431a-a811-36419aa819a7)

![Picture2](https://github.com/user-attachments/assets/00d8ce9f-9adf-42c3-b2cc-fc82ea950ce5)

<img width="493" alt="TAA VS NO TAA" src="https://github.com/user-attachments/assets/d03c8ee8-9650-423d-b8bb-2e9758fdd068">

## Video
[Video](<https://youtu.be/xxYU2BGDlpA>)

[![Video](https://img.youtube.com/vi/xxYU2BGDlpA/maxresdefault.jpg)]([https://www.youtube.com/watch?v=xxYU2BGDlpA](https://youtu.be/xxYU2BGDlpA))
