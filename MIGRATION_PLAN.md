# 🎮 Claude Code Game Studios → Trae IDE 改造方案

> **目的**: 将基于 Claude Code 的游戏开发 Skill 完整适配到 Trae IDE 平台
> **最后更新**: 2026-05-13

---

## 📊 当前改造进度

| 阶段 | 任务 | 状态 | 进度说明 |
|------|------|------|----------|
| 🧭 | **仓库克隆与分析** | ✅ 完成 | 已克隆原始仓库,完成全量内容分析 |
| 📝 | **改造方案文档** | ✅ 完成 | 本文档 |
| 🏗️ Phase 1 | **基础框架搭建** | ✅ 完成 | SKILL.md(主入口)、skill-system.md(架构)、README.md(说明) |
| 🏗️ Phase 2 | **核心工作流改造 (5个)** | ✅ 完成 | start、brainstorm、setup-engine、design-system、code-review |
| 🏗️ Phase 3 | **冲刺与项目管理 (8个)** | ✅ 完成 | sprint-plan、milestone-review、retrospective、estimate、scope-check、bug-report、project-stage-detect、reverse-document |
| 🏗️ Phase 4 | **团队协作技能 (7个)** | ✅ 完成 | team-combat、team-narrative、team-ui、team-release、team-polish、team-audio、team-level |
| 🏗️ Phase 5 | **发布与运营技能** | ✅ 完成 | release-checklist、launch-checklist、hotfix、changelog、patch-notes、gate-check、localize |
| 🏗️ Phase 6 | **剩余技能+规则+角色 (48角色+其余技能+11规则)** | ✅ 完成 | 10技能+48角色+11规则，共69文件 |
| 🏗️ Phase 7 | **钩子PowerShell替代 (8个)** | ✅ 完成 | 全部8个Bash→PowerShell重写，零外部依赖 |
| 🏗️ Phase 8 | **文档模板+引擎参考 (70+文件)** | ✅ 完成 | 29模板+44引擎参考+5示例=78文件，CC引用已清理 |
| 🧪 | **端到端测试验证** | ✅ 完成 | TEST_REPORT.md（10项测试全部通过，1个Bug修复） |
| 🔍 | **Phase 1+2 审查报告** | ✅ 完成 | REVIEW_P1_P2.md（合规性审查通过） |
| 🔍 | **Phase 3 审查报告** | ✅ 完成 | REVIEW_P3.md（合规性审查通过，无问题） |
| 🔍 | **Phase 4 审查报告** | ✅ 完成 | REVIEW_P4.md（合规性审查通过，零问题） |
| 🔍 | **Phase 5 审查报告** | ✅ 完成 | REVIEW_P5.md（合规性审查通过，零问题） |
| 🔍 | **Phase 6 审查报告** | ✅ 完成 | REVIEW_P6.md（69文件全部合规） |
| 🔍 | **Phase 7 审查报告** | ✅ 完成 | REVIEW_P7.md（8个PS脚本全部合规） |
| 🔍 | **Phase 8 审查报告** | ✅ 完成 | REVIEW_P8.md（78文件全部复制/更新，零问题） |

**总体进度: 11/11 ✅✅✅✅✅✅✅✅✅✅✅ 🎉全部完成**

---

## 一、改造概述

### 1.1 改造策略: "扁平化嵌入 + 编排器模式"

```
原架构                                  →   改造后架构
═══════════════════════════════════════════════════════════════
48个角色代理 (独立子代理, 有模型选择)       角色指令嵌入Skill提示词中
37个斜杠命令 (独立Skill)                     37个Trae Skill 工作流文件
8个Shell钩子 (事件自动触发)                  手动PowerShell脚本 / 提示词内检查
11个路径规则 (文件路径自动匹配执行)           提示词内编码规范检查指令
settings.json (权限/钩子配置)                .trae/rules/project_rules.md
CLAUDE.md (自动加载的入口)                   Trae Skill入口提示词 (SKILL.md)
上下文压缩 + 会话状态                        文件持久化 + TodoWrite状态跟踪
```

### 1.2 改造原则

| 原则 | 说明 |
|------|------|
| ✅ **保持协作哲学不变** | "提问→选项→决策→草稿→批准"的协作模式原样保留 |
| ✅ **角色知识完整保留** | 48个代理承载的游戏设计理论知识(MDA/SDT/Bartle等)全部保留 |
| ✅ **去掉不可用的底层机制** | 钩子、路径规则自动匹配、子代理模型选择等用替代方案 |
| ✅ **利用Trae自身工具** | TodoWrite、AskUserQuestion、Task(search)、GetDiagnostics |
| ✅ **保持模板兼容** | 29个文档模板、引擎参考保持原样,确保产出格式不受影响 |

---

## 二、整体架构对照

### 2.1 Claude Code vs Trae: 能力矩阵

| Claude Code 功能 | 在原始仓库中的用法 | Trae 是否直接支持 | 改造方式 |
|------------------|--------------------|-------------------|----------|
| **Task 子代理** (subagent_type) | 48个角色代理,可指定模型(Opus/Sonnet/Haiku)、限制工具集、设置maxTurns、分配专属skills | ⚠️ 仅支持 `search` 类型 | 角色扮演式提示词注入 |
| **斜杠命令** (`/xxx`) | 37个技能通过 `/brainstorm`、`/code-review` 等调用, 带 argument-hint | ❌ 不支持 | 改为意图识别+技能文件读取 |
| **Hooks 钩子系统** | 8个Bash脚本, 会话开始/结束/压缩/提交时自动触发 | ❌ 不支持 | PowerShell脚本+提示词内检查 |
| **settings.json** | 权限allow/deny、钩子配置、状态栏命令 | ❌ 不同机制 | `.trae/rules/project_rules.md` |
| **CLAUDE.md** | 项目级的自动加载入口提示词 | ❌ 不同机制 | Trae Skill的 SKILL.md |
| **路径范围规则** | YAML frontmatter中声明 `paths` 模式, 编辑匹配文件时自动应用 | ❌ 不支持 | 嵌入编码技能提示词 |
| **AskUserQuestion** | 结构化决策UI, 2-4个选项带描述 | ✅ 完全支持 | 直接原样使用 |
| **TodoWrite** | 任务管理 | ✅ 完全支持 | 直接使用, 增强进度跟踪 |
| **上下文压缩** | 预压缩钩子+主动compact | ❌ 不同机制 | 文件持久化+TodoWrite |
| **WebSearch** | 获取引擎最新文档 | ✅ 支持 | 原样使用 |
| **RunCommand** | 执行git、构建等 | ✅ 支持(需审批) | 适配Windows/PowerShell |

### 2.2 改造后的文件结构

