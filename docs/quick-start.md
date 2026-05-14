# Game Studio Skill — 快速入门指南

## 这是什么

这是一个面向游戏开发的完整 AI 协作框架（Trae Skill）。它将 49 个专业 AI 角色
组织成模拟真实游戏开发团队的工作室层级结构，每个角色有明确的职责、委派规则和
协作协议。包含 Godot、Unity、Unreal 三大引擎的专家角色，每个引擎都有覆盖主要
子系统的专属专家。所有设计代理和模板都基于成熟的游戏设计理论（MDA 框架、
自我决定理论、心流状态、Bartle 玩家类型）。选择与你项目匹配的引擎角色即可。

## 如何使用

### 1. 理解层级结构

角色分为三层：

- **第 1 层：总监** — 做出高层决策
  - `creative-director` — 愿景和创意冲突解决
  - `technical-director` — 架构和技术决策
  - `producer` — 排期、协调和风险管理

- **第 2 层：部门负责人** — 主管各自领域
  - `game-designer`、`lead-programmer`、`art-director`、`audio-director`、
    `narrative-director`、`qa-lead`、`release-manager`、`localization-lead`

- **第 3 层：专家** — 在各自领域内执行具体工作
  - 设计师、程序员、美术师、编剧、测试员、工程师

### 2. 为任务选择合适的角色

问自己："在真实的工作室里，这个任务应该由哪个部门处理？"

| 我需要…… | 使用这个角色 |
|----------|------------|
| 设计一个新机制 | `game-designer` |
| 编写战斗代码 | `gameplay-programmer` |
| 创建着色器 | `technical-artist` |
| 写对话 | `writer` |
| 规划下一个冲刺 | `producer` |
| 审查代码质量 | `lead-programmer` |
| 编写测试用例 | `qa-tester` |
| 设计关卡 | `level-designer` |
| 修复性能问题 | `performance-analyst` |
| 搭建 CI/CD | `devops-engineer` |
| 设计掉落表 | `economy-designer` |
| 解决创意冲突 | `creative-director` |
| 做架构决策 | `technical-director` |
| 管理发布 | `release-manager` |
| 准备翻译字符串 | `localization-lead` |
| 快速测试机制创意 | `prototyper` |
| 审查代码安全 | `security-engineer` |
| 检查无障碍合规 | `accessibility-specialist` |
| 获取 Unreal Engine 建议 | `unreal-specialist` |
| 获取 Unity 建议 | `unity-specialist` |
| 获取 Godot 建议 | `godot-specialist` |
| 设计 GAS 能力/效果 | `ue-gas-specialist` |
| 定义 BP/C++ 边界 | `ue-blueprint-specialist` |
| 实现 UE 复制 | `ue-replication-specialist` |
| 构建 UMG/CommonUI 控件 | `ue-umg-specialist` |
| 设计 DOTS/ECS 架构 | `unity-dots-specialist` |
| 编写 Unity 着色器/VFX | `unity-shader-specialist` |
| 管理 Addressable 资产 | `unity-addressables-specialist` |
| 构建 UI Toolkit/UGUI 界面 | `unity-ui-specialist` |
| 编写地道的 GDScript | `godot-gdscript-specialist` |
| 编写 Godot C# 代码 | `godot-csharp-specialist` |
| 创建 Godot 着色器 | `godot-shader-specialist` |
| 构建 GDExtension 模块 | `godot-gdextension-specialist` |
| 规划实时活动和赛季 | `live-ops-designer` |
| 写面向玩家的补丁说明 | `community-manager` |
| 头脑风暴新游戏创意 | 说"帮我头脑风暴一个游戏概念" |

### 3. 使用自然语言触发工作流

在 Trae 中，通过自然语言描述你的需求即可触发相应的工作流：

