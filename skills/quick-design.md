# Quick Design — 轻量级设计

本技能是针对不需要完整 GDD 的变更的**轻量级设计路径**。用于约4小时实现以内的变更 — 调优、小调整、对现有系统的小补充。

**输出:** `design/quick-specs/[name]-[date].md`

---

## 触发条件

- 用户说"快速设计" / "quick design" / "小改动" / "快速规格"

---

## 1. 分类变更

- **Tuning** — 在现有系统中更改数值，无行为变更
- **Tweak** — 对现有系统的小行为变更，不引入新状态
- **Addition** — 对现有系统添加小机制，可能引入1-2个新状态
- **New Small System** — 独立小功能，约一周以内实现

如果变更不适合这些类别 → 重定向到 design-system。

如无参数，使用 AskUserQuestion 推断分类。

---

## 2. 上下文扫描

搜索相关 GDD、systems-index.md、已有 quick-specs、资产数据文件。

---

## 3. 起草 Quick Design Spec

按变更类别使用对应格式：

**Tuning**: 参数变更表 + GDD Tuning Knob 映射

**Tweak/Addition**: 变更摘要 + 动机 + 设计差异 + 新规则/值 + 影响系统表 + 验收标准

**New Small System**: 概览 + 核心规则 + Tuning Knobs + 验收标准 + 系统索引建议

---

## 4. 批准和归档

在对话中展示草稿。使用 AskUserQuestion 询问：批准/修订/重定向到 design-system。

如批准，写入 `design/quick-specs/[kebab-case-title]-[YYYY-MM-DD].md`。

如需要 GDD 更新，另外询问批准。

---

## 5. 交接

Quick Design Specs 设计上**绕过** design-review 和 review-all-gdds。它们适用于小而低风险的变更。

如果变更：添加应进入系统索引的新系统、显著改变跨系统行为、影响游戏 MDA 美学平衡、预计超一周 → 重定向到完整管线。

Verdict: **COMPLETE** — quick design spec 已写入。