```
d:\GAME\GameSkill\Claude-Code-Game-Studios.trae-skill\
├── MIGRATION_PLAN.md              # ★ 本文档 (改造方案)
├── SKILL.md                       # ★ 主Skill入口 (替代原始CLAUDE.md)
├── README.md                      # Trae版使用说明
├── skill-system.md                # 系统架构与协作原则
│
├── agents/                        # 48个角色定义 (移除YAML frontmatter)
│   ├── creative-director.md       # 第1层: 总监
│   ├── technical-director.md
│   ├── producer.md
│   ├── game-designer.md           # 第2层: 部门负责人
│   ├── lead-programmer.md
│   ├── ... (共48个)
│
├── skills/                        # 37个工作流技能
│   ├── start.md                   # Phase 2: 核心工作流
│   ├── brainstorm.md
│   ├── code-review.md
│   ├── sprint-plan.md
│   ├── design-system.md
│   ├── team-combat.md             # Phase 4: 团队编排
│   └── ... (共37个)
│
├── rules/                         # 11个编码规范
│   ├── gameplay-code.md
│   ├── engine-code.md
│   └── ... (共11个)
│
├── templates/                     # 29个文档模板 (原样保留)
│   ├── game-design-document.md
│   ├── sprint-plan.md
│   └── ... (共29个)
│
├── hooks/                         # PowerShell替代脚本 (Bash→PS1)
│   ├── validate-commit.ps1
│   ├── session-start.ps1
│   └── ... (共8个)
│
├── docs/                          # 引擎参考文档 (原样保留)
│   └── engine-reference/
│       ├── godot/
│       ├── unity/
│       └── unreal/
│
├── examples/                      # 工作流示例 (原样保留)
│   ├── reverse-document-workflow-example.md
│   └── ...
│
└── production/                    # 生产状态目录
    └── session-state/
        └── .gitkeep
```

---

## 三、核心模块改造详细方案

### 模块1: 主Skill入口

#### 🔷 Claude Code 原来怎么做

原始仓库使用 `CLAUDE.md` 作为自动加载的入口配置, 文件内容如下结构:

```markdown
# Claude Code Game Studios -- 游戏工作室代理架构

## 技术栈
- 引擎：[选择：Godot 4 / Unity / Unreal Engine 5]
- 语言：[选择：GDScript / C# / C++ / Blueprint]
...

## 项目结构
@.claude/docs/directory-structure.md

## 引擎版本参考
@docs/engine-reference/godot/VERSION.md

## 协调规则
@.claude/docs/coordination-rules.md
```

**关键机制**:
- `CLAUDE.md` 在每次会话启动时由 Claude Code 自动读取, 注入到系统提示词中
- 使用 `@文件路径` 语法引用其他文件, Claude Code 会自动展开
- 搭配 `.claude/settings.json` 配置权限、钩子、状态栏等

#### 🔷 Trae 改造后怎么做

在 Trae 中无法自动加载 CLI 配置, 改为**主动调用式 Skill**:

1. 创建 `SKILL.md` 作为主入口文件
2. 用户在 Trae 中通过 `Skill` 工具调用 `game-studio` 技能
3. Skill 提示词中包含所有核心系统指令
4. 用户使用自然语言表达意图 (如"我想做一个卡牌游戏"), 主Skill 识别意图后路由到对应工作流

改造后的 `SKILL.md` 结构:

````markdown
# Game Studio Skill for Trae

你将扮演一个完整的游戏开发工作室协调者。

## 你的核心任务
当用户调用此技能时, 你进入"游戏工作室模式"。
根据用户的意图, 路由到合适的工作流。

## 可用资源
- `agents/` — 48个专业角色定义
- `skills/` — 37个结构化工作流
- `rules/` — 11套编码规范
- `templates/` — 29个专业文档模板

## 工作模式
严格遵循协作设计原则：
1. **提问** → 在提出方案前先澄清需求
2. **选项** → 展示2-4个方案带理由
3. **决策** → 使用 AskUserQuestion 让用户选择
4. **草稿** → 逐章节起草文档
5. **批准** → 写入文件前获得用户确认

## 角色激活
需要使用特定角色时, 读取 `agents/[角色名].md` 
并在当前上下文中扮演该角色。
````

**改造要点**:
- 移除 `@文件引用` 语法 (Trae 不支持), 改为明确的文件读取指令
- 移除 settings.json 依赖, 权限和行为约束写在提示词中
- 增加意图识别的路由逻辑

---

### 模块2: 角色代理系统

#### 🔷 Claude Code 原来怎么做

48个角色代理通过 YAML frontmatter + Task 工具实现:

```yaml
---
name: game-designer
description: "游戏设计师..."
tools: Read, Glob, Grep, Write, Edit, WebSearch
model: sonnet                         # ← 选择AI模型
maxTurns: 20                          # ← 限制回合数
disallowedTools: Bash                 # ← 禁止特定工具
skills: [design-review, balance-check, brainstorm]  # ← 专属技能
---

你是一名独立游戏项目的游戏设计师...

### 委派映射
委派给：
- `systems-designer`：详细子系统设计
- `level-designer`：空间与遭遇设计
- `economy-designer`：经济平衡与战利品表

向以下人员汇报：`creative-director`
```

关键机制:
- `subagent_type` 指定代理名称, Claude Code 在 Task 工具中调用
- 每个代理有独立模型(Opus/Sonnet/Haiku)和工具权限
- 代理间有委派/上报关系(层级结构)
- 团队技能中使用 `Task` 工具并行调用多个子代理

#### 🔷 Trae 改造后怎么做

由于 Trae 的 Task 工具只支持 `search` 类型, 无法创建角色子代理。改造为 **"角色扮演式提示词注入"** 策略:

##### (1) 角色定义文件格式改造

移除 YAML frontmatter, 改为纯 Markdown 角色指令:

```markdown
# 角色: 游戏设计师 (game-designer)

## 角色定位
- **层级**: 第2层 — 部门负责人
- **上级**: creative-director (创意总监)
- **下级**: systems-designer、level-designer、economy-designer
- **协作方**: lead-programmer、narrative-director、ux-designer

## 激活方式
当用户需要设计游戏机制/系统/数值时, 主Skill读取此文件,
你在当前对话上下文中即扮演游戏设计师角色。

## 核心职责
1. **核心循环设计**: 定义逐刻、会话和长期的游戏循环
2. **系统设计**: 设计相互关联的游戏系统
3. **平衡框架**: 建立平衡方法论和数学模型
4. **玩家体验映射**: 使用 MDA 框架
... (原有内容全部保留)

## 理论框架
(完整保留 MDA/SDT/Bartle/心流理论等)

## 设计文档标准
(完整保留 8 章节要求)

## 协作协议
严格遵循: 提问→选项→决策→草稿→批准
使用 AskUserQuestion 工具呈现结构化选择界面
写入文件前必须获得用户确认
```

##### (2) 角色激活流程

```
用户: "帮我设计一个战斗系统"
        ↓
主Skill: 检测到"设计"意图 → 需要 game-designer 角色
        ↓
主Skill: 读取 agents/game-designer.md
        ↓
主Skill (现在扮演 game-designer):
  "我来帮你设计战斗系统。首先，几个问题：
   1. 核心幻想是什么？（精准时机？战术走位？）
   2. 实时还是回合制？
   3. 深度与可及性如何平衡？"
        ↓
用户: [回答]
        ↓
主Skill (作为 game-designer):
  [提供 2-4 个方案及优缺点分析]
  [使用 AskUserQuestion 让用户选择]
```

##### (3) 多角色切换

当工作流需要多个角色时, 使用 **顺序切换** 模式:

```
Phase 1: 激活 game-designer    → 完成设计
Phase 2: 激活 gameplay-programmer → 完成架构
Phase 3: 激活 qa-tester       → 完成测试
```

