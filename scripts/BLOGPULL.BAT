@echo off
setlocal

:: 检查Git是否可用
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未找到Git。请确保Git已安装并在系统PATH中。
    pause
    exit /b 1
)

:: 检查当前目录是否为Git仓库
if not exist ".git" (
    echo 错误: 当前目录不是Git仓库。
    pause
    exit /b 1
)

echo ========================================
echo ??  警告: 这将覆盖本地所有未提交的更改
echo ========================================
echo.
echo 此脚本将执行以下操作:
echo 1. 获取远程最新状态 (git fetch)
echo 2. 强制重置工作区 (^>git reset --hard^)
echo 3. 删除所有未跟踪文件 (^>git clean -fd^)
echo.
echo 未提交的更改将^永久丢失^!
echo.
echo 按任意键继续，或关闭窗口取消...
pause >nul

echo.
echo 正在获取远程更新...
git fetch origin
if %errorlevel% neq 0 (
    echo 错误: 获取远程更新失败
    pause
    exit /b 1
)

echo 正在强制同步工作区...
git reset --hard origin/main
if %errorlevel% neq 0 (
    echo 错误: 重置失败
    pause
    exit /b 1
)

echo 正在清理多余文件和文件夹...
git clean -fd
if %errorlevel% neq 0 (
    echo 错误: 清理失败
    echo 注意: 被.gitignore忽略的文件可能未删除
)

echo.
echo ========================================
echo ? 同步完成! 本地已完全匹配远程main分支
echo ========================================
echo.

git status

echo.
echo 按任意键退出...
pause >nul