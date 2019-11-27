@echo off
set COMPILEDIR=%CD%
set GAMEDIR="C:\COD4 - Modern Warfare"
set color=1e
color %color%


:START
cls
echo.
echo        __  ___          __              
echo       /  \/  /___  ____/ /__  _________    Modern Spearhead 2 Mod utility!
echo      / /\_/ / __ \/ __  / _ \/ ___/ __ \   Inspired by OpenWarfare mod
echo     / /  / / /_/ / /_/ /  __/ /  / / / /   Modified by [G13]Newfie{A}
echo    /_/  /_/\____/\____/\___/_/  /_/ /_/ 
echo                                            email jearle1974@gmail.com
echo       _____                       __                   __   ___ 
echo      / ___/____  ___  ____ ______/ /_  ___  ____ _____/ /  /__ \
echo      \__ \/ __ \/ _ \/ __ `/ ___/ __ \/ _ \/ __ `/ __  /   __/ /
echo     ___/ / /_/ /  __/ /_/ / /  / / / /  __/ /_/ / /_/ /   / __/ 
echo    /____/ .___/\___/\____/_/  /_/ /_/\___/\____/\____/   /____/ 
echo        /_/                                                      
echo.

:LANGEN
set CLANGUAGE=English
set LANG=english
set LTARGET=english


echo  Checking language directories...
if not exist %GAMEDIR%\zone\%LTARGET% mkdir %GAMEDIR%\zone\%LTARGET%
if not exist %GAMEDIR%\zone_source\%LTARGET% xcopy %GAMEDIR%\zone_source\english %GAMEDIR%\zone_source\%LTARGET% /SYI > NUL
if not exist %GAMEDIR%\Mods\g13ftag mkdir %GAMEDIR%\Mods\g13ftag
echo  Modern Spearhead will be created in %CLANGUAGE%!


:MAKEOPTIONS
echo _________________________________________________________________
echo.
echo  Please select an option:
echo    1. Build everything (might take longer)
echo    2. ReBuild mod.ff
echo.
echo    3. Cancel
echo.

choice /C:123 /T 10 /D 1
if errorlevel 3 goto FINAL
if errorlevel 2 goto MAKE_MOD_FF
if errorlevel 1 goto MAKE_SPEARHEAD_IWD
goto MAKEOPTIONS


:MAKE_SPEARHEAD_IWD
echo _________________________________________________________________
echo.
echo  Please choose what set of weapon files to use:
echo    1. Only fixes.
echo    2. No Gun Sway.
echo    3. Sniper Increased Distance.
echo    4. "The Company Hub" weapons by Buster.
echo    5. G13.
echo.
echo    6. Back
echo.

choice /C:123456 /T 10 /D 1
if errorlevel 6 goto MAKEOPTIONS
if errorlevel 5 goto WEAPONS_G13
if errorlevel 4 goto WEAPONS_THECOMPANY
if errorlevel 3 goto WEAPONS_FIXES_NOGUNSWAY_SNIPER
if errorlevel 2 goto WEAPONS_FIXES_NOGUNSWAY
if errorlevel 1 goto WEAPONS_FIXES
goto MAKE_SPEARHEAD_IWD


:WEAPONS_FIXES
echo    Adding weapon files with only fixes...
xcopy weapons\fixes weapons\mp /SYI > NUL
goto BUILD_SPEARHEAD_IWD

:WEAPONS_FIXES_NOGUNSWAY
echo    Adding weapon files with no gun sway...
xcopy weapons\fixes+nogunsway weapons\mp /SYI > NUL
goto BUILD_SPEARHEAD_IWD

:WEAPONS_FIXES_NOGUNSWAY_SNIPER
echo    Adding weapon files with sniper increased distance...
xcopy weapons\fixes+nogunsway+sniper weapons\mp /SYI > NUL
goto BUILD_SPEARHEAD_IWD

:WEAPONS_THECOMPANY
echo    Adding weapon files created by Buster, "The Company Hub"...
xcopy weapons\thecompany weapons\mp /SYI > NUL
goto BUILD_SPEARHEAD_IWD

:WEAPONS_G13
echo    Adding weapon files created by Gooser13, "[G13]"...
xcopy weapons\g13 weapons\mp /SYI > NUL
goto BUILD_SPEARHEAD_IWD


:BUILD_SPEARHEAD_IWD
echo _________________________________________________________________
echo  Removing old iwd file:
echo    Deleting old z_ms2.iwd file...
del z_ms2.iwd
echo _________________________________________________________________
echo  Creating new z_ms2.iwd:
echo    Adding images...
7za a -r -tzip z_ms2.iwd images\*.iwi > NUL
echo    Adding sounds...
7za a -r -tzip z_ms2.iwd sound\*.mp3 > NUL
7za a -r -tzip z_ms2.iwd sound\*.wav > NUL
echo    Adding Modern Spearhead 2 custom christmas sounds...
xcopy ms2\christmas sound\christmas /SYI > NUL
7za a -r -tzip z_ms2.iwd sound\christmas\*.mp3 > NUL
echo    Adding weapons...
7za a -r -tzip z_ms2.iwd weapons\mp\*_mp > NUL
echo    Adding OpenWarfare standard rulesets...
7za a -r -tzip z_ms2.iwd rulesets\openwarfare\*.gsc > NUL
7za a -r -tzip z_ms2.iwd rulesets\leagues.gsc > NUL
echo    Adding empty mod.arena file...
7za a -r -tzip z_ms2.iwd mod.arena > NUL
echo    Adding disclaimers...
7za a -r -tzip z_ms2.iwd readme.txt > NUL
7za a -r -tzip z_ms2.iwd packages\docs\credits.txt > NUL
7za a -r -tzip z_ms2.iwd packages\docs\changelog.txt > NUL
echo  New z_ms2.iwd file successfully built!
echo _________________________________________________________________
echo  Cleaning up build files:
del /f /q weapons\mp\* >NUL
rmdir weapons\mp >NUL