每次切换时用 `TodoWrite` 跟踪当前阶段和进度。

##### (4) 变更对照

| 维度 | Claude Code 原做法 | Trae 改造后做法 |
|------|--------------------|-----------------|
| 代理定义 | YAML frontmatter + 模型/tools/maxTurns配置 | 纯Markdown角色指令 |
| 代理调用 | Task(subagent_type="game-designer") 独立上下文 | 主上下文内角色扮演 |
| 并行执行 | Task工具并行调用多个子代理 | 顺序阶段切换 |
| 模型选择 | Opus/Sonnet/Haiku 独立选择 | 依赖Trae当前模型 |
| 工具限制 | disallowedTools: Bash | 提示词中声明行为边界 |
| 委派/上报 | coordination-rules.md 定义 | 角色文件内注明,主Skill遵循 |

---

### 模块3: 37个技能工作流

#### 🔷 Claude Code 原来怎么做

37个技能以斜杠命令形式存在, 每个技能是一个独立的 `SKILL.md` 文件:

```yaml
---
name: sprint-plan
description: "生成新的冲刺计划或更新现有计划"
argument-hint: "[new|update|status]"    # ← 参数提示
user-invocable: true                     # ← 用户可直接调用
allowed-tools: Read, Glob, Grep, Write, Edit  # ← 工具白名单
context: |
  !ls production/sprints/ 2>/dev/null   # ← 自动执行的上下文命令
---

当此技能被调用时：
1. 读取当前里程碑...
2. 读取上一个冲刺...
3. 扫描设计文档...
...
```

**关键机制**:
- 用户在Claude Code中输入 `/sprint-plan new` 触发
- `argument-hint` 提供参数自动补全
- `context` 字段中的命令在技能加载时自动执行
- `allowed-tools` 限制技能可用的工具

#### 🔷 Trae 改造后怎么做

Trae 不支持斜杠命令。改造为 **意图驱动** 的工作流文件:

##### (1) 技能文件格式改造

移除 YAML frontmatter, 改为纯指令文件:

```markdown
# Sprint Plan — 冲刺规划技能

触发条件:
- 用户说"规划冲刺" / "创建冲刺" / "Sprint Plan"
- 用户说"查看冲刺进度" / "Sprint Status"
- 用户说"更新冲刺" / "Update Sprint"

## 执行流程

### 1. 读取当前里程碑
使用 Read 工具读取 production/milestones/ 中最新的里程碑文件

### 2. 读取上一个冲刺
使用 Glob 工具查找 production/sprints/sprint-*.md
读取最新的冲刺文件了解速率和未完成事项

### 3. 扫描设计文档
使用 Glob 工具查找 design/gdd/*.md
识别已标记为可实施的功能

### 4. 根据参数执行

如果是 "new":
  使用 AskUserQuestion 询问用户:
  - 这个冲刺的主要目标是什么？
  - 可用时间（小时/天）？
  
  然后生成冲刺计划（格式如下）:
  ```markdown
  # Sprint [N] -- [开始日期] 至 [结束日期]
  ## Sprint 目标
  ## 产能
  ## 任务（必须/应该/可以）
  ## 风险
  ```

如果是 "status":
  读取当前冲刺文件
  扫描已完成/进行中/未开始的任务
  生成状态报告

### 5. 写入文件前确认
使用 AskUserQuestion 或对话方式询问:
"我可以将此冲刺计划写入 production/sprints/sprint-0N.md 吗？"
```

##### (2) 技能触发方式

在 Trae 中, 用户通过自然语言触发技能:

| Claude Code 原方式 | Trae 改造后触发方式 |
|--------------------|-------------------|
| `/start` | "开始新游戏" / "我不知道做什么" |
| `/brainstorm roguelike` | "帮我头脑风暴一个Roguelike概念" |
| `/sprint-plan new` | "创建新冲刺" / "规划冲刺" |
| `/code-review src/gameplay/` | "审查 src/gameplay/ 下的代码" |
| `/design-review design/gdd/combat.md` | "审查 combat 设计文档" |
| `/team-combat "钩爪能力"` | "用战斗团队开发钩爪能力" |

##### (3) 变更对照

| 维度 | Claude Code 原做法 | Trae 改造后做法 |
|------|--------------------|-----------------|
| 触发方式 | 斜杠命令 `/sprint-plan new` | 自然语言意图识别 |
| 参数传递 | argument-hint 自动补全 | 从对话中提取参数 |
| 工具限制 | allowed-tools 自动执行 | 提示词内声明可用工具 |
| 上下文命令 | context 字段自动执行 | 手动在指令中要求执行 |
| 子代理调用 | Team技能调用Task子代理 | 角色扮演式顺序切换 |
| 文件格式 | YAML frontmatter + Markdown | 纯 Markdown 指令 |

---

### 模块4: 钩子系统

#### 🔷 Claude Code 原来怎么做

8个Bash脚本, 通过 `settings.json` 中的 hooks 配置自动触发:

```json
// .claude/settings.json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "bash .claude/hooks/session-start.sh",
        "timeout": 10
      }]
    }],
    "PreToolUse": [{...}],     // Bash工具使用前
    "PostToolUse": [{...}],    // Write/Edit工具使用后
    "PreCompact": [{...}],     // 上下文压缩前
    "Stop": [{...}],           // 会话关闭时
    "SubagentStart": [{...}]   // 子代理启动时
  }
}
```

#### 🔷 Trae 改造后怎么做

Trae 无钩子系统, 采用**双重替代**策略:

##### 方案A: 手动PowerShell脚本 (8个)

Bash脚本改为PowerShell版本, 用户在需要时手动执行:

| 原始Bash钩子 | 触发时机 | PowerShell替代 | 改造说明 |
|-------------|---------|----------------|----------|
| `session-start.sh` | 会话开始 | `hooks/session-start.ps1` | 显示git状态、冲刺信息 |
| `detect-gaps.sh` | 会话开始 | 嵌入start技能 | 检测项目缺失项 |
| `validate-commit.sh` | git commit前 | `hooks/validate-commit.ps1` | 检查硬编码、JSON有效性、TODO格式 |
| `validate-push.sh` | git push前 | `hooks/validate-push.ps1` | 检查推送目标分支 |
| `validate-assets.sh` | 写入assets文件 | `hooks/validate-assets.ps1` | 验证命名规范和JSON结构 |
| `pre-compact.sh` | 上下文压缩前 | 无法自动触发 | 嵌入技能提示词内提醒 |
| `session-stop.sh` | 会话关闭 | `hooks/session-stop.ps1` | 记录工作成果 |
| `log-agent.sh` | 子代理启动 | 废除 | TodoWrite替代记录 |

##### PowerShell 改造示例 (session-start.ps1)

原始 Bash:
```bash
#!/bin/bash
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
echo "=== 会话上下文 ==="
echo "分支: $BRANCH"
git log --oneline -5
```

改造为 PowerShell:
```powershell
# session-start.ps1 - 游戏工作室会话启动脚本
Write-Host "=== Trae Game Studio — 会话上下文 ==="
$branch = git rev-parse --abbrev-ref HEAD 2>$null
if ($branch) {
    Write-Host "分支: $branch"
    Write-Host "最近的提交:"
    git log --oneline -5
}
$sprints = Get-ChildItem "production/sprints/sprint-*.md" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
if ($sprints) {
    Write-Host "活跃冲刺: $($sprints[0].BaseName)"
}
```

