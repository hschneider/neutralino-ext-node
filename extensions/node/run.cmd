@echo off
set NODE_VIRTUAL_ENV=%1\extensions\node\_runtime\nodejs-win
set NODE_PATH=%NODE_VIRTUAL_ENV%\Scripts\node_modules
set NPM_CONFIG_PREFIX=%NODE_VIRTUAL_ENV%
set PATH=%NODE_VIRTUAL_ENV%\Scripts;%NODE_PATH%;%NODE_PATH%\bin;%NODE_VIRTUAL_ENV%\node-modules;%PATH%
node.exe --inspect %1\extensions\node\main.js
