# Content Audit — 内容审计

审计 GDD 规定的各类内容（敌人、关卡、物品等）的数量与实际已实现内容。识别计划了什么 vs. 构建了什么。

---

## 触发条件

- 用户说"内容审计" / "content audit" / "检查缺失内容"

---

## 阶段1: 上下文收集

1. Read `design/gdd/systems-index.md` — 获取完整系统列表
2. 摘要扫描：Grep 所有 GDD 的 `## Summary` 和内容计数关键词
3. 完整读取范围内 GDD — 提取显式内容计数和列表

---

## 阶段2: 实现扫描

对每个内容类型扫描相关目录：场景文件(levels/areas/maps)、角色(NPC/enemies)、物品(items/equipment/loot)、能力(abilities/skills)、对话(dialogue/cutscenes)、任务(quests/missions)。

---

## 阶段3: 缺口报告

生成缺口表：系统 × 内容类型 × 规定数量 × 找到数量 × 缺口 × 状态。

状态：COMPLETE / IN PROGRESS / EARLY / NOT STARTED

如系统标记为 MVP/Vertical Slice 且状态为 EARLY/NOT STARTED → HIGH PRIORITY。

---

## 阶段4: 输出

呈现缺口表。询问写入 `docs/content-audit-[YYYY-MM-DD].md`。

Verdict: **COMPLETE** — 内容审计完成。
