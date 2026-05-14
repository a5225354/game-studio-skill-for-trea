# validate-commit.ps1 - Trae Game Studio 提交前验证脚本
# 检查暂存文件: 设计文档章节完整性、JSON有效性、硬编码值、TODO格式
# 手动执行方式: .\hooks\validate-commit.ps1

# 获取已暂存的文件
$staged = git diff --cached --name-only 2>$null
if (-not $staged) {
    exit 0
}

$stagedFiles = $staged -split "`n" | Where-Object { $_ -ne "" }
$warnings = @()

# 检查设计文档是否包含必需的章节
$requiredSections = @("Overview", "Player Fantasy", "Detailed", "Formulas", "Edge Cases", "Dependencies", "Tuning Knobs", "Acceptance Criteria")

foreach ($file in $stagedFiles) {
    if ($file -match "^design/gdd/" -and $file -match "\.md$" -and (Test-Path $file)) {
        $content = Get-Content $file -Raw
        foreach ($section in $requiredSections) {
            if ($content -notmatch "(?i)$section") {
                $warnings += "设计: $file 缺少必需的章节: $section"
            }
        }
    }
}

# 验证 JSON 数据文件
foreach ($file in $stagedFiles) {
    if ($file -match "^assets/data/.*\.json$" -and (Test-Path $file)) {
        try {
            Get-Content $file -Raw | ConvertFrom-Json | Out-Null
        } catch {
            Write-Error "阻断: $file 不是有效的 JSON"
            exit 2
        }
    }
}

# 检查游戏代码中是否存在硬编码的游戏数值
foreach ($file in $stagedFiles) {
    if ($file -match "^src/gameplay/" -and (Test-Path $file)) {
        $hardcoded = Select-String -Path $file -Pattern "(damage|health|speed|rate|chance|cost|duration)\s*[:=]\s*\d+" -ErrorAction SilentlyContinue
        if ($hardcoded) {
            $warnings += "代码: $file 可能包含硬编码的游戏数值。请使用数据文件 (assets/data/)。"
        }
    }
}

# 检查没有负责人的 TODO/FIXME
foreach ($file in $stagedFiles) {
    if ($file -match "^src/" -and (Test-Path $file)) {
        $badTodos = Select-String -Path $file -Pattern "(TODO|FIXME|HACK)\s*$" -ErrorAction SilentlyContinue
        if ($badTodos) {
            $warnings += "规范: $file 中的 TODO/FIXME 没有负责人标签。请使用 TODO(name) 格式。"
        }
    }
}

# 输出警告 (非阻断)
if ($warnings.Count -gt 0) {
    Write-Host "=== 提交验证警告 ==="
    foreach ($w in $warnings) {
        Write-Host $w
    }
    Write-Host "=============================="
}

exit 0
