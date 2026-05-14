# Test Evidence Review — 测试证据审查

对测试文件和手动证据文档进行质量审查。超越存在性检查 — 评估断言覆盖、边界情况处理、命名约定和证据完整性。

**输出:** 摘要报告(对话中) + 可选 `production/qa/evidence-review-[date].md`

---

## 触发条件

- 用户说"测试证据审查" / "test evidence review" / "审查测试质量"

---

## 1. 解析参数

**模式:** `[story-path]`(单Story) / `sprint`(当前冲刺) / `[system-name]`(系统) / 无参数(询问)

---

## 2. 加载范围内 Stories

提取每个 Story 的：Type 字段、Test Evidence 章节、验收标准列表。

---

## 3. 定位证据文件

- Logic → `tests/unit/[system]/[story-slug]_test.*`
- Integration → `tests/integration/[system]/[story-slug]_test.*`
- Visual/Feel/UI → `production/qa/evidence/[story-slug]-evidence.*`
- Config/Data → `production/qa/smoke-*.md`

---

## 4. 审查自动化测试质量

评估：断言覆盖率(每函数≥3断言=正常)、边界情况覆盖、命名质量(pattern: `test_[scenario]_[expected]`)、公式可追溯性。

---

## 5. 审查手动证据质量

评估：标准关联性(是否覆盖每个验收标准)、签收完整性(Developer/Designer/QA)、截图/产物完整性、日期覆盖(是否可能过期)。

---

## 6. 构建审查报告

每个 Story 裁决：ADEQUATE / INCOMPLETE / MISSING。

报告包含每 Story 的自动化测试质量、手动证据质量、阻塞项/建议项、汇总表。

---

## 7. 写入输出(可选)

征求批准后写入。对有阻塞项/薄弱断言/缺失签收的情况提供具体建议。

Verdict: **COMPLETE** / **CONCERNS** — 证据审查完成。

---

## 协作协议

- **报告质量问题，不修复它们** — 读取和评估，不修改测试文件
- **ADEQUATE 意味着足以发布，并非完美**
- **BLOCKING vs ADVISORY 区分重要** — 仅在缺口使验收标准真正未验证时标记 BLOCKING
- **写入前询问** — 报告文件是可选的
