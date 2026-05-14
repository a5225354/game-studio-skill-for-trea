# Vertical Slice — 垂直切片门禁

Pre-Production 阶段验证 — 构建生产质量的端到端构建，确认完整游戏循环在投入 Production 之前是可实现的。

它验证:
1. **管线** — 团队能否真正产出这种质量的内容？
2. **实现可行性** — 对于这个游戏，架构决策是否正确？
3. **乐趣存活** — 概念原型的乐趣在全量设计后是否存活？
4. **速度** — 花了多久？这是你真实的生产率估算。

---

## 触发条件

- 用户说"垂直切片" / "vertical slice" / "Pre-Production验证" / "构建完整循环"

---

## 阶段1: 加载上下文

Read 以下文件了解完整设计意图：
- `SKILL.md` / `docs/technical-preferences.md` — 技术栈和引擎
- `design/gdd/game-concept.md` — 核心幻想和游戏支柱
- `design/gdd/systems-index.md` — MVP 系统及优先级
- `docs/architecture/architecture.md` — 分层结构
- `docs/architecture/control-manifest.md` — 实现技术规则
- 被切片的关键系统的 GDD

---

## 阶段2: 定义切片范围和验证问题

在构建之前，定义可证伪的验证问题：

> *"一个玩家，在无开发者指导的情况下，能否在 [N] 分钟内从零开始体验 [核心幻想]，并且我们能否在 [X] 天内以代表性质量构建一个这样的循环？"*

**范围纪律:**
- 必须包含所有核心循环系统（完成一个 [开始→挑战→解决] 循环所需的系统）
- 目标范围：3-5 分钟精心打磨的连续游戏
- **在削减质量之前先削减范围** — 低质量的切片无法验证生产可行性

呈现范围给用户确认后再构建。

---

## 阶段3: 计划构建

定义要点：
- 实现的系统（哪些 GDD 章节被运用）
- 完整的游戏循环周期
- 美术和音频质量级别
- 可衡量成功标准
- 硬性时间限制

确认后写入 `production/session-state/active.md` 会话检查点。

---

## 阶段4: 实现

询问："我可以创建垂直切片目录 `prototypes/[concept-name]-vertical-slice/` 并开始实现吗？"

如果同意，创建目录。每个文件必须以以下注释开头：
```
// VERTICAL SLICE - NOT FOR PRODUCTION
// 验证问题: [本构建在证明什么]
// 日期: [当前日期]
```

**质量标准** — 高于概念原型但非完整生产：
- 遵循架构分层
- 使用命名约定（来自 `docs/technical-preferences.md`）
- 无硬编码游戏数值
- 关键路径上的基本错误处理

**多轮循环**: 迭代直到完整游戏循环可演示。
**第3天沉没成本检查**: 如果完整循环不可演示，停止并重新评估。

进行至少1次试玩会话。

---

## 阶段5: 试玩复盘

询问以下问题（逐一）：
1. 你是否在无指导下完成了完整循环？
2. 到达第一个有意义动作用了多久？
3. 你是否感受到了核心幻想？
4. 什么让你停下、困惑或出戏？
5. 以开发者视角，这质量可延续吗？
6. PROCEED / PIVOT / KILL 裁决和具体原因

---

## 阶段6: 生成垂直切片报告

Read `templates/vertical-slice-report.md` 获取报告结构。包含：
- 执行摘要 (PROCEED/PIVOT/KILL + 理由)
- 核心循环验证
- 手感评估
- 技术发现
- **速度日志**（逐日进度 — 不要跳过）
- 推荐下一步

---

## 阶段7: 总结和下一步

**如果 PROCEED**: 项目准备好进入 Production。推荐运行 create-epics → create-stories → sprint-plan → gate-check pre-production。

**如果 PIVOT**: 记录什么有效和什么失败的 PIVOT-NOTE.md，然后修订 GDD → 修正架构 → 重新运行 vertical-slice。

**如果 KILL**: 记录到 `prototypes/GRAVEYARD.md`，返回 brainstorming 或尝试新方向的原型。

---

## 协作协议

- 垂直切片代码绝不能重构入生产 — 仅作参考
- 生产代码绝不能从 `prototypes/` 导入
- 范围削减可以接受；质量削减不行
- 总投入：1-3 周
- 第3天规则：如果完整循环不可演示，停止并暴露阻塞

Verdict: 以 PROCEED / PIVOT / KILL 结束。
