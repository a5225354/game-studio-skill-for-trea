# session-stop.ps1 - Trae Game Studio 会话结束脚本
# 记录本次工作内容用于审计追踪和冲刺跟踪
# 手动执行方式: .\hooks\session-stop.ps1

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$sessionLogDir = "production/session-logs"

if (-not (Test-Path $sessionLogDir)) {
    New-Item -ItemType Directory -Path $sessionLogDir -Force | Out-Null
}

$recentCommits = git log --oneline --since="8 hours ago" 2>$null
$modifiedFiles = git diff --name-only 2>$null

# 归档活跃会话状态
$stateFile = "production/session-state/active.md"
if (Test-Path $stateFile) {
    $stateContent = Get-Content $stateFile -Raw
    $archiveEntry = @"
## 已归档的会话状态: $timestamp
$stateContent
---
"@
    $archiveEntry | Out-File -FilePath "$sessionLogDir/session-log.md" -Append -Encoding utf8
    Remove-Item $stateFile -ErrorAction SilentlyContinue
}

# 记录会话工作成果
if ($recentCommits -or $modifiedFiles) {
    $logEntry = @"
## 会话结束: $timestamp
"@
    if ($recentCommits) {
        $logEntry += "`n### 提交`n$recentCommits"
    }
    if ($modifiedFiles) {
        $logEntry += "`n### 未提交的变更`n$modifiedFiles"
    }
    $logEntry += "`n---`n"
    $logEntry | Out-File -FilePath "$sessionLogDir/session-log.md" -Append -Encoding utf8
}

exit 0
