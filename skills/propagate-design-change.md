# Propagate Design Change — 设计变更传播

当 GDD 变更时，基于它编写的架构决策可能不再有效。本技能找到每个受影响的 ADR，比较 ADR 假设与 GDD 当前的内容，并引导用户完成解决。

---

## 触发条件

- 用户说"传播设计变更" / "propagate design change" / "GDD变了影响哪些ADR"

---

## 1. 验证参数

需要 GDD 路径参数。如果缺失或文件不存在，停止并报错。

---

## 2. 读取变更的 GDD

Read 当前 GDD 完整内容。

---

## 3. 读取之前版本

运行 `git show HEAD:design/gdd/[filename].md` 获取 git 中上一版本。进行概念性差异对比：识别变更和未变更的章节。生成变更摘要。

---

## 4. 加载架构输入

Read `docs/architecture/` 中所有 ADR，提取每个 ADR 的 GDD Requirements Addressed 表。

---

## 5. 影响分析

对每个引用变更 GDD 的 ADR，比较其假设与当前 GDD。分类为：✅ Still Valid / ⚠️ Needs Review / 🔴 Likely Superseded。

---

## 6. 呈现影响报告

```
## Design Change Impact Report
GDD: [filename]
Changes detected: [N sections changed]
ADRs referencing this GDD: [M]
### Not Affected / Needs Review / Likely Superseded
```

---

## 6b. 技术影响审查（可选）

如使用 full 模式，可扮演 technical-director 角色审查影响分类。

---

## 7. 解决工作流

对每个标记为"Needs Review"或"Likely Superseded"的 ADR，询问用户操作：标记 Superseded / 原地更新 / 保持现状 / 稍后处理。

---

## 8. 更新可追溯索引

如 `docs/architecture/architecture-traceability.md` 存在，添加变更需求到"Superseded Requirements"表。

---

## 9. 输出变更影响文档

写入 `docs/architecture/change-impact-[date]-[system-slug].md`。

---

## 10. 跟进行动

基于解决决策建议后续行动。Verdict: **COMPLETE** / **BLOCKED**。

---

## 协作协议

1. 静默读取 — 计算完整影响后再呈现
2. 先展示完整报告
3. 按 ADR 单个询问 — 每个受影响 ADR 可能需要不同处理
4. 写入前询问
5. 非破坏性 — 绝不删除 ADR 内容，仅添加"Superseded by"注释
