# Team QA — QA团队编排

编排 QA 团队完成完整测试周期：协调 qa-lead（策略+测试计划）和 qa-tester（测试用例编写+Bug报告）为冲刺或功能生成完整 QA 包。

---

## 触发条件

- 用户说"QA团队" / "team qa" / "运行QA" / "执行测试"

---

## 团队组成

- **qa-lead** — QA 策略、测试计划生成、Story 分类、签收报告
- **qa-tester** — 测试用例编写、Bug 报告编写、手动 QA 文档

---

## 管线

### 阶段1: 加载上下文

从参数检测当前冲刺或功能范围。Read `production/sprint-status.yaml`、`production/stage.txt`。报告范围内 Story 数量。

### 阶段2: QA 策略 (qa-lead)

扮演 **qa-lead** 角色（Read `agents/qa-lead.md`）：审查 Story 并生成 QA 策略。包含：
- 每个 Story 分类为 Logic / Integration / Visual/Feel / UI / Config/Data
- 哪些需自动化 vs. 手动测试
- 测试工作量估算
- 冒险烟状态检查

使用 AskUserQuestion 审查策略。如果冒险烟 FAIL，停止循环。

### 阶段3: 测试计划生成

基于策略生成结构化测试计划文档。写入 `production/qa/qa-plan-[sprint]-[date].md`。

### 阶段4: 测试用例编写 (qa-tester)

对每个手动 QA 的 Story，扮演 **qa-tester** 角色（Read `agents/qa-tester.md`）编写包含前置条件、步骤、预期结果、实际结果、通过/失败字段的测试用例。

### 阶段5: 手动 QA 执行

使用 AskUserQuestion 批量验证 Story 组。对每个 FAIL 结果，扮演 qa-tester 编写 Bug 报告到 `production/qa/bugs/BUG-[NNN]-[slug].md`。

### 阶段6: QA 签收报告

扮演 qa-lead 生成签收报告：测试覆盖摘要表 + 发现的 Bug + 裁决 APPROVED / APPROVED WITH CONDITIONS / NOT APPROVED。

裁决规则基于 S1/S2 的 Bug 是否存在。

---

## 协作协议

- 每个阶段转换处使用 AskUserQuestion
- 先展示完整分析，再用简洁标签捕获决策
- 绝不跳过阻塞的冒烟烟
- 如果代理人返回 BLOCKED → 立即暴露

Verdict: **COMPLETE** / **BLOCKED** — QA 周期完成。
