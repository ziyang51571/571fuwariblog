@echo off
rem ========== Fuwari 一键直推脚本（带重试保护） ==========
chcp 65001 >nul
setlocal enabledelayedexpansion

set "MSG=%~1"
if "%MSG%"=="" set "MSG=Site updated %date:~0,10% %time:~0,5%"
set "BRANCH=main"

:findGitRoot
if exist ".git" goto :gitOK
cd ..
if "%cd:~-1%"==":" (
    echo [x] 未找到 .git 目录，脚本终止。
    pause & exit /b 1)
goto :findGitRoot
:gitOK

:: 1. 先尝试推送“空运行”，看是否远程已有上次 commit
git diff-index --quiet HEAD -- || goto :HaveStaged
:: 工作区干净，再检查是否有已提交但未推送的
git fetch origin
for /f %%i in ('git rev-list HEAD..origin/%BRANCH% --count') do set AHEAD=%%i
if !AHEAD! gtr 0 (
    echo [!] 检测到已有本地提交尚未推送，直接补推……
    goto :DoPush
) else (
    echo [!] 没有任何新变动，脚本退出。
    pause & exit /b 0)
:HaveStaged

:: 2. 有变动，正常 add + commit
echo.
echo [1/3] 添加更改...
git add -A
echo.
echo [2/3] 提交: %MSG%
git commit -m "%MSG%"

:: 3. 推送
:DoPush
echo.
echo [3/3] 推送到 origin/%BRANCH% ...
git push origin %BRANCH%
if errorlevel 1 (
    echo [x] 推送失败，请等网络恢复后再次运行脚本即可重试。
    pause & exit /b 1)

echo.
echo [√] 完成！
pause