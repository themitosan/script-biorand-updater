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

:: Set echo off, variables and call main menu
@echo off
set branch=master
set "deleteFiles=false"
call:fnMainMenu

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::://///          ::::::::::::::::::::::::::
::::::::::::::::::::               ::::::::::::::::::::::::::
::::::::::::::::::::   Functions   ::::::::::::::::::::::::::
::::::::::::::::::::               ::::::::::::::::::::::::::
::::::::::::::::::::           ////::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::
:: Function - Update project
::
:fnStartProcess

	:: Display warning
	if "%deleteFiles%" == "false" (
		title BioRand Updater - IMPORTANT INFO
		mode con:cols=80 lines=18
		color f
		cls
		echo.
		echo ================================================================================
		echo       In order to update BioRand properly [and prevent bugs], it's highly 
		echo        recommended that you remove all previous files and create a fresh
		echo               build from source [or download it from GitHub Actions].
		echo                     To know more, check out this link:
		echo.
		echo           https://twitter.com/re_biorand/status/1743314921616462218
		echo.
		echo.    IF YOU FIND ANY BUGS ON BIORAND, MAKE SURE TO TEST A FRESH INSTALL FROM 
		echo    GITHUB ACTIONS BEFORE REACHING FOR USER SUPPORT. THE SCRIPT CREATOR ISN'T 
		echo      RESPONSIBLE FOR HOW THE END USER MAKE USE OF BIORAND OR ANY PIECE OF
		echo                     SOFTWARE THAT MAY BE INCLUDE WITH IT.
		echo.
		echo ================================================================================
		pause
	)

	:: Clear screen and update res.
	cls
	color f
	mode con:cols=180 lines=44

	:: Display warning
	echo ============================================================================
	echo.
	echo      IMPORTANT: DO NOT CLOSE THIS WINDOW WHILE THIS PROCESS IS RUNNING!
	echo.
	echo ============================================================================

	:: Check if needs to remove previous build
	if "%deleteFiles%" == "true" (
		title BioRand Updater [Branch: %branch%] - Removing previous build files...
		echo.
		echo INFO - Removing previous build files - Please wait...
		echo.
		rmdir /s /q "biorand"
	)

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
	title BioRand Updater [Branch: %branch%] - Step (4 / 5) - Building Visual Studio Soluction...
	echo.
	echo 4) Building Visual Studio Soluction...
	echo.
	msbuild biorand.sln /t:build /p:Configuration=Release

	:: Call process complete
	call:fnProcessComplete

goto:eof

::
:: Function - Process complete
::
:fnProcessComplete

	:: Display process complete message
	title BioRand Updater - Process Complete!
	mode con:cols=73 lines=14
	color a
	echo.
	echo =========================================================================
	echo.
	echo                            Process Complete!
	echo.
	echo =========================================================================
	echo.
	echo Please select your next action:
	echo.
	echo   1) Return to main menu
	echo   2) Open BioRand folder and return
	echo   3) Exit
	echo.

	:: Read input
	set /p input= Your choice: 

	:: Check input
	if /I %input% == 1 cd.. && call:fnMainMenu
	if /I %input% == 2 call:fnOpenFolderAndQuit
	if /I %input% == 3 call:fnExit
	exit

goto:eof

::
:: Function - Open folder and quit
::
:fnOpenFolderAndQuit

	call explorer "biorand\bin\Release"
	cd ..
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
	mode con:cols=73 lines=9
	color f
	cls
	echo.
	echo =========================================================================
	echo.
	echo                             TheMitoSan Says:
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
	mode con:cols=73 lines=18

	:: Clear screen and display main GUI
	cls
	color e
	title BioRand Updater - Created by @TheMitoSan
	echo =========================================================================
	echo                 BioRand Updater - Created By @TheMitoSan
	echo =========================================================================
	echo.
	echo  WARN: This script requires online connection, Git and VS2022 installed!
	echo          Also, msbuild and dotnet must be present on your PATH.
	echo.
	echo =========================================================================
	echo.
	echo Please - select your action:
	echo.
	echo   1) Fast update project using selected branch (%branch%)
	echo   2) Remove previous files and build a new soluction from selected
	echo      branch (%branch%)
	echo   3) Change branch
	echo   4) Exit
	echo.

	:: Read input
	set /p input= Your choice: 

	:: Check input
	if /I %input% == 1 call:fnStartProcess
	if /I %input% == 2 set "deleteFiles=true" && call:fnStartProcess
	if /I %input% == 3 call:fnUpdateBranch
	if /I %input% == 4 call:fnExit
	exit

goto:eof