| 想做什么 | 怎么说 |
|---------|--------|
| 入门引导 | "我开始一个新游戏项目" |
| 上下文导航 | "我应该做什么下一步？" |
| 项目阶段检测 | "分析我的项目当前状态" |
| 配置引擎 | "帮我配置 Godot 4.5 引擎" |
| 棕地迁移 | "帮我审计现有项目并生成迁移计划" |
| 头脑风暴 | "帮我头脑风暴一个 Roguelike 概念" |
| 系统映射 | "帮我分解游戏概念为子系统" |
| 系统设计 | "帮我设计战斗系统" |
| 轻量设计 | "帮我快速设计一个小调整" |
| 跨 GDD 审查 | "帮我审查所有 GDD 的一致性" |
| 设计变更传播 | "这个 GDD 改了，找受影响的 ADR" |
| 美术圣经 | "帮我创建美术风格规范" |
| 资产规格 | "从 GDD 生成这个资产的视觉规格" |
| UX 设计 | "帮我设计主菜单的 UX" |
| UX 审查 | "审查 HUD 的无障碍合规性" |
| 创建架构 | "帮我创建项目架构文档" |
| 架构决策 | "帮我创建架构决策记录" |
| 架构审查 | "审查所有 ADR 的依赖关系" |
| 控制清单 | "从 ADR 生成程序员规则清单" |
| 创建 Epic | "从 GDD 创建 Epic" |
| 创建 Story | "把这个 Epic 分解为 Story" |
| 实现 Story | "帮我实现这个 Story" |
| 冲刺规划 | "创建新的冲刺计划" |
| 冲刺快照 | "查看当前冲刺状态" |
| Story 就绪检查 | "这个 Story 可以开始实现了吗？" |
| Story 完成审查 | "审查这个 Story 的完成情况" |
| 工作量估算 | "估算这个功能的工作量" |
| 设计评审 | "审查这个设计文档" |
| 代码审查 | "审查 src/gameplay/ 下的代码" |
| 平衡检查 | "分析游戏数值平衡" |
| 资源审计 | "审计资产管线合规性" |
| 内容审计 | "检查 GDD 规定内容是否已实现" |
| 范围检查 | "检查是否出现范围蔓延" |
| 性能分析 | "分析战斗系统的性能瓶颈" |
| 技术债务 | "扫描并分类技术债务" |
| 门禁检查 | "检查 Pre-Production 阶段就绪状态" |
| 一致性检查 | "扫描所有 GDD 的跨文档不一致" |
| 安全审计 | "审计项目安全漏洞" |
| 反向文档 | "从已有代码生成设计文档" |
| 里程碑评审 | "评审里程碑进度" |
| 回顾 | "进行冲刺回顾" |
| Bug 报告 | "创建结构化 Bug 报告" |
| 试玩报告 | "分析试玩反馈" |
| 入职引导 | "生成新成员入职文档" |
| 发布检查清单 | "验证 v1.0 发布就绪状态" |
| 上线检查清单 | "完整上线就绪验证" |
| 变更日志 | "从 git 历史生成变更日志" |
| 补丁说明 | "生成玩家可读的补丁说明" |
| 热修复 | "带审计追踪的紧急修复" |
| 首发日补丁 | "准备首发日补丁" |
| 原型验证 | "快速搭建原型验证核心机制" |
| 垂直切片 | "端到端生产质量构建验证" |
| 本地化 | "扫描并提取需要翻译的内容" |
| 战斗团队 | "用战斗团队开发新能力" |
| 叙事团队 | "用叙事团队开发剧情" |
| UI 团队 | "用 UI 团队开发界面" |
| 发布团队 | "用发布团队协调发布" |
| 打磨团队 | "用打磨团队进行全面打磨" |
| 音频团队 | "用音频团队开发音频" |
| 关卡团队 | "用关卡团队创建关卡" |
| 运营团队 | "用运营团队规划赛季内容" |
| QA 团队 | "用 QA 团队进行完整测试周期" |
| QA 计划 | "为冲刺生成 QA 测试计划" |
| Bug 分类 | "重新分类所有开放 Bug" |
| 冒烟测试 | "运行关键路径冒烟测试" |
| 浸泡测试 | "生成浸泡测试协议" |
| 回归套件 | "映射测试覆盖到 GDD 关键路径" |
| 测试搭建 | "搭建测试框架和 CI 管线" |
| 测试辅助库 | "生成引擎特定测试辅助库" |
| 测试不稳定性 | "从 CI 日志检测不稳定测试" |
| 测试证据审查 | "审查测试文件质量" |
| 技能验证 | "验证技能文件合规性" |
| 技能改进 | "用 test-fix-retest 循环改进技能" |

