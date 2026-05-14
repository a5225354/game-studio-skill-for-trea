# 环境要求

本 Skill 运行于 Trae IDE 中，核心功能通过 AI 对话实现，无需安装额外运行时依赖。
钩子脚本（可选）提供了本地验证能力。

## 必需

| 工具 | 用途 | 安装方式 |
|------|------|---------|
| **Trae IDE** | AI 协作开发环境 | [trae.ai](https://www.trae.ai/) |
| **Git** | 版本控制、分支管理 | [git-scm.com](https://git-scm.com/) |

## 推荐（用于钩子脚本）

| 工具 | 用途 | 安装方式 |
|------|------|---------|
| **PowerShell 5.1+** | 运行钩子验证脚本 | Windows 10+ 自带 |

## 钩子脚本说明

本 Skill 包含 9 个 PowerShell 钩子脚本（位于 `hooks/` 目录），用于辅助完成以下任务：

| 脚本 | 功能 | 何时使用 |
|------|------|---------|
| `session-start.ps1` | 显示当前分支和冲刺信息 | 开始工作会话时 |
| `session-stop.ps1` | 记录工作成果 | 结束工作会话时 |
| `validate-commit.ps1` | 检查硬编码值、TODO 格式等 | git commit 前 |
| `validate-push.ps1` | 检查推送目标分支 | git push 前 |
| `validate-assets.ps1` | 验证资产命名规范和结构 | 修改 assets/ 后 |
| `detect-gaps.ps1` | 检测项目缺失项 | 项目初始化时 |
| `pre-compact.ps1` | 保存会话进度 | 上下文过长需要压缩前 |
| `notify.ps1` | Windows 桌面通知 | 需要提醒时手动执行 |
| `log-agent.ps1` | 记录代理调用审计日志 | 角色切换时 |

这些脚本由用户**手动执行**，不会自动触发。执行方式：

```powershell
.\hooks\session-start.ps1
```

## 平台说明

### Windows 10+
- 所有钩子脚本使用 PowerShell 编写，零外部依赖
- PowerShell 5.1 及以上版本已预装在 Windows 10+ 中
- 在项目目录中通过 PowerShell 终端执行脚本

## 验证你的环境

运行以下命令检查环境是否就绪：

```powershell
git --version
$PSVersionTable.PSVersion
```

## 钩子脚本缺失时的影响

钩子脚本是本 Skill 的**可选辅助工具**。不使用钩子脚本不会影响核心的 AI 协作功能：

- Skill 入口（SKILL.md）通过 AI 对话工作，不依赖钩子脚本
- 代码验证、资产检查等功能可在 AI 对话中通过提示词内嵌检查完成
- 钩子脚本提供了更高效的本地一键验证能力，是推荐但非必需的功能