##### 方案B: 提示词内嵌检查 (作为备选)

在关键技能的提示词中嵌入检查指令:

```
## 代码提交前检查 (请在提交前执行)
1. 检查 `src/` 中无硬编码数值 → 运行: grep -r "=\s*\d\+" src/gameplay/
2. 检查 assets/data/*.json 有效性
3. 检查 design/gdd/*.md 是否包含8个必需章节
```

##### 变更对照

| 维度 | Claude Code 原做法 | Trae 改造后做法 |
|------|--------------------|-----------------|
| 触发机制 | 事件驱动自动执行 | 手动执行PS脚本 / 技能提示词内提醒 |
| 脚本语言 | Bash (POSIX) | PowerShell (Windows原生) |
| 工具依赖 | jq、grep、bash | PowerShell cmdlet |
| 子代理审计 | log-agent.sh 自动 | TodoWrite 记录调用 |
| 上下文保存 | pre-compact.sh 自动 | 无法自动,提示词内提醒 + 手动保存 |

---

### 模块5: 路径范围规则

#### 🔷 Claude Code 原来怎么做

11个规则文件, 通过 YAML frontmatter 声明路径匹配模式:

```yaml
---
paths:
  - "src/gameplay/**"     # ← Claude Code自动匹配
---
# 玩法代码规则
- 所有玩法数值必须来自外部配置/数据文件，禁止硬编码
- 所有时间相关的计算必须使用 delta time
- 禁止直接引用 UI 代码 — 使用事件/信号进行通信
...
```

当 Claude Code 检测到编辑的文件匹配 `src/gameplay/**` 时, 自动将此规则注入当前上下文的系统提示词中。

#### 🔷 Trae 改造后怎么做

Trae 没有自动路径匹配机制。改造为 **技能提示词内嵌**:

##### 改造方案

将规则文件改为纯 Markdown, 在主Skill和编码相关技能中明确规定:

```
## 📏 编码规范
当生成或修改代码时, 根据文件所在路径遵循对应规范:

### 如果你在 src/gameplay/ 下写代码:
→ 读取 rules/gameplay-code.md
关键规则:
- 禁止硬编码数值, 使用 assets/data/ 配置
- 使用 delta time 进行时间计算
- 通过信号/事件通信, 禁止直接引用UI
- 状态机必须有明确转换表

### 如果你在 src/ai/ 下写代码:
→ 读取 rules/ai-code.md
关键规则:
- 性能预算: 所有AI 2ms/帧
- 数据驱动参数, 支持调试可视化
- 攻击前0.5秒预警

### 如果你在 src/ui/ 下写代码:
→ 读取 rules/ui-code.md
...
```

##### 变更对照

| 维度 | Claude Code 原做法 | Trae 改造后做法 |
|------|--------------------|-----------------|
| 触发方式 | 编辑文件时YAML paths自动匹配 | AI代码生成时提示词内检查 |
| 规则格式 | YAML frontmatter + Markdown | 纯 Markdown |
| 执行保证 | 自动强制 | 依赖AI主动遵循 |
| 规则更新 | 修改文件即时生效 | 修改后需告知AI重新读取 |

---

### 模块6: 文档模板与引擎参考

这两个模块**原样保留**, 仅做路径调整:

| 文档类型 | 来源 | 目标 | 改造 |
|---------|------|------|------|
| 28个设计文档模板 | `.claude/docs/templates/` | `templates/` | 原样复制 |
| 3套引擎参考文档 | `docs/engine-reference/godot|unity|unreal/` | `docs/engine-reference/` | 原样复制 |
| 引擎版本锁定 | `engine-reference/*/VERSION.md` | 保留 | 需提醒用户更新版本 |
| 最佳实践 | `engine-reference/*/current-best-practices.md` | 保留 | 过时API提醒改为自行查阅 |
| 引擎模块说明 | `engine-reference/*/modules/` | 保留 | 原样复制 |
| 引擎插件说明 | `engine-reference/*/plugins/` | 保留 | 原样复制 |

---

### 模块7: 团队编排技能

#### 🔷 Claude Code 原来怎么做

7个团队技能使用 Task 工具并行创建多个子代理:

```yaml
# team-combat/SKILL.md
---
name: team-combat
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, Task, AskUserQuestion, TodoWrite
---

## 如何委派
使用 Task 工具将每位团队成员生成为子代理:
- subagent_type: game-designer — 设计机制
- subagent_type: gameplay-programmer — 实现核心玩法
- subagent_type: ai-programmer — NPC/敌人AI
- subagent_type: technical-artist — VFX和着色器
- subagent_type: sound-designer — 音频事件
- subagent_type: qa-tester — 测试验证

阶段3可以并行启动多个代理。
```

#### 🔷 Trae 改造后怎么做

由于无并行子代理能力, 改造为 **顺序阶段流水线**:

```
流水线:
  阶段1 (设计)
    → 读取 agents/game-designer.md, 扮演游戏设计师
    → 创建设计文档
    → AskUserQuestion 决策点
    
  阶段2 (架构)
    → 读取 agents/gameplay-programmer.md, 扮演程序员
    → 设计代码架构
    → AskUserQuestion 决策点
    
  阶段3 (实现) — 原为并行, 现为顺序
    → gameplay-programmer: 核心机制代码
    → ai-programmer: AI行为
    → technical-artist: VFX规格
    → sound-designer: 音频规格
    → 各阶段用 TodoWrite 跟踪进度
    
  阶段4 (集成) → 阶段5 (验证) → 阶段6 (签收)
```

使用 `TodoWrite` 跟踪6个阶段的进度:

```
任务: 团队战斗 - 钩爪能力
├── ✅ 阶段1: 设计 (game-designer)
├── ✅ 阶段2: 架构 (gameplay-programmer)
├── 🔄 阶段3: 实现 (并行角色)
│   ├── ✅ gameplay-programmer: 核心代码
│   ├── 🔄 ai-programmer: AI行为
│   ├── ⬜ technical-artist: VFX
│   └── ⬜ sound-designer: 音频
├── ⬜ 阶段4: 集成
├── ⬜ 阶段5: 验证 (qa-tester)
└── ⬜ 阶段6: 签收
```

##### 变更对照

| 维度 | Claude Code 原做法 | Trae 改造后做法 |
|------|--------------------|-----------------|
| 编排方式 | Task并行子代理 (独立上下文) | 顺序阶段+角色切换 |
| 团队组成 | 6个独立子代理 | 1个主上下文内顺序扮演6个角色 |
| 决策流 | 子代理→编排者→用户→返回子代理 | 角色→用户→切换角色 |
| 并行执行 | ✓ 支持并行 | ✗ 只能顺序 |
| 进度跟踪 | Task返回摘要 | TodoWrite 可视化跟踪 |
| 上下文管理 | 子代理独立上下文 | 所有内容在主上下文 |

---

## 四、关键技术差异对照表

