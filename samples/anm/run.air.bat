

set FLEX_SDK="C:\Development\Air"
set PATH=%PATH%;%FLEX_SDK%\bin
xcopy /y /s ..\res bin\flash\bin\res
adl bin\flash\bin\airApplication.xml
PAUSE