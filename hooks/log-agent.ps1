# log-agent.ps1 - Trae Game Studio 角色调用审计脚本
# 记录角色激活情况以追踪工作流程
# 手动执行方式: .\hooks\log-agent.ps1 -AgentName "game-designer"

param(
    [string]$AgentName = "unknown"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$sessionLogDir = "production/session-logs"

if (-not (Test-Path $sessionLogDir)) {
    New-Item -ItemType Directory -Path $sessionLogDir -Force | Out-Null
}

"$timestamp | 角色激活: $AgentName" | Out-File -FilePath "$sessionLogDir/agent-audit.log" -Append -Encoding utf8

Write-Host "[审计] $timestamp - 角色 '$AgentName' 已记录"

exit 0
