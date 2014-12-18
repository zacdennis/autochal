@echo off
rem ***************************************************************************
rem * Set the path to the eclipse directory                                   *
rem ***************************************************************************
set ECLIPSEPATH=c:\program files\eclipse\
if not exist "%ECLIPSEPATH%eclipse.exe" set ECLIPSEPATH=c:\eclipse\

rem ***************************************************************************
rem * Clear the eclipse project folder read only so that Eclipse can use      *
rem * the project files                                                       *
rem ***************************************************************************
attrib -r .metadata\*.* /s

if exist "%ECLIPSEPATH%eclipse.exe" goto eclipsefound
echo --------------------------------------------------------------------------
echo Error:  Eclipse not found
echo.
echo Please go to http://www.eclipse.org to download the Eclipse IDE
echo --------------------------------------------------------------------------
pause
echo.
goto end

:eclipsefound

start "Eclipse Launch" "%ECLIPSEPATH%eclipse.exe" -refresh -data .

:end