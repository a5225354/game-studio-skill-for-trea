# session-start.ps1 - Trae Game Studio 会话启动脚本
# 显示项目上下文信息（git 状态、冲刺、里程碑、代码健康度）
# 手动执行方式: .\hooks\session-start.ps1

Write-Host "=== Trae Game Studio — 会话上下文 ==="

# 获取当前分支
$branch = git rev-parse --abbrev-ref HEAD 2>$null
if ($branch) {
    Write-Host "分支: $branch"
    Write-Host ""
    Write-Host "最近的提交:"
    $commits = git log --oneline -5 2>$null
    if ($commits) {
        $commits | ForEach-Object { Write-Host "  $_" }
    }
}

# 检测活跃冲刺
$latestSprint = Get-ChildItem "production/sprints/sprint-*.md" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
if ($latestSprint) {
    Write-Host ""
    Write-Host "活跃冲刺: $($latestSprint.BaseName)"
}

# 检测活跃里程碑
$latestMilestone = Get-ChildItem "production/milestones/*.md" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
if ($latestMilestone) {
    Write-Host "活跃里程碑: $($latestMilestone.BaseName)"
}

# 统计未解决的 Bug
$bugCount = 0
foreach ($dir in @("tests/playtest", "production")) {
    if (Test-Path $dir) {
        $bugs = Get-ChildItem "$dir/BUG-*.md" -ErrorAction SilentlyContinue
        $bugCount += $bugs.Count
    }
}
if ($bugCount -gt 0) {
    Write-Host "未解决的 Bug: $bugCount"
}

# 检查 src/ 中的 TODO/FIXME
if (Test-Path "src") {
    $todoCount = (Select-String -Path "src/**/*" -Pattern "TODO" -ErrorAction SilentlyContinue).Count
    $fixmeCount = (Select-String -Path "src/**/*" -Pattern "FIXME" -ErrorAction SilentlyContinue).Count
    if ($todoCount -gt 0 -or $fixmeCount -gt 0) {
        Write-Host ""
        Write-Host "代码健康: ${todoCount} 个 TODO, ${fixmeCount} 个 FIXME 在 src/ 中"
    }
}

# 检测活跃会话状态
$stateFile = "production/session-state/active.md"
if (Test-Path $stateFile) {
    Write-Host ""
    Write-Host "=== 检测到活跃会话状态 ==="
    Write-Host "上一次会话留下了状态文件: $stateFile"
    Write-Host "请读取此文件以恢复上下文并从中断处继续。"
    Write-Host ""
    Write-Host "快速摘要:"
    $content = Get-Content $stateFile -TotalCount 20
    $content | ForEach-Object { Write-Host $_ }
    $totalLines = (Get-Content $stateFile).Count
    if ($totalLines -gt 20) {
        Write-Host "  ... (共 $totalLines 行 — 请读取完整文件以继续)"
    }
    Write-Host "=== 会话状态预览结束 ==="
}

Write-Host "==================================="
exit 0
