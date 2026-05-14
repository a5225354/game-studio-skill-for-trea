# notify.ps1 - 游戏工作室通知脚本
# 显示 Windows 桌面气泡通知（Toast）
# 用法: .\hooks\notify.ps1 [-Message "你的消息"]

param(
    [string]$Message = "Trae Game Studio 需要你的关注"
)

# 截断长消息
$Message = if ($Message.Length -gt 200) { $Message.Substring(0, 200) } else { $Message }

# 转义单引号
$MessageSafe = $Message -replace "'", "''"

# 使用 .NET WinForms NotifyIcon 显示 Windows 气泡通知
Add-Type -AssemblyName System.Windows.Forms

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Information
$notify.BalloonTipTitle = 'Trae Game Studio'
$notify.BalloonTipText = $MessageSafe
$notify.Visible = $true
$notify.ShowBalloonTip(5000)

# 等待通知显示后清理
Start-Sleep -Seconds 6
$notify.Dispose()

Write-Host "通知已发送: $MessageSafe"
