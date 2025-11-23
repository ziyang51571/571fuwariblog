@echo off
rem ========== Fuwari 一键直推脚本（不拉取） ==========
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 1. 基本配置
set "MSG=%~1"
if "%MSG%"=="" set "MSG=Site updated %date:~0,10% %time:~0,5%"
set "BRANCH=main"

:: 2. 定位仓库根目录
:findGitRoot
if exist ".git" goto :gitOK
cd ..
if "%cd:~-1%"==":" (
    echo [x] 未找到 .git 目录，脚本终止。
    pause & exit /b 1
)
goto :findGitRoot
:gitOK

:: 3. 添加全部更改（含删除、重命名）
echo.
echo [1/3] 添加更改...
git add -A

:: 4. 提交
echo.
echo [2/3] 提交: %MSG%
git commit -m "%MSG%"
if errorlevel 1 (
    echo [!] 没有可提交的内容，脚本退出。
    pause & exit /b 0
)

:: 5. 直接推送
echo.
echo [3/3] 推送到 origin/%BRANCH% ...
git push origin %BRANCH%
if errorlevel 1 (
    echo [x] 推送失败，可能网络问题或远程有更新。
    echo    若远程已更新，请手动 pull 后再试。
    pause & exit /b 1
)

echo.
echo [√] 直推完成！
pause