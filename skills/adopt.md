# Adopt — 棕地项目模板采纳

本技能审计现有项目的产物是否与模板的技能管线格式兼容，然后生成优先级排序的迁移计划。

**这不是 project-stage-detect。** project-stage-detect 回答：*存在什么？* adopt 回答：*已有的东西能否与模板技能配合工作？*

**输出:** `docs/adoption-plan-[date].md`

---

## 触发条件

- 用户说"棕地迁移" / "adopt" / "格式审计" / "模板采纳"

**审计模式:**
- 无参数 / `full` — 完整审计
- `gdds` — 仅 GDD 格式合规性
- `adrs` — 仅 ADR 格式合规性
- `stories` — 仅 Story 格式合规性
- `infra` — 仅基础设施产物缺口

---

## 阶段1: 检测项目状态

发出"正在扫描项目产物..."然后静默读取。

存在性检查：`production/stage.txt`、GDD/ADR/Story 计数、引擎配置、引擎参考文档。

---

## 阶段2: 格式审计

### 2a: GDD 格式审计
对每个 GDD 检查8个必填章节（概览、玩家幻想、详细规则、公式、边界情况、依赖、调优旋钮、验收标准）和状态字段。

### 2b: ADR 格式审计
检查 Status、ADR Dependencies、Engine Compatibility、GDD Requirements Addressed、Performance Implications 章节。

### 2c: systems-index.md 格式审计
检查括号状态值（会破坏其他技能）、有效状态值列表、列结构。

### 2d: Story 格式审计
检查 Manifest Version、TR-ID、ADR 引用、Status、Acceptance Criteria。

### 2e: 基础设施审计
TR 注册表、控制清单、冲刺状态、阶段文件、引擎参考。

### 2f: 技术偏好审计
检查 `docs/technical-preferences.md` 中未配置字段。

---

## 阶段3: 分类和优先级排序

- **BLOCKING** — 模板技能会静默产生错误结果
- **HIGH** — Story 生成会缺少安全检查
- **MEDIUM** — 降低质量和管线跟踪
- **LOW** — 非紧急改进

---

## 阶段4: 构建迁移计划

按 BLOCKING → HIGH → MEDIUM → LOW 顺序编写编号行动计划。每个缺口包含问题陈述、修复命令/步骤、时间估算、复选框。

---

## 阶段5: 呈现摘要并询问写入

呈现审计摘要和缺口预览。询问：写入 `docs/adoption-plan-[date].md`。

---

## 阶段6: 写入采纳计划

如批准，写入结构化迁移计划文件。

---

## 阶段6b: 设置审查模式

如 `production/review-mode.txt` 不存在，询问审查强度偏好。

---

## 阶段7: 提供优先操作

选择最高优先级缺口并提供立即处理的选项。

---

## 协作协议

1. 静默读取 — 完整审计后再呈现
2. 先展示摘要 — 让用户在写入前看到范围
3. 写入前询问 — 始终确认再创建
4. 提供而非强制 — 计划是建议性的
5. 一次一个行动 — 提供具体下一步而非列表
6. 绝不重新生成已有产物 — 仅填补缺口