:COMPILE_RULESET
if not exist rulesets\g13 goto MAKE_MOD_FF
echo _________________________________________________________________
echo  Creating new z_svr_rs_g13.iwd:
echo    Deleting old z_svr_rs_g13.iwd ruleset file...
del z_svr_rs_g13.iwd > NUL
echo    Adding [G13] custom ruleset file...
7za a -r -tzip z_svr_rs_g13.iwd rulesets\g13\*.gsc > NUL
echo  New ruleset z_svr_rs_g13.iwd file successfully built!


:MAKE_MOD_FF
echo _________________________________________________________________
echo.
echo  Building mod.ff:
echo    Deleting old mod.ff file...
del mod.ff

echo    Copying localized strings...
xcopy %LANG% %GAMEDIR%\raw\%LTARGET% /SYI > NUL

echo    Copying game resources...
xcopy configs %GAMEDIR%\raw\configs /SYI > NUL
xcopy images %GAMEDIR%\raw\images /SYI > NUL
xcopy fx %GAMEDIR%\raw\fx /SYI > NUL
xcopy maps %GAMEDIR%\raw\maps /SYI > NUL
xcopy materials %GAMEDIR%\raw\materials /SYI > NUL
xcopy mp %GAMEDIR%\raw\mp /SYI > NUL
xcopy rulesets %GAMEDIR%\raw\rulesets /SYI > NUL

echo    Copying sound resources...
xcopy ms2\christmas sound\christmas /SYI > NUL
xcopy sound %GAMEDIR%\raw\sound /SYI > NUL
xcopy soundaliases %GAMEDIR%\raw\soundaliases /SYI > NUL

echo    Copying xmodel resources...
xcopy vision %GAMEDIR%\raw\vision /SYI > NUL
xcopy weapons\fixes %GAMEDIR%\raw\weapons\mp /SYI > NUL
xcopy xanim %GAMEDIR%\raw\xanim /SYI > NUL
xcopy xmodel %GAMEDIR%\raw\xmodel /SYI > NUL
xcopy xmodelparts %GAMEDIR%\raw\xmodelparts /SYI > NUL
xcopy xmodelsurfs %GAMEDIR%\raw\xmodelsurfs /SYI > NUL

echo    Copying Modern Spearhead 2 custom items...
xcopy ui_mp %GAMEDIR%\raw\ui_mp /SYI > NUL
xcopy ms2 %GAMEDIR%\raw\ms2 /SYI > NUL
copy readme.txt %GAMEDIR%\raw\readme.txt > NUL
copy packages\docs\credits.txt %GAMEDIR%\raw\credits.txt > NUL
copy packages\docs\changelog.txt %GAMEDIR%\raw\changelog.txt > NUL

echo    Copying Openwarfare source code...
xcopy openwarfare %GAMEDIR%\raw\openwarfare /SYI > NUL
copy /Y mod.csv %GAMEDIR%\zone_source > NUL
copy /Y mod_ignore.csv %GAMEDIR%\zone_source\%LTARGET%\assetlist > NUL

echo    Cleaning up files...
del /f /q sound\christmas\* >NUL
rmdir sound\christmas >NUL

echo    Compiling mod...
cd %GAMEDIR%\bin > NUL
linker_pc.exe -language %LTARGET% -compress -cleanup mod 
cd %COMPILEDIR% > NUL
copy %GAMEDIR%\zone\%LTARGET%\mod.ff > NUL

xcopy mod.ff %GAMEDIR%\Mods\g13ftag\mod.ff /SYI > NUL
xcopy config.cfg %GAMEDIR%\Mods\g13ftag\config.cfg /SYI > NUL
xcopy *.iwd %GAMEDIR%\Mods\g13ftag /SYI > NUL
xcopy configs %GAMEDIR%\Mods\g13ftag\configs /SYI > NUL

echo  New Modern Spearhead 2 custom mod.ff file successfully built!
goto RUN_GAME


:RUN_GAME
echo _________________________________________________________________
echo.
echo  Please choose option:
echo    1. Start COD4 multiplayer
echo    2. Exit
echo.

choice /C:12 /T 10 /D 2
if errorlevel 2 goto FINAL
if errorlevel 1 goto STARTGAME
goto RUN_GAME

:STARTGAME
cd %GAMEDIR% > NUL
start iw3mp.exe +set fs_game mods/g13ftag +exec config.cfg +set dedicated 0 +set developer 1 +set sv_punkbuster 0 +map_rotate

:FINAL
