# validate-assets.ps1 - Trae Game Studio 资产验证脚本
# 验证 assets/ 目录中文件的命名规范和 JSON 有效性
# 手动执行方式: .\hooks\validate-assets.ps1 -FilePath [路径]

param(
    [string]$FilePath = ""
)

if (-not $FilePath) {
    $FilePath = Read-Host "请输入资产文件路径"
}

# 标准化路径分隔符
$FilePath = $FilePath -replace '\\', '/'

# 仅处理 assets/ 下的文件
if ($FilePath -notmatch "(^|/)assets/") {
    exit 0
}

$filename = Split-Path $FilePath -Leaf
$warnings = @()

# 检查命名规范 (必须小写加下划线)
if ($filename -cmatch "[A-Z\s-]") {
    $warnings += "命名: $FilePath 必须为小写加下划线 (当前: $filename)"
}

# 验证资产数据目录中的 JSON 有效性
if ($FilePath -match "(^|/)assets/data/.*\.json$" -and (Test-Path $FilePath)) {
    try {
        Get-Content $FilePath -Raw | ConvertFrom-Json | Out-Null
    } catch {
        $warnings += "格式: $FilePath 不是有效的 JSON"
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "=== 资产验证 ==="
    foreach ($w in $warnings) {
        Write-Host $w
    }
    Write-Host "========================"
}

exit 0