| # | 技术点 | Claude Code | Trae IDE | 影响 | 对策 |
|---|--------|------------|----------|------|------|
| 1 | **子代理系统** | Task(subagent_type) 48角色 | Task(search only) | 🔴 高 | 角色扮演式注入 |
| 2 | **并行子代理** | Task可并行调用 | 不支持 | 🟡 中 | 顺序阶段+TodoWrite |
| 3 | **斜杠命令** | `/xxx` 用户触发 | 无 | 🟡 中 | 自然语言意图识别 |
| 4 | **事件钩子** | 6类事件自动触发 | 无 | 🟡 中 | PS脚本+提示词提醒 |
| 5 | **路径匹配规则** | YAML paths自动注入 | 无 | 🟢 低 | 编码时提示词内提醒 |
| 6 | **AskUserQuestion** | ✅ | ✅ | 🟢 无 | 原样使用 |
| 7 | **TodoWrite** | ✅ | ✅ | 🟢 无 | 原样使用 |
| 8 | **模型选择** | Opus/Sonnet/Haiku | Trae默认 | 🟡 中 | 依赖Trae当前模型 |
| 9 | **自动配置加载** | CLAUDE.md + settings.json | 无 | 🟡 中 | Skill工具手动加载 |
| 10 | **上下文压缩** | PreCompact钩子+compact | 无 | 🟢 低 | 文件持久化策略 |
| 11 | **Bash脚本** | 8个.sh钩子 | 需PowerShell | 🟡 中 | 全部改写为.ps1 |
| 12 | **@文件引用** | @path展开文件内容 | 不支持 | 🟢 低 | 明确Read指令 |
| 13 | **权限控制** | settings.json allow/deny | .trae/rules | 🟢 低 | 环境规则文件 |
| 14 | **引擎文档获取** | WebSearch实时获取 | 支持 | 🟢 无 | 原样使用 |

---

## 五、实施路线图

### 详细改造步骤

```
Phase 1: 基础框架         Phase 2: 核心工作流        Phase 3: 管理技能
     ↓                        ↓                        ↓
  SKILL.md                start.md               sprint-plan.md
  README.md               brainstorm.md          milestone-review.md
  skill-system.md         setup-engine.md        retrospective.md
                          design-system.md       estimate.md
                          code-review.md         scope-check.md
                          (5个技能)              bug-report.md
                                                 project-stage-detect.md
                                                 reverse-document.md
                                                 (8个技能)
     ↓                        ↓                        ↓
Phase 4: 团队协作         Phase 5: 发布运营        Phase 6: 全量改造
     ↓                        ↓                        ↓
  team-combat.md         release-checklist.md    48个角色文件
  team-narrative.md      launch-checklist.md     11个规则文件
  team-ui.md             changelog.md            剩余技能文件
  team-release.md        patch-notes.md
  team-polish.md         hotfix.md
  team-audio.md          gate-check.md
  team-level.md          localize.md
  (7个技能)              (7个技能)
     ↓                        ↓                        ↓
Phase 7: 钩子替代         Phase 8: 模板+参考         测试验证
     ↓                        ↓                        ↓
  8个PowerShell脚本       29个模板复制             端到端测试
                          3套引擎参考复制
```

### 文件处理统计

| 类别 | 文件数 | 处理方式 | 需要新建 | 需要改造 | 原样复制 |
|------|--------|----------|---------|---------|---------|
| 主Skill入口 | 3 | 新建 | ✅ 3个 | - | - |
| 角色代理 | 48 | 改造 | - | ✅ 48个 | - |
| 工作流技能 | 37 | 改造 | - | ✅ 37个 | - |
| 编码规则 | 11 | 改造 | - | ✅ 11个 | - |
| 钩子脚本 | 8 | 重写 | ✅ 8个 | - | - |
| 文档模板 | 29 | 复制 | - | - | ✅ 29个 |
| 引擎参考 | ~40 | 复制 | - | - | ✅ ~40个 |
| 示例文档 | ~5 | 复制+更新 | - | ✅ ~5个 | - |
| **总计** | **~181** | | **11个** | **101个** | **~69个** |

---

> 📌 **下一步**: 确认此方案后, 从 Phase 1 开始执行改造工作。

---

# 🆕 2026-05-14 更新：原版 v0.4.x → v1.0 差异分析与改造方案

> **对比时间**: 2026-05-14
> **原版版本**: v1.0 (commit range `49d1e45..HEAD`, released 2026-05-13)
> **Trae版基线**: 约 v0.3.0 ~ v0.4.0 之间的版本
> **差异跨度**: 原版经历了 v0.3.0→v0.4.0→v0.4.1→v1.0.0-beta→v1.0 的多次迭代

---

## 📊 差异总览

| 类别 | 原版 (v1.0) | Trae版 (当前) | 差异 | 严重程度 |
|------|-------------|---------------|------|----------|
| 角色代理 (Agents) | 49 | 48 | **+1** (godot-csharp-specialist) | 🟢 低 |
| 工作流技能 (Skills) | 73 | 37 | **+36** | 🔴 高 |
| 钩子脚本 (Hooks) | 12 | 8 | **+4** (均为.sh) | 🟡 中 |
| 文档模板 (Templates) | 40 | 29 | **+11** | 🟡 中 |
| 核心架构文档 | 17个 `.claude/docs/` 文件 | 0（已内嵌到SKILL.md等） | 结构性差异 | 🟡 中 |
| 工作流指南 | WORKFLOW-GUIDE.md (1700+行) | SKILL.md内嵌 (325行) | 内容量差异大 | 🟡 中 |
| 测试框架 | CCGS Skill Testing Framework/ | 无 | 全新模块 | 🟢 低 |
| 设计目录 | design/ (CLAUDE.md + registry) | 无 | 全新模块 | 🟢 低 |
| 项目根文件 | +CONTRIBUTING.md, SECURITY.md, UPGRADING.md, .gitignore | 无 | +4个文件 | 🟢 低 |
| 已有Skill内容更新 | 多个skill增加AskUserQuestion、--review flag、director gates | 未同步 | 功能增强 | 🟡 中 |
| 协作设计原则 | COLLABORATIVE-DESIGN-PRINCIPLE.md (688行) | SKILL.md内嵌摘要 | 详细度差异 | 🟢 低 |

---

## 一、新增角色代理 (Agent)

### 1.1 godot-csharp-specialist

| 项目 | 说明 |
|------|------|
| **原版路径** | `.claude/agents/godot-csharp-specialist.md` |
| **用途** | Godot 4 项目的 C# 代码质量专家：.NET 模式、attribute-based exports、signal delegates、async 模式、类型安全节点访问、C# 特有 Godot 惯用法 |
| **模型** | sonnet, maxTurns: 20 |
| **触发场景** | 用户在 `/setup-engine` 中为 Godot 选择 C# 语言时激活 |

#### 🔷 改造方案

```
1. 从原版复制 godot-csharp-specialist.md
2. 移除 YAML frontmatter (name, description, tools, model, maxTurns)
3. 添加 Trae 版角色激活说明
4. 放置到 agents/godot-csharp-specialist.md
5. 更新 SKILL.md 角色层级图中增加此角色
```

**改造工作量**: 🟢 低 (~5分钟)

---

## 二、新增技能工作流 (Skills) — 36个

### 2.1 技能分类清单

