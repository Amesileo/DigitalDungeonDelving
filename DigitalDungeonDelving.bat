cls
@echo off
title Digital Dungeon Delver

::BUGS TO FIX > SPEED NOT INCREASING. HEALTH INCREASING TOO MUCH.


REM This is the MENU section of the game
:MENU
echo _________________________
echo ________________________/
echo ___________________/
echo.
echo D  i  g  i  t  a  L
echo D  u  n  g  e  o  N
echo D  e  l  v  i  n  G
echo ___________________
echo __________________/
echo.
echo     written by     
echo     George W J      
echo ________________
echo _______________/
echo.
pause
cls
echo Have you played before?
echo        y/n
set /p choice=
if '%choice%'=='n' goto NEWGAME
if '%choice%'=='y' goto LOADGAME

REM This is the section where data is gathered from the adventurelog
:LOADGAME
if not exist adventurelog.sav goto LOADERROR
(
	set /p name=
	set /p deepestfloor=
	set /p skillpoints=
	set /p hitpoints=
	set /p maxhitpoints=
	set /p strength=
	set /p speed=
) < adventurelog.sav
goto DUNGEON_ENTRANCE_RETURN

:LOADERROR
echo No previous adventures were recorded
pause
goto MENU

:NEWGAME
echo What is your name, adventurer?
set rerollchances= 3
set deepestfloor= 0
set /p name= 
(
	echo %name%
	echo %deepestfloor%
) > adventurelog.sav
goto WELCOME_NEW

REM This is the character set up
:WELCOME_NEW
echo Hello, %name%!
goto VALUESELECTION

:VALUESELECTION
pause
echo What do you value most, %name%?
echo.
echo [1] HEALTH
echo [2] STRENGTH
echo [3] SPEED
echo Your stats will be randomly generated, and selecting
echo a value doesn't necessarily ensure accurate stat
echo distribution!
set /a hitpoints= 30

set /p choice=
if '%choice%'=='1' set role= HEALTH
if '%choice%'=='2' set role= STRENGTH
if '%choice%'=='3' set role= SPEED
(
	echo %name%
	echo %deepestfloor%
	echo %skillpoints%
	echo %hitpoints%
	echo %maxhitpoints%
	echo %strength%
	echo %speed%
) > adventurelog.sav
if '%choice%'=='1' goto STAT_SETUP_HEALTH
if '%choice%'=='2' goto STAT_SETUP_STRENGTH
if '%choice%'=='3' goto STAT_SETUP_SPEED

:STAT_SETUP_HEALTH
cls
echo You selected %role%.
echo.
echo STAT LIST
set /a "maxhitpoints= %random% %% 12+6"
set /a "strength= %random% %% 6+5"
set /a "speed= %random% %% 6+5"
echo HP= %maxhitpoints%
echo Strength= %strength%
echo Speed = %speed%
echo.
set skillpoints= 0
echo Your current skillpoint total is %skillpoints%.
pause
goto DUNGEON_ENTRANCE

:STAT_SETUP_STRENGTH
cls
echo You selected %role%.
echo.
echo STAT LIST
set /a "maxhitpoints= %random% %% 6+5"
set /a "strength= %random% %% 12+6"
set /a "speed= %random% %% 6+5"
echo HP= %maxhitpoints%
echo Strength= %strength%
echo Speed = %speed%
echo.
set skillpoints= 0
echo Your current skillpoint total is %skillpoints%.
pause
goto DUNGEON_ENTRANCE

:STAT_SETUP_SPEED
cls
echo You selected %role%.
echo.
echo STAT LIST
set /a "maxhitpoints= %random% %% 6+5"
set /a "strength= %random% %% 6+5"
set /a "speed= %random% %% 12+6"
echo HP= %maxhitpoints%
echo Strength= %strength%
echo Speed = %speed%
echo.
set skillpoints= 0
echo Your current skillpoint total is %skillpoints%.
pause
goto DUNGEON_ENTRANCE

:DUNGEON_ENTRANCE
cls
set hitpoints= %maxhitpoints%
echo Welcome to the Dungeon Entrance, %name%!
echo What would you like to do?
echo [1] Enter the dungeon
echo [2] Hone your skills
echo [3] End your adventure for now
set /p choice=
if '%choice%'=='1' goto DUNGEON
if '%choice%'=='2' goto SKILLS_CHECK
if '%choice%'=='3' goto SAVE_AND_QUIT

