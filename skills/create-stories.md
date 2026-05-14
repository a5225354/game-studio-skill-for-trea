# Create Stories — Story分解

Story 是一个单一可实现的"行为" — 小到可以在一个专注会话中完成，自包含，完全可追溯到一个 GDD 需求和一个 ADR 决策。Stories 是开发者拿起的单位。Epics 是架构师定义的范围。

**每个 Epic 运行一次此技能**，按 Foundation → Core → Feature → Presentation 顺序。

**输出:** `production/epics/[epic-slug]/story-NNN-[slug].md`

---

## 触发条件

- 用户说"创建Story" / "create stories" / "分解Story" / "编写Story"

---

## 1. 解析参数

- `[epic-slug]` — 例如 `combat`
- `full/path` — 也接受完整路径
- 无参数 — Glob `production/epics/*/EPIC.md` 并列出可用 Epic

---

## 2. 加载该 Epic 的所有内容

Read 完整读取：
- `production/epics/[epic-slug]/EPIC.md` — Epic 概览、治理 ADR、GDD 需求表
- Epic 的 GDD (`design/gdd/[filename].md`)
- Epic 列出的所有治理 ADR
- `docs/architecture/control-manifest.md` — 提取层规则和清单版本日期
- `docs/architecture/tr-registry.yaml` — 加载该系统的所有 TR-ID

**ADR 存在性验证**: 在分解任何 Story 之前确认每个引用的 ADR 文件存在。如任何 ADR 文件未找到，立即停止。

---

## 3. 按类型分类 Stories

| Story 类型 | 分配时机 |
|-----------|---------|
| **Logic** | 验收标准引用公式、数值阈值、状态转换、AI 决策 |
| **Integration** | 两个以上系统交互，跨系统信号 |
| **Visual/Feel** | 动画行为、VFX、"手感"、屏幕震动 |
| **UI** | 菜单、HUD 元素、按钮、对话框 |
| **Config/Data** | 仅平衡调优值 — 无新代码逻辑 |

---

## 4. 分解 GDD 为 Stories

对每个 GDD 验收标准：
1. 分组需要相同核心实现的相关标准
2. 每组 = 一个 Story
3. 排序：基础行为优先，边界情况最后，UI 最后

**Story 大小规则**: 一个 Story = 一个专注会话（~2-4小时）。

对每个 Story 确定：GDD 需求、TR-ID、治理 ADR、Story 类型、引擎风险。

---

## 4b. QA Lead Story 就绪门禁（可选）

如使用 full 审查模式，可扮演 qa-lead 角色检查 Story 验收标准的可测试性。对 Logic/Integration Story 生成具体测试用例规格。

---

## 5. 呈现 Stories 供审查

在写入之前呈现完整 Story 列表，使用 AskUserQuestion 征求批准。

---

## 6. 写入 Story 文件

对每个 Story 写入 `production/epics/[epic-slug]/story-[NNN]-[slug].md`：

```markdown
# Story [NNN]: [标题]

> **Epic**: [Epic 名]
> **Status**: Ready
> **Layer**: [Foundation / Core / Feature / Presentation]
> **Type**: [Logic | Integration | Visual/Feel | UI | Config/Data]
> **Estimate**: [小时或T恤尺寸]
> **Manifest Version**: [control-manifest.md 头部日期]
> **Last Updated**: [由 /dev-story 在实现开始时设置]

## Context
GDD 引用、TR-ID、ADR 治理实现、ADR 决策摘要、引擎信息、控制清单规则

---
## Acceptance Criteria
*来自GDD，限定到此Story范围*
- [ ] [标准1]
- [ ] [标准2]

---
## Implementation Notes
*来自ADR Implementation Guidelines的具体实施指导*

---
## Out of Scope
*由相邻Story处理 — 不在此实现*

---
## QA Test Cases
*由qa-lead在Story创建时编写 — 开发者按这些案例实现*

---
## Test Evidence
**Story Type**: [类型]
**必需证据**: Logic: 单元测试 | Integration: 集成测试 | Visual/Feel: 证据文档 | UI: 交互测试 | Config/Data: 冒烟测试通过

---
## Dependencies
- 依赖: [Story NNN-1 必须DONE 或 None]
- 解锁: [Story NNN+1 或 None]
```

同时更新 `production/epics/[epic-slug]/EPIC.md` 的 Stories 表和 `production/epics/index.md`。

---

## 7. 写入后

使用 AskUserQuestion 询问上下文感知的下一步。

---

## 协作协议

1. **呈现前读取** — 展示 Story 列表前静默加载所有输入
2. **一次询问** — 在一个摘要中呈现 Epic 的所有 Stories
3. **对阻塞 Story 发出警告** — 写入前标记任何使用 Proposed ADR 的 Story
4. **写入前询问** — 写入前获取完整 Story 集合的批准
5. **不发明** — 验收标准来自 GDD，实现注释来自 ADR，规则来自清单
6. **绝不开始实现** — 本技能停止在 Story 文件级别

Verdict: **COMPLETE** — [N] 个 Stories 已写入。
