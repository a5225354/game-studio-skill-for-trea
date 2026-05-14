# Dev Story — Story实现

本技能是计划和代码之间的桥梁。读取 Story 文件的全部内容，组装程序员需要的所有上下文，路由到正确的专家角色，并驱动实现到完成 — 包括编写测试。

**每个 Story 的循环:**
```
qa-plan sprint          ← 冲刺开始前定义测试需求
story-readiness [路径]   ← 开始前验证
dev-story [路径]         ← 实现 (本技能)
code-review [文件]      ← 审查
story-done [路径]        ← 验证并关闭
```

**输出:** `src/` 和 `tests/` 目录下的源代码 + 测试文件。

---

## 触发条件

- 用户说"实现Story" / "开发Story" / "dev story" / "开始实现"

---

## 阶段1: 找到Story

**如果提供了路径**: 直接读取该文件。

**如果无参数**: 检查 `production/session-state/active.md` 获取活跃Story。如找到，确认："继续处理 [Story标题] — 对吗？" 如未找到，Glob `production/epics/**/*.md` 并列出状态为 Ready 的 Story。

---

## 阶段2: 加载完整上下文

**在加载任何上下文之前**，验证必需文件是否存在。提取 Story 的 ADR 路径后检查：

| 文件 | 如缺失 |
|------|--------|
| TR 注册表 (`docs/architecture/tr-registry.yaml`) | **STOP** |
| 治理 ADR | **STOP** |
| 控制清单 (`docs/architecture/control-manifest.md`) | **WARN** 并继续 |

同时读取：
- Story 文件完整内容（提取所有字段）
- TR 注册表中对应 TR-ID 的需求（源真相，不是 Story 中的内联文本）
- 治理 ADR（Decision 和 Implementation Guidelines 章节）
- 控制清单（该 Story 所属层的规则）
- 引擎偏好（`docs/technical-preferences.md`）

**检查清单版本**: 如果 Story 的内嵌 Manifest Version 与当前清单头日期不一致，使用 AskUserQuestion 处理。

**依赖验证**: 验证 Story 的所有依赖是否状态为 Complete/Done。

---

## 阶段3: 路由到正确的程序员

根据 Story 的 **Layer**、**Type** 和 **系统名**，确定应扮演哪个专家角色：

| Story 上下文 | 主要角色 |
|-------------|---------|
| Foundation 层 — 任何类型 | engine-programmer |
| 任何层 — Type: UI | ui-programmer |
| 任何层 — Type: Visual/Feel | gameplay-programmer |
| Core 或 Feature — 游戏机制 | gameplay-programmer |
| Core 或 Feature — AI 行为 | ai-programmer |
| Core 或 Feature — 网络/复制 | network-programmer |
| Config/Data — 无代码 | 无代理（直接数据文件编辑） |

**引擎专家 — 可随同激活**：如 Story 涉及引擎特定 API，读取对应引擎专家角色指令。

---

## 阶段4: 实现

扮演选择的程序员角色，提供完整上下文包：

简要指导该角色读取指定文件路径（Story、GDD 需求、ADR、控制清单、引擎偏好、测试文件路径）。角色需：
- 在 `src/` 中创建或修改文件
- 遵守控制清单的所有 Required 和 Forbidden 模式
- 保持在 Out of Scope 边界内
- 编写干净、有文档注释的公开 API

**Config/Data Stories**: 无需扮演程序员角色。直接编辑数据文件。

**Visual/Feel Stories**: 标记为 DEFERRED — "手感"检查在 story-done 中手动确认。

---

## 阶段5: 测试证据需求

| Story 类型 | 必需证据 |
|-----------|---------|
| **Logic** | 自动化单元测试 — BLOCKING |
| **Integration** | 集成测试或试玩记录 — BLOCKING |
| **Visual/Feel** | 证据文档 — ADVISORY |
| **UI** | 手动走查文档 — ADVISORY |
| **Config/Data** | 冒烟检查通过 |

---

## 阶段6: 收集和总结

呈现实现摘要：

```
## 实现完成: [Story 标题]

**修改的文件**: [路径 + 简要描述]

**验收标准覆盖**: [X/Y]
- [x] [标准] — 实现在 [file:function]
- [x] [标准] — 被测试覆盖 [test_name]
- [ ] [标准] — DEFERRED: 需试玩 (Visual/Feel)

**范围偏差**: [None] 或 [列表]
**引擎风险标记**: [None] 或 [发现]
**阻塞**: [None] 或 [描述]

就绪: code-review 然后 story-done [Story路径]
```

---

## 阶段7: 更新会话状态

追加到 `production/session-state/active.md`。

---

## 错误恢复协议

如实现过程中遇到阻塞，使用 AskUserQuestion 提供选项：跳过此代理、缩小范围重试、停止并先解决阻塞。

---

## 协作协议

- **文件写入是代理的职责** — 所有代码由扮演的程序员角色执行"我可以写入[路径]吗？"
- **加载后再实现** — 所有上下文加载完毕前不开始编码
- **ADR 是法律** — 实现必须遵循 ADR 的 Implementation Guidelines
- **保持在范围内** — Out of Scope 是契约
- **Logic/Integration 的测试不可选** — 测试文件不存在时不标记实现完成

Verdict: **COMPLETE** — 实现完成。就绪 code-review → story-done。
