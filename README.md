# 🎮 Game Studio Skill for Trae

> 将一个 Trae AI 会话变成一个完整的游戏开发工作室。
> **49 个角色。73 个工作流。9 个钩子。** 一支协同的 AI 团队。

---

## 这是什么

**Game Studio Skill for Trae** 是从 [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) 改造而来的 Trae IDE 技能（Skill）。它通过结构化的角色系统和工作流，让你在 Trae 中获得专业游戏工作室级别的 AI 协助。

原始项目基于 Claude Code 的 CLI 子代理系统构建，拥有 49 个专业角色代理、73 个斜杠命令工作流、12 个自动化钩子和 11 个路径范围编码规则。本 Skill 将其核心知识体系完整迁移到 Trae 平台，采用"扁平化嵌入 + 编排器模式"的改造策略，使原版的协作哲学和专业知识得以完整保留。

**当前版本对应原版 v1.0 (2026-05-13)，已包含原版全部 73 个技能和 49 个角色的完整覆盖。**

## 快速开始

### 前置要求

- [Trae IDE](https://www.trae.ai/) — 已安装并可用
- Git — 版本控制（推荐）

### 安装

Trae 默认从 `./.trae/skills/` 目录中读取技能文件，因此有两种安装方式：

#### 方式一：放入 Trae 技能目录（推荐）

将本 Skill 目录复制到项目的 `.trae/skills/` 下：

```
your-game-project/
├── .trae/
│   └── skills/
│       └── game-studio/          # ← 将本 Skill 目录放这里
│           ├── SKILL.md
│           ├── agents/
│           ├── skills/
│           └── ...
```

放入后 Trae 会自动识别，直接在对话中描述需求即可触发。

#### 方式二：放在项目其他目录

如果将 Skill 放在项目其他位置（如项目根目录），需要通过 `#` 前缀指引 Trae 识别：

```
"#game-studio 帮我开始一个新游戏"
```

这样 Trae 会加载指定目录中的 `SKILL.md` 作为技能入口。

### 第一步：运行入门引导

在 Skill 激活后，告诉 AI：

```
"我开始一个新游戏项目，没有想法"
```

AI 会执行入门引导，问你当前状态，然后引导到正确的工作流。

### 如果你已经有想法

```
"我想做一个 Roguelike 卡牌游戏"
```

AI 会路由到头脑风暴工作流，帮你发展概念。

```
"帮我配置使用 Godot 4.5 引擎"
```

AI 会路由到引擎配置工作流。

## 包含内容

| 类别 | 数量 | 说明 |
|------|------|------|
| **角色** | 49 | 覆盖设计、编程、美术、音频、叙事、QA、制作和引擎的专业角色 |
| **工作流** | 73 | 覆盖 7 阶段全开发管线的结构化工作流 |
| **编码规范** | 11 | 针对不同代码路径的专业编码标准 |
| **文档模板** | 40 | GDD、ADR、冲刺计划、UX/HUD、经济模型、无障碍、玩家旅程等模板 |
| **引擎参考** | 3 套 | Godot/Unity/Unreal 版本锁定参考文档 |
| **钩子脚本** | 9 | PowerShell 版本的会话管理和验证脚本 |
| **核心文档** | 20+ | 工作流指南、协作设计原则、总监门禁、编码标准、管线目录等 |
| **测试框架** | 1 套 | 73 技能 + 49 代理的行为测试规格参考 |

## 工作室层级

```
第 1 层 — 总监
  creative-director    technical-director    producer

第 2 层 — 部门负责人
  game-designer        lead-programmer       art-director
  audio-director       narrative-director    qa-lead
  release-manager      localization-lead

第 3 层 — 专家（25 个）
  gameplay-programmer  engine-programmer     ai-programmer
  network-programmer   ui-programmer         tools-programmer
  systems-designer     level-designer        economy-designer
  technical-artist     sound-designer        writer
  world-builder        ux-designer           prototyper
  performance-analyst  devops-engineer       analytics-engineer
  security-engineer    qa-tester             accessibility-specialist
  live-ops-designer    community-manager

引擎专家（16 个 — 三大引擎全覆盖）
  godot-specialist     godot-gdscript-specialist   godot-csharp-specialist
  godot-shader-specialist   godot-gdextension-specialist
  unity-specialist     unity-dots-specialist    unity-shader-specialist
  unity-addressables-specialist   unity-ui-specialist
  unreal-specialist    ue-blueprint-specialist  ue-gas-specialist
  ue-replication-specialist   ue-umg-specialist
```

### 审查模式

总监门禁系统支持三种审查强度（`full` / `lean` / `solo`），在 `docs/director-gates.md` 中定义。通过 `production/review-mode.txt` 全局配置或 `--review` 单次覆盖。

## 工作流一览

### 入门与导航
- 引导式入门 — 检测你的状态，引导到正确的工作流
- 引擎配置 — 选择并配置 Godot/Unity/Unreal（含 GDScript/C# 语言选择）
- 项目阶段检测 — 分析现有项目状态
- 上下文导航 — 分析当前阶段告诉你下一步做什么
- 棕地迁移 — 审计现有项目格式合规性，生成迁移计划

### 创意与设计
- 头脑风暴 — 使用 MDA/SDT/Bartle 框架构思游戏概念
- 系统设计 — 逐章节编写游戏设计文档（GDD）
- 设计评审 — 对照 8 章节标准审查 GDD
- 系统映射 — 分解系统依赖关系，确定设计优先级
- 轻量设计 — 适用于小改动的快速设计规格（<4 小时实现）
- 跨 GDD 审查 — 全 GDD 一致性检查 + 游戏设计整体论
- 一致性检查 — 跨 GDD 实体和公式不一致扫描
- 美术圣经 — 9 章节逐章节艺术视觉风格编写
- 资产规格 — 从 GDD 生成逐个资产视觉规格和 AI 生成提示词

### 架构与开发
- 架构决策 — 创建架构决策记录（ADR）
- 主架构文档 — 创建全系统架构蓝图
- 架构审查 — 可追溯矩阵 + 跨 ADR 冲突 + 引擎兼容性
- 控制清单 — 从已接受 ADR 生成平面化程序员规则表
- 设计变更传播 — GDD 变更 → 受影响 ADR 影响分析
- 代码审查 — 架构级代码审查
- 原型验证 — 快速搭建原型测试机制
- 垂直切片 — Pre-Production 生产质量端到端构建验证
- Story 实现 — Story → 代码路由（加载全上下文 + 路由到正确程序员角色）

### Stories 与冲刺管理
- Epic 创建 — 从 GDD + ADR 翻译为 Epic（每个架构模块一个）
- Story 分解 — Epic → 可实现的 Story 文件（含 QA 测试用例）
- Story 就绪验证 — 验证 Story 的实现就绪状态
- Story 完成审查 — 8 阶段验收标准验证 + 偏差检查
- 冲刺规划 — 创建和管理冲刺计划
- 冲刺快照 — 快速冲刺状态快照（只读，≤30 行）
- 里程碑评审 — 里程碑级别的进度检查
- 回顾 — 冲刺/里程碑结构回顾
- 工作量估算 — 复杂度与风险分析
- 范围检查 — 检测和防止范围蔓延
- 内容审计 — GDD 规定内容 vs 已实现内容对比

### 测试与质量
- QA 测试计划 — 按 Story 类型分类测试需求
- 冒烟测试 — 关键路径冒烟测试门禁
- 浸泡测试 — 扩展会话浸泡测试协议（30m~4h）
- 回归套件 — 映射测试覆盖到 GDD 关键路径
- 测试搭建 — 测试框架 + CI/CD 管线搭建
- 测试辅助库 — 引擎特定测试辅助库生成
- 测试证据审查 — 测试文件和手动证据质量审查
- 测试不稳定性检测 — CI 运行日志中非确定性测试
- Bug 分类 — 所有开放 Bug 严重性/优先级分类

### 安全与审计
- 安全审计 — 6 类安全漏洞审计（存档/网络/输入/数据/作弊/依赖）
- 平衡检查 — 游戏平衡和数值分析
- 试玩报告 — 结构化试玩报告
- 资源审计 — 资产管线合规检查

### 团队编排（9 个）
- 战斗团队 / 叙事团队 / UI 团队 / 发布团队
- 打磨团队 / 音频团队 / 关卡团队
- QA 团队 / 运营团队（发布后实时运营）

### 发布与运营
- 发布检查清单 / 上线检查清单 / 变更日志
- 补丁说明 / 热修复 / 首发日补丁 / 本地化

### UX 与界面设计
- UX 设计 — 三种模式（Screen/Flow、HUD、交互模式库）
- UX 审查 — 规格完整性、无障碍合规、GDD 对齐审查

### 元技能
- 技能验证 — 4 种模式（静态/规格/类别/审计）
- 技能改进 — test → fix → retest 改进循环

## 使用方式

### 在 Trae 中激活 Skill

1. 直接调用 Skill（如果已配置）：
   ```
   /game-studio
   ```

2. 或者直接说：
   ```
   "我想开发一个平台跳跃游戏，帮我开始"
   ```

### 触发工作流

用自然语言描述你的需求：

| 想做什么 | 怎么说 |
|---------|--------|
| 构思游戏概念 | "帮我头脑风暴一个 Roguelike 概念" |
| 设计战斗系统 | "帮我设计战斗系统" |
| 创建冲刺计划 | "创建新的冲刺计划" |
| 审查代码 | "审查 src/gameplay/ 下的代码" |
| 检查性能 | "分析战斗系统的性能" |
| 准备发布 | "检查 v1.0 发布就绪状态" |

### 核心工作模式

1. **AI 先提问** — 在提出方案前澄清需求
2. **展示选项** — 提供 2-4 个方案及分析
3. **你来做决定** — 使用结构化选择界面
4. **AI 起草** — 逐节展示草稿
5. **你批准** — 写入文件前明确确认

## 与原始 Claude Code 方案的差异

原版基于 Claude Code CLI 的能力（子代理并行、事件钩子、斜杠命令、路径规则自动匹配等），本 Trae 版做了以下适配：

| 维度 | Claude Code 原方案 | Trae 方案 |
|------|--------------------|-----------|
| 角色调用 | Task 独立子代理（可指定模型） | 主上下文内角色扮演 |
| 工作流触发 | 斜杠命令（如 `/brainstorm`） | 自然语言意图识别 |
| 并行执行 | ✓ 支持多子代理并行 | ✗ 顺序阶段执行 |
| 自动钩子 | 事件驱动自动触发（Bash） | 手动 PowerShell 脚本 + 提示词内提醒 |
| 规则匹配 | 路径模式自动注入 | 提示词内主动声明遵循 |
| 配置加载 | CLAUDE.md + settings.json 自动加载 | Skill 工具手动加载 + .trae/rules 配置 |
| 入口方式 | 会话启动自动注入 | 用户调用 Skill 或自然语言触发 |

详见 [MIGRATION_PLAN.md](MIGRATION_PLAN.md) 了解完整改造方案。

## 文件结构

```
game-studio/
├── SKILL.md                # ★ 主 Skill 入口（490 行，12 个路由类别）
├── skill-system.md         # 系统架构与协作原则
├── README.md               # 本文档
├── MIGRATION_PLAN.md       # Claude Code → Trae 全量改造方案（含 5 阶段更新记录）
│
├── agents/                 # 49 个角色定义
├── skills/                 # 73 个工作流
├── rules/                  # 11 个编码规范
├── templates/              # 40 个文档模板（GDD/ADR/UX/HUD/经济/无障碍等）
├── hooks/                  # 9 个 PowerShell 脚本（会话管理/验证/通知）
├── docs/                   # 核心文档和引擎参考
│   ├── engine-reference/   # Godot/Unity/Unreal 版本锁定参考
│   ├── testing-framework/  # 73 技能 + 49 代理行为测试规格
│   ├── WORKFLOW-GUIDE.md   # 完整 7 阶段工作流指南（1700+ 行）
│   ├── director-gates.md   # 标准化总监门禁系统
│   ├── workflow-catalog.yaml # 7 阶段管线目录
│   └── ...
├── examples/               # 工作流示例
├── production/             # 会话状态
├── reviews/                # Phase 9-11 审查报告
└── CONTRIBUTING.md / SECURITY.md / UPGRADING.md / .gitignore
```

## 致谢

本 Skill 基于 [pixel-cellar/Claude-Code-Game-Studios](https://github.com/pixel-cellar/Claude-Code-Game-Studios) 以及 [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) 项目改造。原始项目采用 MIT 许可证，本项目同样遵循 MIT 许可证。

## 许可证

MIT 许可证。详见 [LICENSE](LICENSE)。
