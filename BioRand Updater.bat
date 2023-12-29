:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::////                               :::::::::::::
:::::::::::::                                   :::::::::::::
:::::::::::::          BioRand Updater          :::::::::::::
:::::::::::::                                   :::::::::::::
:::::::::::::  Script created by @TheMitoSan    :::::::::::::
:::::::::::::                                   :::::::::::::
:::::::::::::  https://twitch.tv/themitosan     :::::::::::::
:::::::::::::  https://github.com/themitosan    :::::::::::::
:::::::::::::  https://twitter.com/themitosan   :::::::::::::
:::::::::::::                                   :::::::::::::
:::::::::::::                               ////:::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set echo off, set current branch var and call main menu
@echo off
set branch=master
call:fnMainMenu

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::: Functions ::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::
:: Function - Update project
::
:fnStartProcess

	:: Clear screen and update res.
	cls
	color f
	mode con:cols=180 lines=44

	:: Display warning
	echo.
	echo IMPORTANT: DO NOT CLOSE THIS WINDOW WHILE THIS PROCESS IS RUNNING!

	:: Pull latest changes from github
	title BioRand Updater [Branch: %branch%] - Step (1 / 5) - Pulling latest changes from GitHub...
	echo.
	echo 1) Pulling latest changes from GitHub...
	echo.

	:: Check if folder exists
	if not exist biorand/ (
		echo INFO - BioRand folder was not found!
		echo A new installation will be performed - Please wait...
		echo [If this is your first time running this script, this process may take a while!]
		echo.
		git clone https://github.com/IntelOrca/biorand.git
	)

	:: Navigate to folder and pull latest changes
	cd biorand/
	git checkout %branch%
	git pull

	:: Update project submodules
	title BioRand Updater [Branch: %branch%] - Step (2 / 5) - Updating project submodules
	echo.
	echo 2) Updating git submodules
	echo.
	git submodule update --init --force

	:: Run dotnet restore
	title BioRand Updater [Branch: %branch%] - Step (3 / 5) - Run dotnet restore
	echo.
	echo 3) Running dotnet restore
	echo.
	dotnet restore

	:: Build soluction
	title BioRand Updater [Branch: %branch%] - Step (4 / 5) - Building Visual Studio 2022 Soluction...
	echo.
	echo 4) Building Visual Studio 2022 Soluction...
	echo.
	msbuild biorand.sln /t:build /p:Configuration=Release

	:: Open build folder
	title BioRand Updater [Branch: %branch%] - Step (5 / 5) - Opening build path 
	echo.
	echo 5) Opening build path
	echo.
	call explorer "biorand\bin\Release\net472"
	cd ..

	:: Display process complete message
	title BioRand Updater - Process Complete!
	mode con:cols=73 lines=6
	color a
	echo.
	echo =========================================================================
	echo.
	echo               Process Complete - Press any key to return
	echo.
	echo =========================================================================
	pause

	:: Call main menu
	call:fnMainMenu

goto:eof

::
:: Function - Update branch
::
:fnUpdateBranch

	mode con:cols=73 lines=12
	cls
	color b
	title BioRand Updater - Set new branch
	echo =========================================================================
	echo                 Update branch - type the new branch below:
	echo =========================================================================
	echo.
	echo     You can set it to "master", "qr" or even "coop" (without quotes).
	echo       To know all available options, check on BioRand GitHub repo:
	echo                 https://github.com/IntelOrca/biorand 
	echo.
	echo =========================================================================
	echo.
	echo The current branch is "%branch%"
	set /p branch= New branch: 
	call:fnMainMenu

goto:eof

::
:: Function - Exit
::
:fnExit

	:: Update screen size and GUI
	title BioRand Updater - Goodbye :D
	mode con:cols=73 lines=8
	color f
	cls
	echo.
	echo =========================================================================
	echo.
	echo                      This is it - Have a nice day!
	echo.
	echo =========================================================================
	timeout /t 3
	exit

goto:eof

::
:: Function - Main menu
::
:fnMainMenu

	:: Update screen size
	mode con:cols=73 lines=16

	:: Clear screen and display main GUI
	cls
	color e
	title BioRand Updater - Created by @TheMitoSan
	echo =========================================================================
	echo                 BioRand Updater - Created By @TheMitoSan
	echo =========================================================================
	echo.
	echo           WARN: This script requires Git and VS2022 installed!
	echo          Also, msbuild and dotnet must be present on your PATH.
	echo.
	echo =========================================================================
	echo.
	echo Please - select your action:
	echo.
	echo   1) Update project using selected branch (%branch%)
	echo   2) Change branch
	echo   3) Exit
	echo.

	:: Read input
	set /p input= Your choice: 

	:: Check input
	if /I %input% == 1 call:fnStartProcess
	if /I %input% == 2 call:fnUpdateBranch
	if /I %input% == 3 call:fnExit
	exit

goto:eof