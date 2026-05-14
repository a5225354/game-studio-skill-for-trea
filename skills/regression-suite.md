# Regression Suite — 回归测试套件

确保每个 Bug 修复都有本可捕获原始 Bug 的测试支持 — 且回归套件随游戏演进保持最新。维护 `tests/regression-suite.md`。

---

## 触发条件

- 用户说"回归测试" / "regression suite" / "更新回归覆盖"

---

## 1. 解析参数

**模式:** `update`(扫描新Bug修复) / `audit`(全量GDD关键路径审计) / `report`(只读状态) / 无参数(推断)

---

## 2. 加载上下文

- 2a: 已有回归套件 `tests/regression-suite.md`
- 2b: 测试文件清单（Glob 所有测试文件）
- 2c: GDD 关键路径（仅 audit 模式）
- 2d: 关闭的 Bug 列表

---

## 3. 映射覆盖 — 关键路径

对每个 GDD 验收标准分配：COVERED / PARTIAL / MISSING / EXEMPT。

---

## 4. 映射覆盖 — 已修复 Bug

对每个关闭的 Bug，检查是否存在回归测试。标记 HAS REGRESSION TEST / MISSING REGRESSION TEST。

---

## 5. 检测覆盖漂移

检查：冲刺完成 Story 对应缺失的测试文件、systems-index 新增系统、回归套件老化。

---

## 6. 生成报告和套件清单

报告：关键路径覆盖、Bug回归覆盖、覆盖漂移指标、推荐新回归测试。

清单格式：注册的回归测试 + 已知缺口 + 隔离测试。

---

## 7. 写入输出

**绝不删除已有回归测试** — 仅追加。Verdict: **COMPLETE** / **BLOCKED**。

---

## 协作协议

- 绝不未经批准删除清单中的回归测试
- 缺口是建议性的 — 不阻塞
- 隔离不是删除
- 写入前询问
