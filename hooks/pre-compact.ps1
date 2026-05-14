# pre-compact.ps1 - Trae Game Studio 上下文保存脚本
# 在 AI 上下文窗口即将满时，保存当前工作状态以防止丢失
# 手动执行方式: .\hooks\pre-compact.ps1

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "=== 会话状态快照 ==="
Write-Host "时间戳: $(Get-Date)"

$stateFile = "production/session-state/active.md"
if (Test-Path $stateFile) {
    Write-Host ""
    Write-Host "## 活跃会话状态 (来自 $stateFile)"
    $content = Get-Content $stateFile
    $totalLines = $content.Count
    if ($totalLines -gt 100) {
        $content | Select-Object -First 100 | ForEach-Object { Write-Host $_ }
        Write-Host "... (已截断 — 共 $totalLines 行，显示前 100 行)"
    } else {
        $content | ForEach-Object { Write-Host $_ }
    }
} else {
    Write-Host ""
    Write-Host "## 未找到活跃会话状态文件"
    Write-Host "建议定期维护 production/session-state/active.md 以便更好地恢复。"
}

Write-Host ""
Write-Host "## 已修改的文件 (git 工作树)"

$changed = git diff --name-only 2>$null
$staged = git diff --staged --name-only 2>$null
$untracked = git ls-files --others --exclude-standard 2>$null

if ($changed) {
    Write-Host "未暂存的变更:"
    $changed | ForEach-Object { Write-Host "  - $_" }
}
if ($staged) {
    Write-Host "已暂存的变更:"
    $staged | ForEach-Object { Write-Host "  - $_" }
}
if ($untracked) {
    Write-Host "新未跟踪的文件:"
    $untracked | ForEach-Object { Write-Host "  - $_" }
}
if (-not $changed -and -not $staged -and -not $untracked) {
    Write-Host "  (没有未提交的变更)"
}

# 检查设计文档中的进行中标记
Write-Host ""
Write-Host "## 设计文档 — 进行中的工作"
$wipFound = $false
$designFiles = Get-ChildItem "design/gdd/*.md" -ErrorAction SilentlyContinue
foreach ($f in $designFiles) {
    $incomplete = Select-String -Path $f.FullName -Pattern "TODO|WIP|PLACEHOLDER|\[TO BE|\[TBD\]" -ErrorAction SilentlyContinue
    if ($incomplete) {
        $wipFound = $true
        Write-Host "  $($f.Name):"
        $incomplete | ForEach-Object { Write-Host "    $($_.LineNumber): $($_.Line.Trim())" }
    }
}
if (-not $wipFound) {
    Write-Host "  (在设计文档中未发现进行中标记)"
}

# 记录压缩日志
$sessionLogDir = "production/session-logs"
if (-not (Test-Path $sessionLogDir)) {
    New-Item -ItemType Directory -Path $sessionLogDir -Force | Out-Null
}
"上下文压缩发生于 $(Get-Date)。" | Out-File -FilePath "$sessionLogDir/compaction-log.txt" -Append -Encoding utf8

Write-Host ""
Write-Host "## 恢复说明"
Write-Host "压缩后，请读取 $stateFile 以恢复完整的工作上下文。"
Write-Host "然后读取上面列出的正在积极处理的文件。"
Write-Host "=== 会话状态结束 ==="

exit 0
