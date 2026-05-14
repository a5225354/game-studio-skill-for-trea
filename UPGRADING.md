# 升级指南 — Game Studio Skill for Trae

本指南覆盖从旧版本升级到新版本的操作步骤，以及从原始 Claude Code 版本迁移到
Trae 版本的说明。

---

## 目录

- [升级策略](#升级策略)
- [从 Claude Code 原版迁移到 Trae 版](#从-claude-code-原版迁移到-trae-版)
- [Trae 版版本历史](#trae-版版本历史)
- [原版关键版本演进（参考）](#原版关键版本演进参考)

---

## 升级策略

### 策略 A — Git Remote Merge（推荐）

适用于：你克隆了 Trae 版模板并在其基础上做了自定义修改。

```bash
git remote add template <Trae版仓库地址>
git fetch template main
git merge template/main --allow-unrelated-histories
```

Git 只会标记你和模板都修改过的文件的冲突。逐项解决即可。

### 策略 B — 手动文件复制

适用于：你没有使用 git 克隆模板（例如直接下载了 zip 包）。

1. 下载或克隆新版本到项目旁
2. 将 "Safe to overwrite" 下的文件直接复制
3. 对于 "Merge carefully" 下的文件，并排对比新旧版本，手动合并

---

## 从 Claude Code 原版迁移到 Trae 版

如果你之前使用的是原始 [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)，
迁移到 Trae 版需要注意以下关键变更：

### 架构差异

| 维度 | Claude Code 原版 | Trae 版 |
|------|--------------------|-----------|
| 角色调用 | Task 独立子代理（可指定模型） | 主上下文内角色扮演 |
| 工作流触发 | 斜杠命令（如 `/brainstorm`） | 自然语言意图识别 |
| 并行执行 | ✓ 支持多子代理并行 | ✗ 顺序阶段执行 |
| 自动钩子 | 事件驱动自动触发（Bash） | 手动 PowerShell 脚本 + 提示词内提醒 |
| 规则匹配 | 路径模式自动注入 | 提示词内主动声明遵循 |
| 配置文件 | `.claude/settings.json` + `CLAUDE.md` | `SKILL.md` + `.trae/rules/project_rules.md` |
| 入口方式 | 会话启动自动注入 | 用户调用 Skill 工具或自然语言触发 |

### 文件结构变化

```
Claude Code 原版                      →     Trae 版
═══════════════════════════════════════════════════════════════
CLAUDE.md                             →     SKILL.md
.claude/settings.json                 →     .trae/rules/project_rules.md
.claude/agents/*.md                   →     agents/*.md (移除YAML frontmatter)
.claude/skills/<name>/SKILL.md        →     skills/<name>.md (扁平化)
.claude/hooks/*.sh (Bash)             →     hooks/*.ps1 (PowerShell)
.claude/rules/*.md                    →     rules/*.md (移除paths YAML)
.claude/docs/templates/               →     templates/ (原样保留)
.claude/docs/ (各种参考文档)           →     docs/ (路径和引用已更新)
```

### 迁移步骤

1. **安装 Trae 版 Skill** — 将本仓库放入项目的 `.trae/skills/game-studio/` 目录
2. **移除旧配置文件** — 不再需要 `.claude/` 目录、`CLAUDE.md`、`settings.json`
3. **重新运行入门引导** — 告诉 AI "我开始一个新游戏项目" 触发入门流程
4. **重新配置引擎** — 告诉 AI 你的引擎和版本偏好
5. **审查模式设置** — 在 `production/review-mode.txt` 中设置审查强度

详细改造方案请参考 [MIGRATION_PLAN.md](MIGRATION_PLAN.md)。

---

## Trae 版版本历史

### v1.0 (2026-05-13)

对应原版 v1.0，完整覆盖 49 个角色和 73 个技能。

**包含内容：**
- 49 个角色代理（含 godot-csharp-specialist）
- 73 个工作流技能（全部 Phase 1~11 改造完成）
- 11 个编码规范
- 40 个文档模板
- 9 个 PowerShell 钩子脚本
- 3 套引擎参考文档（Godot/Unity/Unreal）
- 完整测试框架（73 技能 + 49 代理行为测试规格）
- 核心文档（WORKFLOW-GUIDE、director-gates、COLLABORATIVE-DESIGN-PRINCIPLE 等）

**新增功能（对应原版 v1.0）：**
- 垂直切片门禁（vertical-slice）
- 总监门禁系统（full/lean/solo 三种模式）
- Godot C# 专家角色
- Story 完整生命周期（story-readiness → dev-story → story-done）
- Epic/Story/冲刺管理体系
- 完整 UX 设计管线
- QA 测试框架（9 个技能）
- 9 个团队编排技能
- 安全审计、资产评估、试玩报告等

---

## 原版关键版本演进（参考）

以下为原始 Claude Code Game Studios 项目的版本演进路线，供了解本 Skill 的知识来源参考：

```
v0.1.0 (2026-02-21)
  └─ 初始版本：角色系统、基础 Skill

v0.2.0 (2026-02-21)
  └─ +start、+map-systems、+design-system、+会话钩子
  └─ AskUserQuestion 集成、CLAUDE.md 精简

v0.3.0 (2026-03-09)
  └─ design-systems → map-systems 重命名
  └─ +design-system GDD 编写、+statusline

v0.4.0 (2026-03-21) ★ Trae 版基线约在此附近
  └─ +29 个新 Skill（UX/UI 管线、完整 Story 生命周期、QA 框架）
  └─ +4 个新 Hook、+8 个新模板
  └─ workflow-catalog.yaml、sprint-status.yaml

v0.4.1 (2026-03-26)
  └─ +consistency-check
  └─ 所有 team-* 技能改进（no-arg guards、Verdict 关键词）

v0.4.1.1 (2026-04-02)
  └─ +art-bible、+asset-spec
  └─ +3 个 director gates
  └─ brainstorm/design-system/gate-check/team-level/team-narrative 更新

v1.0.0-beta (2026-03-29)
  └─ Director gates 系统正式化
  └─ Gate intensity modes（full/lean/solo）
  └─ +godot-csharp-specialist
  └─ 13 个 Skill 更新支持 --review flag

v1.0 (2026-05-13) ★ 当前原版最新，Trae 版同步至此
  └─ +vertical-slice
  └─ +map-systems entity inventory
  └─ 7 个 Skill 添加 AskUserQuestion widgets
  └─ Bug 修复（#21、#36、#42、#43、#45）
  └─ +CONTRIBUTING.md、+SECURITY.md
```