#### 📦 类别A：自我管理与入门 (3个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `help` | 上下文感知的"下一步做什么"，读取当前阶段和已有产物 | Any | 🔴 高 |
| `adopt` | 棕地项目迁移审计，识别GDD/ADR/Story的格式缺口，生成迁移计划 | Any | 🟡 中 |
| `skill-improve` | 通过 test-fix-retest 循环改进技能文件 | Any | 🟢 低 |

#### 📦 类别B：设计与创作 (6个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `art-bible` | 逐章节编写美术圣经（9个章节），艺术风格规范 | 1-2 | 🟡 中 |
| `asset-spec` | 单个资产的视觉规格和AI生成提示词，读取art-bible+GDD | 5-6 | 🟢 低 |
| `ux-design` | 引导式UX规格编写（screen/flow、HUD、交互模式库三种模式） | 4 | 🔴 高 |
| `ux-review` | UX规格审查：GDD对齐、无障碍层级、交互模式库 | 4 | 🔴 高 |
| `quick-design` | 轻量级规格，用于调优、小改动，无需完整8章节GDD | 2+ | 🟡 中 |
| `review-all-gdds` | 跨GDD一致性检查+设计理论审查（博弈论、认知负荷等） | 2 | 🟡 中 |

#### 📦 类别C：架构 (4个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `architecture-review` | 验证所有ADR的拓扑排序、引擎兼容性、TR-ID注册表 | 3 | 🔴 高 |
| `create-architecture` | 创建主架构文档 `docs/architecture/architecture.md` | 3 | 🔴 高 |
| `create-control-manifest` | 从已接受的ADR生成平面化程序员规则表 | 3 | 🟡 中 |
| `propagate-design-change` | GDD变更后找到受影响的ADR和Stories，生成影响报告 | 5 | 🟡 中 |

#### 📦 类别D：管线与故事 (6个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `create-epics` | 从GDD+ADR翻译为Epic（每个架构模块一个Epic） | 4 | 🔴 高 |
| `create-stories` | 将单个Epic分解为可实现的Story文件 | 4 | 🔴 高 |
| `dev-story` | 实现一个Story，自动路由到正确的程序员代理 | 5 | 🔴 高 |
| `story-done` | 8阶段故事完成审查：验证验收标准、检查GDD/ADR偏差、更新状态 | 5 | 🔴 高 |
| `story-readiness` | 验证Story是否准备好被实现（设计/架构/范围/DoD） | 4-5 | 🔴 高 |
| `sprint-status` | 快速30行冲刺快照，读取 `sprint-status.yaml` | 5 | 🟡 中 |

#### 📦 类别E：质量与审计 (4个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `consistency-check` | 跨GDD实体和公式不一致扫描 | 2+ | 🟡 中 |
| `content-audit` | 对比GDD指定的内容与实际已实现内容，发现内容缺口 | 5 | 🟡 中 |
| `security-audit` | 安全漏洞审计（存档、网络、输入验证） | 6-7 | 🟢 低 |
| `bug-triage` | 重新评估所有开放Bug的优先级、严重性和负责人 | 5+ | 🟡 中 |

#### 📦 类别F：QA与测试 (9个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `qa-plan` | 为冲刺或功能生成QA测试计划，按测试类型分类Stories | 5 | 🔴 高 |
| `smoke-check` | 关键路径冒烟测试门禁 | 5-6 | 🟡 中 |
| `soak-test` | 长时间浸泡测试协议（稳定性、内存泄漏） | 6 | 🟢 低 |
| `regression-suite` | 映射测试覆盖到GDD关键路径，识别缺少回归测试的已修复Bug | 5-6 | 🟡 中 |
| `test-setup` | 为所选引擎搭建测试框架和CI/CD管线 | 4 | 🔴 高 |
| `test-helpers` | 生成引擎特定的测试辅助库（GDUnit4/NUnit等） | 4-5 | 🟡 中 |
| `test-evidence-review` | 测试文件和手动测试证据的质量审查 | 5 | 🟢 低 |
| `test-flakiness` | 从CI运行日志检测非确定性测试 | 5-6 | 🟢 低 |
| `skill-test` | 验证技能文件的结构合规性和行为正确性（3种模式） | Any | 🟢 低 |

#### 📦 类别G：创意与发布 (2个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `vertical-slice` | Pre-Production门禁：生产质量端到端构建，验证完整游戏循环 | 4 | 🔴 高 |
| `day-one-patch` | 首发日补丁：Gold Master后发现问题的有限范围修复 | 7+ | 🟢 低 |

#### 📦 类别H：团队编排 (2个)

| Skill | 用途 | Phase | 优先级 |
|-------|------|------|--------|
| `team-live-ops` | 协调 live-ops-designer + economy-designer + community-manager + analytics-engineer | 7+ | 🟡 中 |
| `team-qa` | 编排 qa-lead + qa-tester + gameplay-programmer + producer 完整QA周期 | 6-7 | 🟡 中 |

---

### 2.2 改造方案

所有36个新 Skill 遵循与已有37个相同的改造模式：

```
原版格式 (.claude/skills/<name>/SKILL.md)  →  Trae版格式 (skills/<name>.md)
```

#### 改造步骤（每个Skill）

1. **读取原版 SKILL.md**
2. **移除 YAML frontmatter** (`name`, `description`, `argument-hint`, `allowed-tools`, `context`, `user-invocable` 等字段)
3. **替换斜杠命令引用**:
   - `/xxx` → 自然语言触发条件描述
   - 例如: `/design-system combat` → "用户说'设计战斗系统'时触发"
4. **替换 Task 子代理调用**:
   - `spawn x via Task` → "读取 agents/x.md 并在当前上下文扮演"
   - 并行 Task 调用 → 顺序角色切换 + TodoWrite 跟踪
5. **添加 Trae 专用工具说明**:
   - `AskUserQuestion` — 原样保留（原版已使用）
   - `TodoWrite` — 增强任务跟踪
   - `Read` — 读取设计文档/角色文件
6. **更新 SKILL.md 意图路由表**: 为每个新 Skill 添加关键词映射

#### 改造工作量估算

| 优先级 | Skill数量 | 预计每个耗时 | 总耗时 |
|--------|----------|-------------|--------|
| 🔴 高 (Phase 9) | 14 | 15-20 min | ~4-5 h |
| 🟡 中 (Phase 10) | 15 | 15-20 min | ~4-5 h |
| 🟢 低 (Phase 11) | 7 | 10-15 min | ~1.5-2 h |
| **总计** | **36** | | **~10-12 h** |

---

## 三、新增钩子脚本 (Hooks) — 4个

| 原版文件 | 触发时机 | 功能 | 是否需要PS移植 |
|---------|---------|------|---------------|
| `log-agent-stop.sh` | SubagentStop | Agent完成时记录审计日志（完成时间戳 → agent-audit.log） | 🟢 可选（Trae无子代理停止事件） |
| `notify.sh` | Notification | Windows桌面气泡通知（通过PowerShell调用WinForms NotifyIcon） | 🟢 可选（独立通知工具） |
| `post-compact.sh` | PostCompact | 上下文压缩后提醒从active.md恢复工作状态 | 🟢 可选（Trae无PostCompact事件） |
| `validate-skill-change.sh` | PostToolUse (skills/) | 技能文件被修改后建议运行 `/skill-test` | 🟢 可选（可在提示词中嵌入提醒） |