### 4. 使用文档模板

模板位于 `templates/` 目录中：

- `game-design-document.md` — 新机制和系统的 GDD
- `architecture-decision-record.md` — 技术决策的 ADR
- `architecture-traceability.md` — GDD 需求到 ADR 到 Story ID 的追溯
- `risk-register-entry.md` — 新风险登记
- `narrative-character-sheet.md` — 新角色设定
- `test-plan.md` — 功能测试计划
- `sprint-plan.md` — 冲刺规划
- `milestone-definition.md` — 新里程碑
- `level-design-document.md` — 新关卡设计
- `game-pillars.md` — 核心设计支柱
- `art-bible.md` — 视觉风格参考
- `technical-design-document.md` — 每个系统的技术设计
- `post-mortem.md` — 项目/里程碑回顾
- `sound-bible.md` — 音频风格参考
- `release-checklist-template.md` — 平台发布检查清单
- `changelog-template.md` — 面向玩家的变更日志
- `release-notes.md` — 面向玩家的发布说明
- `incident-response.md` — 线上事件响应预案
- `game-concept.md` — 初始游戏概念（MDA、SDT、Flow、Bartle）
- `pitch-document.md` — 向利益相关者展示游戏的文档
- `economy-model.md` — 虚拟经济设计（产出/消耗模型）
- `faction-design.md` — 阵营设定
- `systems-index.md` — 系统分解与依赖映射
- `project-stage-report.md` — 项目阶段检测输出
- `design-doc-from-implementation.md` — 从代码反向生成 GDD
- `architecture-doc-from-code.md` — 从代码反向生成架构文档
- `concept-doc-from-prototype.md` — 从原型反向生成概念文档
- `ux-spec.md` — 逐屏 UX 规格
- `hud-design.md` — 全游戏 HUD 设计
- `accessibility-requirements.md` — 项目级无障碍需求
- `interaction-pattern-library.md` — 交互模式库
- `player-journey.md` — 玩家旅程映射
- `difficulty-curve.md` — 难度曲线设计
- `test-evidence.md` — 手动测试证据记录
- `prototype-report.md` — 原型验证报告
- `vertical-slice-report.md` — 垂直切片报告
- `skill-test-spec.md` — 技能测试规格

协作协议模板位于 `templates/collaborative-protocols/`（由代理使用，通常不直接编辑）：

- `design-agent-protocol.md` — 设计代理的"提问-选项-草稿-批准"循环
- `implementation-agent-protocol.md` — 编程代理的 Story 实现流程
- `leadership-agent-protocol.md` — 总监级代理的跨部门委派与升级

### 5. 遵循协调规则

1. 工作沿层级向下流动：总监 → 部门负责人 → 专家
2. 冲突沿层级向上升级
3. 跨部门工作由 `producer` 协调
4. 代理不得在未经授权的情况下修改其领域之外的文件
5. 所有决策必须记录

## 新项目的第一步

**不知道从哪里开始？** 告诉 AI "我开始一个新游戏项目，没有想法"。
它会问你当前状态，然后引导你到正确的工作流。

如果你已经知道需要什么，可以直接跳到对应的路径：

### 路径 A："我不知道要做什么"

