# detect-gaps.ps1 - Trae Game Studio 文档缺口检测脚本
# 检测缺少设计文档的原型、代码无文档、缺失架构记录的缺口
# 手动执行方式: .\hooks\detect-gaps.ps1

$ErrorActionPreference = "SilentlyContinue"

Write-Host "=== 正在检查文档缺口 ==="

# --- 检查 0: 新项目检测 ---
$freshProject = $true

if (Test-Path "docs/engine-reference") {
    $refFiles = Get-ChildItem "docs/engine-reference" -Directory -ErrorAction SilentlyContinue
    if ($refFiles -and $refFiles.Count -gt 0) { $freshProject = $false }
}
if (Test-Path "design/gdd/game-concept.md") { $freshProject = $false }
if (Test-Path "src") {
    $srcExts = @("*.gd", "*.cs", "*.cpp", "*.c", "*.h", "*.hpp", "*.rs", "*.py", "*.js", "*.ts")
    $srcCheck = Get-ChildItem "src" -Recurse -Include $srcExts -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($srcCheck) { $freshProject = $false }
}

if ($freshProject) {
    Write-Host ""
    Write-Host "新项目: 未配置引擎，没有游戏概念，没有源代码。"
    Write-Host "   看起来是一个全新的开始！请告诉 AI: '开始新游戏'"
    Write-Host ""
    Write-Host "要获取全面的项目分析，请告诉 AI: '检测项目状态'"
    Write-Host "==================================="
    exit 0
}

# --- 检查 1: 大量代码但设计文档稀少 ---
$srcExts = @("*.gd", "*.cs", "*.cpp", "*.c", "*.h", "*.hpp", "*.rs", "*.py", "*.js", "*.ts")
$srcFiles = @(Get-ChildItem "src" -Recurse -Include $srcExts -ErrorAction SilentlyContinue)
$srcFileCount = $srcFiles.Count

$designFiles = @(Get-ChildItem "design/gdd/*.md" -ErrorAction SilentlyContinue)
$designFileCount = $designFiles.Count

if ($srcFileCount -gt 50 -and $designFileCount -lt 5) {
    Write-Host "缺口: 大量代码库 ($srcFileCount 个源文件) 但设计文档稀少 ($designFileCount 个文件)"
    Write-Host "    建议操作: 逆向文档化 (reverse-document)"
    Write-Host "    或告诉 AI: '检测项目状态' 获取完整分析"
}

# --- 检查 2: 没有文档的原型 ---
if (Test-Path "prototypes") {
    $protoDirs = Get-ChildItem "prototypes" -Directory -ErrorAction SilentlyContinue
    $undocumented = @()
    foreach ($dir in $protoDirs) {
        $hasReadme = Test-Path "$($dir.FullName)/README.md"
        $hasConcept = Test-Path "$($dir.FullName)/CONCEPT.md"
        if (-not $hasReadme -and -not $hasConcept) {
            $undocumented += $dir.Name
        }
    }
    if ($undocumented.Count -gt 0) {
        Write-Host "缺口: 发现 $($undocumented.Count) 个未记录文档的原型:"
        foreach ($proto in $undocumented) {
            Write-Host "    - prototypes/$proto/ (没有 README 或 CONCEPT 文档)"
        }
        Write-Host "    建议操作: 逆向文档化概念 (reverse-document concept)"
    }
}

# --- 检查 3: 核心系统缺少架构文档 ---
if ((Test-Path "src/core") -or (Test-Path "src/engine")) {
    if (-not (Test-Path "docs/architecture")) {
        Write-Host "缺口: 核心引擎/系统已存在但没有 docs/architecture/ 目录"
        Write-Host "    建议操作: 创建 docs/architecture/ 并运行架构决策 (architecture-decision)"
    } else {
        $adrFiles = @(Get-ChildItem "docs/architecture/*.md" -ErrorAction SilentlyContinue)
        if ($adrFiles.Count -lt 3) {
            Write-Host "缺口: 核心系统已存在但仅记录了 $($adrFiles.Count) 个 ADR"
            Write-Host "    建议操作: 逆向文档化架构 (reverse-document architecture)"
        }
    }
}

# --- 检查 4: 游戏系统缺少设计文档 ---
if (Test-Path "src/gameplay") {
    $gameplayDirs = Get-ChildItem "src/gameplay" -Directory -ErrorAction SilentlyContinue
    foreach ($sysDir in $gameplayDirs) {
        $fileCount = (Get-ChildItem $sysDir.FullName -Recurse -File -ErrorAction SilentlyContinue).Count
        if ($fileCount -ge 5) {
            $designDoc1 = "design/gdd/$($sysDir.Name)-system.md"
            $designDoc2 = "design/gdd/$($sysDir.Name).md"
            if (-not (Test-Path $designDoc1) -and -not (Test-Path $designDoc2)) {
                Write-Host "缺口: 游戏系统 src/gameplay/$($sysDir.Name)/ ($fileCount 个文件) 没有设计文档"
                Write-Host "    建议操作: 逆向文档化设计 (reverse-document design)"
            }
        }
    }
}

# --- 检查 5: 生产规划 ---
if ($srcFileCount -gt 100) {
    if (-not (Test-Path "production/sprints") -and -not (Test-Path "production/milestones")) {
        Write-Host "缺口: 大型代码库 ($srcFileCount 个文件) 但未找到生产规划"
        Write-Host "    建议操作: 冲刺规划 (sprint-plan)"
    }
}

Write-Host ""
Write-Host "要获取全面的项目分析，请告诉 AI: '检测项目状态'"
Write-Host "==================================="

exit 0