### 3.1 改造方案

| Hook | 方案 | 理由 |
|------|------|------|
| `log-agent-stop.sh` | **不移植** | Trae无子代理机制，无SubagentStop事件 |
| `notify.sh` | **移植为 notify.ps1** | 作为独立工具可手动执行，弹出通知提醒 |
| `post-compact.sh` | **嵌入提示词** | 在 SKILL.md 和 skills/start.md 中加入压缩恢复提醒 |
| `validate-skill-change.sh` | **嵌入提示词** | 在 SKILL.md 中加入技能文件修改后的验证提醒 |

---

## 四、新增文档模板 (Templates) — 11个

| 模板文件 | 用途 | 阶段 |
|---------|------|------|
| `accessibility-requirements.md` | 无障碍需求文档（4轴特性矩阵：视觉/运动/认知/听觉） | Phase 3 |
| `architecture-traceability.md` | 架构可追溯性矩阵（需求→ADR→代码的追溯链） | Phase 3 |
| `difficulty-curve.md` | 难度曲线设计模板 | Phase 2 |
| `hud-design.md` | HUD布局设计模板 | Phase 4 |
| `interaction-pattern-library.md` | 交互模式库（16个标准控件+游戏特定模式） | Phase 4 |
| `player-journey.md` | 玩家旅程映射模板 | Phase 1-2 |
| `prototype-report.md` | 原型验证报告模板 | Phase 1 |
| `skill-test-spec.md` | 技能测试规格模板 | Any |
| `test-evidence.md` | 测试证据文档模板 | Phase 5 |
| `ux-spec.md` | UX规格模板（screen/flow、HUD、交互模式） | Phase 4 |
| `vertical-slice-report.md` | 垂直切片报告模板 | Phase 4 |

### 4.1 改造方案

**全部11个模板 → 原样复制**，放入 `templates/` 目录。

这些模板是纯内容文档，不包含 YAML frontmatter 或 Claude Code 特有语法。

**改造工作量**: 🟢 低 (~15分钟，全部原样复制)

---

## 五、新增核心文档与目录

### 5.1 WORKFLOW-GUIDE.md (1700+行)

原版 `docs/WORKFLOW-GUIDE.md` 是完整的工作流指南，覆盖7个Phase的详细步骤。

#### 🔷 改造方案

| 方案 | 说明 |
|------|------|
| **A: 原样复制** | 直接复制到 `docs/WORKFLOW-GUIDE.md`，清理 CC 特有引用 |
| **B: 拆分为技能内嵌** | 将各 Phase 指南拆入对应技能文件（如 start.md, gate-check.md） |

**推荐方案A** + 清理：
- 移除 `/xxx` 斜杠命令引用，改为自然语言描述
- 移除 `@文件引用` 语法
- 移除 `settings.json`、`hooks` 等 CC 特有概念
- 保留完整的 Phase 流程说明

### 5.2 director-gates.md

原版 `.claude/docs/director-gates.md` 定义了所有总监门禁的标准化提示词。

#### 🔷 改造方案

- **原样复制** 到 `docs/director-gates.md`
- 移除 Task(spawn) 引用，改为角色扮演说明
- 保留 full/lean/solo 三种审查模式逻辑

### 5.3 COLLABORATIVE-DESIGN-PRINCIPLE.md (688行)

原版已有此文件。Trae版的 SKILL.md 已内嵌了核心协作原则摘要。

#### 🔷 改造方案

- **原样复制** 到 `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md`
- 清理 CC 特有引用
- 在 SKILL.md 中添加引用链接

### 5.4 CCGS Skill Testing Framework

这是一个完整的技能测试框架，包含49个agent的行为规格和73个skill的测试规格。

#### 🔷 改造方案

| 选项 | 说明 |
|------|------|
| **复制整个目录** | 放入 `testing/` 目录，作为参考 |
| **跳过** | Trae版不需要，因为skill形式不同 |

**推荐**: 复制作为参考，放入 `docs/testing-framework/`（重命名以避免空格问题）

### 5.5 其他新增文件

| 原版路径 | 改造后路径 | 处理方式 |
|---------|-----------|---------|
| `CONTRIBUTING.md` | 根目录 | 原样复制（贡献指南） |
| `SECURITY.md` | 根目录 | 原样复制（安全策略） |
| `UPGRADING.md` | 根目录 | 原样复制（升级指南，有用参考） |
| `.gitignore` | 根目录 | 原样复制 |
| `design/CLAUDE.md` | `docs/design-directory-guide.md` | 改造为设计目录指南 |
| `docs/CLAUDE.md` | `docs/docs-directory-guide.md` | 改造为文档目录指南 |
| `.claude/docs/workflow-catalog.yaml` | `docs/workflow-catalog.yaml` | 原样复制（7阶段管线定义） |
| `.claude/docs/agent-roster.md` | `docs/agent-roster.md` | 复制并移除YAML |
| `.claude/docs/coordination-rules.md` | `docs/coordination-rules.md` | 改造（移除模型路由） |
| `.claude/docs/context-management.md` | `docs/context-management.md` | 复制并适配Trae |
| `.claude/docs/coding-standards.md` | `docs/coding-standards.md` | 复制（SKILL.md已内嵌摘要） |
| `.claude/docs/directory-structure.md` | `docs/directory-structure.md` | 复制（SKILL.md已内嵌） |
| `.claude/docs/quick-start.md` | `docs/quick-start.md` | 复制并适配 |
| `.claude/docs/technical-preferences.md` | `docs/technical-preferences.md` | 复制（引擎偏好模板） |
| `.claude/docs/review-workflow.md` | `docs/review-workflow.md` | 复制 |
| `.claude/docs/skills-reference.md` | `docs/skills-reference.md` | 复制并更新为Trae版 |
| `.claude/docs/rules-reference.md` | `docs/rules-reference.md` | 复制 |
| `.claude/docs/hooks-reference.md` | `docs/hooks-reference.md` | 复制并更新为PS版 |
| `.claude/docs/setup-requirements.md` | `docs/setup-requirements.md` | 复制 |
| `.claude/docs/agent-coordination-map.md` | `docs/agent-coordination-map.md` | 复制 |
| `.claude/docs/CLAUDE-local-template.md` | `docs/local-template.md` | 复制 |
| `.claude/docs/settings-local-template.md` | `docs/settings-local-template.md` | 复制 |
| `.claude/docs/hooks-reference/*.md` (6个) | `docs/hooks-reference/` | 复制并更新 |

---

## 六、已有文件的内容更新

根据原版 UPGRADING.md，以下已有Skill在原版中被更新。但Trae版已完成扁平化改造，需要人工对比决定是否合并更新：

### 6.1 重大功能新增

#### Director Gates 系统 (v1.0新增)

原版新增了 `director-gates.md` 定义了标准化总监门禁，影响以下Skill：
brainstorm, map-systems, design-system, architecture-decision, create-architecture, create-epics, create-stories, sprint-plan, milestone-review, playtest-report, prototype, story-done, gate-check

#### Gate Intensity Modes (full/lean/solo)