1. **运行入门引导** — 告诉 AI "我开始一个新游戏项目，没有想法"：
   - 什么让你兴奋、你玩过什么、你的限制条件
   - 生成 3 个概念，帮你选一个，定义核心循环和支柱
   - 产出游戏概念文档并推荐引擎
2. **配置引擎** — 告诉 AI "帮我配置 [引擎名] [版本]"（使用头脑风暴的推荐）
   - 配置技术偏好（命名规范、性能预算、引擎特定默认值）
   - 如果引擎版本比 AI 训练数据更新，它可以通过网络获取最新文档
3. **验证概念** — "审查设计文档 design/gdd/game-concept.md"
4. **分解为系统** — "帮我分解游戏概念为子系统"
5. **设计每个系统** — "帮我设计 [系统名] 系统" 按依赖顺序编写 GDD
6. **原型验证** — "帮我快速搭建 [核心机制] 的原型"（1-3 天 — 在写 GDD 之前）
7. **设计每个系统** — 根据原型发现来写 GDD
8. **规划第一个冲刺** — 在架构和垂直切片之后，"创建新的冲刺计划"
9. 开始构建

### 路径 B："我知道要做什么"

如果你已经有游戏概念和引擎选择：

1. **配置引擎** — "帮我配置 [引擎] [版本]"（例如 "帮我配置 Godot 4.5"）
2. **编写游戏支柱** — "让创意总监帮我定义游戏支柱"
3. **分解为系统** — "帮我分解游戏概念为子系统"
4. **设计每个系统** — "帮我设计 [系统名] 系统" 按依赖顺序编写 GDD
5. **创建初始 ADR** — "帮我创建架构决策记录"
6. **创建第一个里程碑** — 在 `production/milestones/` 中
7. **规划第一个冲刺** — "创建新的冲刺计划"
8. 开始构建

### 路径 C："我知道游戏但不知道引擎"

如果你有概念但不知道哪个引擎合适：

1. **配置引擎**（不带参数）— "帮我选择游戏引擎"：
   AI 会问你的游戏需求（2D/3D、平台、团队规模、语言偏好）并推荐引擎
2. 从路径 B 的第 2 步继续

### 路径 D："我已有项目"

如果你已经有设计文档、原型或代码：

1. **运行入门引导或项目阶段检测** — "分析我的项目当前状态"：
   分析已有内容，识别缺失项，推荐下一步
2. **运行棕地迁移** — "帮我审计现有项目并生成迁移计划"：
   审计格式合规性，生成编号的迁移计划来填补空白（不覆盖你的已有工作）
3. **配置引擎（如需要）** — "帮我配置 [引擎]"
4. **验证阶段就绪** — "检查当前阶段门禁"
5. **规划下一个冲刺** — "创建新的冲刺计划"

## 文件结构参考

```
game-studio/
├── SKILL.md                # ★ 主 Skill 入口
├── skill-system.md         # 系统架构与协作原则
├── README.md               # 使用说明
├── MIGRATION_PLAN.md       # 改造方案
│
├── agents/                 # 49 个角色定义
├── skills/                 # 73 个工作流
├── rules/                  # 11 个编码规范
├── templates/              # 40 个文档模板
├── hooks/                  # 9 个 PowerShell 钩子脚本
├── docs/                   # 核心文档和引擎参考
│   ├── quick-start.md      # 本文档
│   ├── technical-preferences.md  # 项目特定标准
│   ├── coding-standards.md       # 编码和设计文档标准
│   ├── coordination-rules.md     # 代理协调规则
│   ├── context-management.md     # 上下文管理
│   ├── directory-structure.md    # 项目目录布局
│   ├── workflow-catalog.yaml     # 7 阶段管线定义
│   ├── setup-requirements.md     # 环境要求
│   ├── settings-local-template.md # 本地设置模板
│   ├── engine-reference/         # 引擎参考文档
│   └── templates/                # 40 个文档模板
├── examples/               # 工作流示例
└── production/             # 冲刺计划和里程碑
```
