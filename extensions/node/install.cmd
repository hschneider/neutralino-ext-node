:: Embeddable NodeJS installer 1.0.2
::
:: Installs an embeddable NodeJS version.
::
:: Requirements:
:: - python3
:: - git
::
:: (c)2023-2024 Harald Schneider - marketmix.com

@echo off

echo.
echo Fetching NodeEnv ...
mkdir _runtime 2>nul
cd _runtime
pip3 install -e git+https://github.com/ekalinin/nodeenv.git#egg=nodeenv

echo.
echo Installing ...
python3 src/nodeenv/nodeenv.py nodejs-win

echo.
echo Cleaning ...
rmdir /s /q src
cd ..

echo.
echo Adding extension's requirements ...
set NODE_VIRTUAL_ENV=_runtime\nodejs-win
set NODE_PATH=%NODE_VIRTUAL_ENV%\Scripts\node_modules
set NPM_CONFIG_PREFIX=%NODE_VIRTUAL_ENV%
set PATH=%NODE_VIRTUAL_ENV%\Scripts;%NODE_PATH%;%NODE_PATH%\bin;%NODE_VIRTUAL_ENV%\node-modules;%PATH%
_runtime\nodejs-win\Scripts\npm.cmd install ws

echo.
echo Ready to embed NodeJS :-)
echo Done.

