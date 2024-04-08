:: npm.cmd 1.0.1
::
:: Activates NodeEnv, does the requested NPM
:: actions and exits NodeEnv.
::
:: (c)2023-2024 Harald Schneider - marketmix.com

echo.
echo Activating NodeEnv ...
set NODE_VIRTUAL_ENV=_runtime\nodejs-win
set NODE_PATH=%NODE_VIRTUAL_ENV%\node_modules
set NPM_CONFIG_PREFIX=%NODE_VIRTUAL_ENV%
set PATH=%NODE_VIRTUAL_ENV%\Scripts;%NODE_PATH%;%NODE_PATH%\bin;%PATH%

echo.
echo Running npm ...
call _runtime\nodejs-win\Scripts\npm.cmd %1 %2 %3 %4 %5 %6 %7 %8 %9 
echo "Exiting NodeEnv ..."
echo "Done."