:DUNGEON_ENTRANCE_RETURN
cls
set hitpoints= %maxhitpoints%
echo Welcome to the Dungeon Entrance, %name%!
echo Your deepest dungeon delve reached floor %deepestfloor%!
echo.
echo Your hitpoints are %hitpoints%.
echo Strength = %strength%
echo Speed = %speed%
echo.
echo Your current skillpoint total is %skillpoints%.
echo.
echo What would you like to do?
echo [1] Enter the dungeon
echo [2] Hone your skills
echo [3] End your adventure for now
set /p choice=
if '%choice%'=='1' goto DUNGEON
if '%choice%'=='2' goto SKILLS_CHECK
if '%choice%'=='3' goto SAVE_AND_QUIT

:DUNGEON
cls
set /a currentfloor= 1
set /a enemyspeedlimit= %random% %% 11+3
set /a difficultyamplifiertrigger= -1
set /a difficultyamplifier= 1
echo You decided to enter the dungeon. 
echo Delve as deep as you can to gather
echo skillpoints. Happy hunting!
pause
currentfloor = 0
goto DUNGEON_FLOOR_GENERATOR

:SKILLS_CHECK
cls
if %skillpoints% GTR 0 goto SKILLS
echo Unfortunately, you have no skillpoints to 
echo spend. Gather some from the depths of the
echo dungeon!
pause
goto DUNGEON_ENTRANCE_RETURN

:SKILLS
cls
echo You decided to hone your skills.
echo Here, you can spend skillpoints to upgrade 
echo your skills.
echo Currently, you have %skillpoints% available skillpoints.
echo.
echo What would you like to upgrade?
echo [1] Health (%maxhitpoints%)
echo [2] Strength (%strength%)
echo [3] Speed (%speed%)
echo [4] Return to Dungeon Entrance

set /p choice=
if '%choice%'=='1' set /a maxhitpoints= "%maxhitpoints% + 1"
if '%choice%'=='2' set /a strength= "%strength% + 1"
if '%choice%'=='3' set /a speed= "%speed% + 1"
if '%choice%'=='4' goto DUNGEON_ENTRANCE
set /a skillpoints= "%skillpoints% - 1"
goto SKILLS_CHECK

:SAVE_AND_QUIT
(
	echo %name%
	echo %deepestfloor%
	echo %skillpoints%
	echo %hitpoints%
	echo %maxhitpoints%
	echo %strength%
	echo %speed%
) > adventurelog.sav
echo Thank you for daring to delve to
echo the dungeon depths! Return soon!
pause
exit

::CAP_HEALTH
::pause
::set hitpoints= %maxhitpoints%
::goto HEALTH_CAPPED

:DUNGEON_FLOOR_GENERATOR
cls
(
	echo %name%
	echo %deepestfloor%
	echo %skillpoints%
	echo %hitpoints%
	echo %maxhitpoints%
	echo %strength%
	echo %speed%
) > adventurelog.sav
set /a currentfloor= "%currentfloor% - 1"
set /a enemyspeed= "%enemyspeedlimit% * %difficultyamplifier%"
set /a difficultyamplifiertrigger= "%difficultyamplifiertrigger% + 1"
if '%difficultyamplifiertrigger%' EQU '5' echo You rest for a moment. Up to 5 HP regained...
if '%difficultyamplifiertrigger%' EQU '5' set /a hitpoints= "%hitpoints% + 10"
if '%difficultyamplifiertrigger%' EQU '10' set /a difficultyamplifier= "%difficultyamplifier% + 1"
if '%difficultyamplifiertrigger%' EQU '10' echo Down here, the monsters grow stronger...
if '%difficultyamplifiertrigger%' EQU '10' set /a difficultyamplifiertrigger= 0
if %hitpoints% GTR %maxhitpoints% set /a hitpoints= "%maxhitpoints%"
set /a "enemypopulation= %random% %% 3+1"
set /a "maxenemyhitpoints= %random% %% 11 + 3"
echo Current floor is %currentfloor%
echo The enemy population on this floor is %enemypopulation%.
timeout /t 3 /nobreak

goto INITIATE_COMBAT

:INITIATE_COMBAT
if not %enemyspeed% LSS %speed% goto COMBAT_ENEMY_FIRST
goto COMBAT_DODGE_CHECK 

:COMBAT_RANDOM
echo RANDOM
set /a dodge= 0
set /a enemystrikes= %random% %% 2
echo ENEMYSTRIKES = %enemystrikes%
pause
if %enemystrikes% EQU 1 goto COMBAT_ENEMY_FIRST
if %enemystrikes% EQU 0 goto COMBAT_ADVENTURER_FIRST

