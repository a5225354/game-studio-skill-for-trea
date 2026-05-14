# Team Live-Ops — 实时运营团队编排

编排实时运营团队进行发布后内容规划：协调 live-ops-designer、economy-designer、analytics-engineer、community-manager、writer、narrative-director 设计和规划赛季、事件或实时内容更新。

---

## 触发条件

- 用户说"运营团队" / "team live ops" / "规划赛季" / "设计活动"

---

## 团队组成

- **live-ops-designer** — 赛季结构、事件节奏、保留机制
- **economy-designer** — 实时经济平衡、商店轮换、货币定价
- **analytics-engineer** — 成功指标、A/B测试、事件跟踪
- **community-manager** — 面向玩家沟通和消息
- **narrative-director** — 赛季叙事主题和故事框架
- **writer** — 所有面向玩家文本

---

## 管线

### 阶段1: 赛季/事件范围界定
扮演 **live-ops-designer** 角色：定义赛季类型、持续时间、主题方向、内容清单、保留钩子。

### 阶段2: 叙事主题
扮演 **narrative-director** 角色：设计赛季叙事主题，定义中央故事钩子。

### 阶段3: 经济设计
扮演 **economy-designer** 角色：设计奖励轨道、赛季经济、商店、遗憾计时器。（可与阶段2并行）

### 阶段4: 分析与成功指标
扮演 **analytics-engineer** 角色：定义成功指标、A/B测试、新遥测。（可与阶段3并行）

### 阶段5: 内容写作
顺序扮演 **narrative-director** 和 **writer** 角色：游戏内叙事文本和所有面向玩家文本。

### 阶段6: 玩家沟通计划
扮演 **community-manager** 角色：启动公告、沟通节奏、跨平台消息。

### 阶段7: 审查和签收
收集所有阶段输出，呈现合并赛季计划。

**伦理审查**: 检查经济设计是否违反 `design/live-ops/ethics-policy.md`。如有违反 → BLOCKED，不能发放 COMPLETE 裁决。

---

## 协作协议

- 如果无赛季名称或事件描述参数 → 停止并提示
- 每个阶段转换处使用 AskUserQuestion
- 绝不跳过伦理审查 — 如果 policy 未找到标记警告，如找到违反标记 BLOCKED
- 错误恢复：暴露阻止、评估依赖、提供选项、始终生成部分报告

Verdict: **COMPLETE** / **BLOCKED** — 赛季计划完成。
