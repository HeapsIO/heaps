@echo off
IF "%1" == "" goto error

SET CONF="C:\Program Files (x86)\EasyPHP-5.3.6.0\conf_files\httpd.conf"

ECHO 127.0.0.1 %1.test.mt >> C:\Windows\System32\drivers\etc\hosts
ECHO written to windows hosts

@COPY /y /v%CONF% %CONF%.bak > NUL 2> NUL
ECHO. >> %CONF% 

ECHO ^<VirtualHost *^> >> %CONF% 
ECHO ServerName %1.test.mt >> %CONF% 
ECHO DocumentRoot %cd%\bin\html5\bin\ >> %CONF% 
ECHO ^<^/VirtualHost^> >> %CONF% 
ECHO written to papache
GOTO end

:error
ECHO missing argument!
ECHO this command allow easy local site creation
ECHO usage websitename

:end