三种审查强度模式：
- `full`: 所有总监门禁在每个步骤运行
- `lean`: 仅在阶段转换处运行（默认）
- `solo`: 无总监审查

通过 `production/review-mode.txt` 全局配置，或 `--review [mode]` 单次覆盖。

#### 🔷 改造方案

由于Trae版不使用Task子代理（无真正的director spawning），Director Gates系统在Trae中意义有限。**建议方案**：

- 在 SKILL.md 中添加审查模式说明（full/lean/solo的概念）
- 在 gate-check.md 中实现简化的门禁检查逻辑（检查产物是否存在，而非spawn director审查）
- 原样保留 director-gates.md 作为参考

### 6.2 已有Skill的关键更新

| Skill | 原版更新内容 | Trae版是否需要 | 改造说明 |
|-------|-------------|--------------|---------|
| `brainstorm` | +art-director并行spawn, Visual Identity Anchor, +Task to allowed-tools | ⚠️ 部分需要 | 添加艺术方向考虑，但不涉及Task spawn |
| `design-system` | 路由表扩展+art-director, +Visual/Audio章节, +UX Flag | ✅ 需要 | 更新技能指令内容 |
| `gate-check` | +art-director作为第4并行director, 阶段写入stage.txt | ⚠️ 部分需要 | 更新门禁检查项列表 |
| `team-combat` ~ `team-qa` | +no-arg guards, +Verdict关键词, +AskUserQuestion门禁, +NO-GO路径 | ✅ 需要 | 同步团队技能的改进模式 |
| `sprint-plan` | +sprint-status.yaml写入 | ✅ 需要 | 添加YAML状态文件生成 |
| `map-systems` | +entity inventory步骤 | ✅ 需要 | 添加实体清单步骤 |
| `setup-engine` | +Godot语言选择步骤(GDScript vs C#) | ✅ 需要 | 添加语言选择 |
| `start` | +Phase 3b审查模式设置 | ✅ 需要 | 添加审查模式选择 |
| `prototype` | 概念原型 vs 垂直切片的区分 | ✅ 需要 | 明确两种原型用途 |

---

## 七、实施路线图 (Phase 9~13)

### Phase 9: 🔴 高优先级技能改造 (14个 Skill)

```
help.md                    ← 上下文感知导航
create-epics.md            ← Epic创建
create-stories.md          ← Story分解
dev-story.md               ← Story实现路由
story-done.md              ← 8阶段完成审查
story-readiness.md         ← Story就绪验证
qa-plan.md                 ← QA测试计划
test-setup.md              ← 测试框架搭建
ux-design.md               ← UX规格编写
ux-review.md               ← UX规格审查
architecture-review.md     ← 架构审查
create-architecture.md     ← 主架构文档
vertical-slice.md          ← 垂直切片门禁
godot-csharp-specialist.md ← 新角色代理
```

### Phase 10: 🟡 中优先级技能改造 (15个 Skill)

```
adopt.md                   ← 棕地迁移
art-bible.md               ← 美术圣经
quick-design.md            ← 轻量级设计
review-all-gdds.md         ← 跨GDD审查
create-control-manifest.md ← 控制清单
propagate-design-change.md ← 设计变更传播
sprint-status.md           ← 冲刺快照
consistency-check.md       ← 一致性检查
content-audit.md           ← 内容审计
bug-triage.md              ← Bug分类
smoke-check.md             ← 冒烟测试
regression-suite.md        ← 回归测试
test-helpers.md            ← 测试辅助库
team-live-ops.md           ← 实时运营团队
team-qa.md                 ← QA团队
```

### Phase 11: 🟢 低优先级改造 (11个 Skill + 模板 + 文档)

```
asset-spec.md              ← 资产规格
security-audit.md          ← 安全审计
soak-test.md               ← 浸泡测试
test-evidence-review.md    ← 测试证据审查
test-flakiness.md          ← 测试不稳定性
skill-test.md              ← 技能测试
skill-improve.md           ← 技能改进
day-one-patch.md           ← 首发日补丁
+11个新模板（原样复制）
+4个新Hook（notify.ps1移植 + 3个提示词嵌入）
+核心文档复制（WORKFLOW-GUIDE.md等17+个文件）
```

### Phase 12: 📝 SKILL.md 主入口更新

```
1. 更新数字: 48角色→49, 37工作流→73, 钩子→12
2. 扩展意图路由表: 添加36个新Skill的关键词映射
3. 更新角色层级图: 增加godot-csharp-specialist
4. 添加新功能说明: Director审查模式、故事生命周期、QA框架
5. 添加 docs/ 目录下新文档的引用
```

### Phase 13: 🧪 端到端验证

```
1. 验证所有新增Skill文件的格式一致性
2. 验证SKILL.md路由表覆盖所有73个Skill
3. 验证agent数量=49
4. 验证template数量=40
5. 验证hook数量=9 (8已有+1 notify.ps1)
```

---

## 八、文件处理统计

| 类别 | 新增 | 改造 | 原样复制 | 总计 |
|------|------|------|---------|------|
| 角色代理 | 1 | 1 | - | 1 |
| 工作流技能 | - | 36 | - | 36 |
| 钩子脚本 | 1 (notify.ps1) | - | - | 1 |
| 文档模板 | - | - | 11 | 11 |
| 核心文档 | - | 20+ | 5+ | 25+ |
| SKILL.md更新 | - | 1 (大幅更新) | - | 1 |
| **总计** | **2** | **58+** | **16+** | **75+** |

---

## 九、原版关键版本演进路线图

```
v0.1.0 (2026-02-21)
  └─ 初始版本: 角色系统, 基本Skill

v0.2.0 (2026-02-21)
  └─ +start, +map-systems, +design-system, +session hooks
  └─ AskUserQuestion集成, CLAUDE.md精简

v0.3.0 (2026-03-09)
  └─ design-systems→map-systems 重命名
  └─ +design-system GDD编写, +statusline

v0.4.0 (2026-03-21) ★ Trae版基线约在此附近
  └─ +29个新Skill (UX/UI管线, 完整Story生命周期, QA框架)
  └─ +4个新Hook, +8个新模板
  └─ workflow-catalog.yaml, sprint-status.yaml

v0.4.1 (2026-03-26)
  └─ +consistency-check
  └─ 所有team-* Skill改进 (no-arg guards, Verdict关键词)

v0.4.1.1 (2026-04-02)
  └─ +art-bible, +asset-spec
  └─ +3个director gates
  └─ brainstorm/design-system/gate-check/team-level/team-narrative 更新

v1.0.0-beta (2026-03-29)
  └─ Director gates系统正式化
  └─ Gate intensity modes (full/lean/solo)
  └─ +godot-csharp-specialist
  └─ 13个Skill更新支持 --review flag

v1.0 (2026-05-13) ★ 当前原版最新
  └─ +vertical-slice
  └─ +map-systems entity inventory
  └─ 7个Skill添加AskUserQuestion widgets
  └─ Bug修复 (#21, #36, #42, #43, #45)
  └─ +CONTRIBUTING.md, +SECURITY.md
```

---

> 📌 **本次更新的下一步**: 按 Phase 9→10→11→12→13 顺序执行改造。建议先从 Phase 9 的 14 个高优先级 Skill 和 Phase 12 的 SKILL.md 更新开始。