:COMBAT_ENEMY_FIRST
cls
echo ENEMY FIRST
set /a enemydamage= %random% %% 2 + 1
set /a enemydamage= %enemydamage% + %enemyspeedlimit%
set /a enemydamage= %enemydamage% * %difficultyamplifier%
if %hitpoints% LSS 0 goto DEFEAT
if '%enemyhitpoints%' LEQ '0' set /a enemypopulation= "%enemypopulation% - 1"
if '%enemyhitpoints%' LEQ '0' set /a enemyhitpoints= %maxenemyhitpoints% * %difficultyamplifier%
if %enemypopulation% LEQ 0 goto DESCEND 
echo FIGHTING MONSTER
echo Enemy HP = %enemyhitpoints%	Enemy SPD = %enemyspeed%
echo Your HP = %hitpoints%	Your SPD = %speed%
echo Enemy attacks!
timeout /t 1
echo Enemy inflicted %enemydamage%
set /a hitpoints= "%hitpoints% - %enemydamage%"
if %hitpoints% LSS 0 goto DEFEAT
echo You attack!
timeout /t 1
echo You inflicted %strength%
set /a enemyhitpoints= "%enemyhitpoints% - %strength%"
if %enemyhitpoints% LEQ 0 set /a enemypopulation= "%enemypopulation% - 1"
echo Enemies remaining: %enemypopulation%
if '%enemyhitpoints%' LEQ '0' set /a enemyhitpoints= %maxenemyhitpoints% * %difficultyamplifier%
timeout /t 1
goto INITIATE_COMBAT

:COMBAT_DODGE_CHECK
cls
echo DODGE CHECK
set /a dodge = 1
set /a dodgecheck= %random% %% 2
if '%dodgecheck%' EQU '1' set /a dodge = 1
if '%dodgecheck%' EQU '0' set /a dodge = 0
goto COMBAT_ADVENTURER_FIRST

:COMBAT_ADVENTURER_FIRST
cls
echo ADVENTURER FIRST
if %hitpoints% LSS 0 goto DEFEAT
if '%enemyhitpoints%' LEQ '0' set /a enemypopulation= "%enemypopulation% - 1"
if '%enemyhitpoints%' LEQ '0' set /a enemyhitpoints= %maxenemyhitpoints% * %difficultyamplifier%
set /a enemyattack= 1
echo FIGHTING MONSTER
echo Enemy HP = %enemyhitpoints%	Enemy SPD = %enemyspeed%
echo Your HP = %hitpoints%	Your SPD = %speed%
echo You attack first!
timeout /t 1
echo You inflicted %strength%
set /a enemyhitpoints= "%enemyhitpoints% - %strength%"
if %enemyhitpoints% LEQ 0 set /a enemypopulation= "%enemypopulation% - 1"
if %enemyhitpoints% LEQ 0 set /a enemyattack= 0
echo Enemies remaining: %enemypopulation%
if %enemyhitpoints% LEQ 0 set /a enemyhitpoints= %maxenemyhitpoints% * %difficultyamplifier%
if %enemypopulation% LEQ 0 goto DESCEND
timeout /t 1
set /a enemydamage= %random% %% 2 + 1
set /a enemydamage= %enemydamage% + %enemyspeedlimit%
set /a enemydamage= %enemydamage% * %difficultyamplifier%
if '%enemyattack%' EQU '0' goto COMBAT_ADVENTURER_FIRST
echo Enemy attacks!
timeout /t 1
if '%dodge%' EQU '1' set /a enemydamage= 0
if '%dodge%' EQU '1' echo The enemy missed!
echo Enemy inflicted %enemydamage%
set /a hitpoints= "%hitpoints% - %enemydamage%"
timeout /t 1
if %hitpoints% LSS 0 goto DEFEAT
goto INITIATE_COMBAT

:DESCEND
cls
set /a skillpoints= "%skillpoints% + 1"
currentfloor= %currentfloor% - 1
goto DUNGEON_FLOOR_GENERATOR

:DEFEAT
cls
set /a skillpoints= "%skillpoints% + 1"
echo You reached floor %currentfloor% before you were defeated!
if %currentfloor% LSS %deepestfloor% set /a deepestfloor= "%currentfloor%"
echo As of now, your deepest floor is %deepestfloor%!
echo.
echo It's time to return to the surface.
set /a enemyspeedlimit= %random% %% 11+3
set /a enemyspeed= 1
pause
goto DUNGEON_ENTRANCE_RETURN