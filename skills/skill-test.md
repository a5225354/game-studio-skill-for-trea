# Skill Test — 技能验证

验证 `skills/*.md` 文件的结构合规性和行为正确性。四种模式。

---

## 触发条件

- 用户说"技能测试" / "skill test" / "验证技能" / "技能检查"

---

## 阶段1: 解析参数

- `static [name|all]` — 运行7项结构检查
- `spec [name]` — 读取技能+测试规格，评估断言
- `category [name|all]` — 运行类别特定评分标准
- `audit` — 覆盖率报告

---

## 阶段2A: Static 模式 — 7项结构检查

对每个技能运行以下检查：

- **Check 1** — 头部字段完整性 (name/description/argument-hint等)
- **Check 2** — 多阶段结构 (≥2个阶段标题)
- **Check 3** — 裁决关键词 (PASS/FAIL/CONCERNS/APPROVED/BLOCKED/COMPLETE等)
- **Check 4** — 协作协议语言 ("May I write"或写入前批准措辞)
- **Check 5** — 下一步交接 (后续技能引用或"下一步"章节)
- **Check 6** — Fork上下文复杂度
- **Check 7** — 参数提示合理性

输出格式: 单技能详细结果 / all模式汇总表。

---

## 阶段2B: Spec 模式 — 行为验证

从测试规格读取断言，评估技能指令在被遵循时是否能满足每个断言。

标记每个断言：PASS / PARTIAL / FAIL。生成包含Protocol Compliance检查的报告。

---

## 阶段2C: Category 模式 — 评分标准评估

查找技能类别，读取评分标准，评估每个指标的PASS/FAIL/WARN。

---

## 阶段2D: Audit 模式 — 覆盖率报告

列举所有技能和代理，展示覆盖率统计和优先级缺口。

---

## 阶段3: 推荐下一步

根据完成的模式类型提供上下文后续建议。

---

## 协作协议

- 只读模式(audit/report)不写入文件
- Spec/Category/Static模式仅在用户批准时写入结果
