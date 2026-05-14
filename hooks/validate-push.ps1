# validate-push.ps1 - Trae Game Studio 推送前验证脚本
# 在推送到受保护分支时发出警告
# 手动执行方式: .\hooks\validate-push.ps1

$currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
if (-not $currentBranch) { exit 0 }

$protectedBranches = @("develop", "main", "master")
$matchedBranch = ""

foreach ($branch in $protectedBranches) {
    if ($currentBranch -eq $branch) {
        $matchedBranch = $branch
        break
    }
}

if ($matchedBranch) {
    Write-Host "检测到向受保护分支 '$matchedBranch' 推送。"
    Write-Host "提醒: 确保构建通过，单元测试通过，且不存在 S1/S2 级 Bug。"
    # 取消下方注释以改为阻断模式:
    # Write-Error "已阻断: 推送到 $matchedBranch 前请先运行测试"
    # exit 2
}

exit 0
