# Create Control Manifest — 控制清单

控制清单是为程序员准备的可操作规则表。它回答"做什么？"和"绝不能做什么？" — 按架构层组织，从所有已接受ADR、技术偏好和引擎参考中提取。

**输出:** `docs/architecture/control-manifest.md`

---

## 触发条件

- 用户说"控制清单" / "control manifest" / "程序员规则表"

---

## 1. 加载所有输入

Read：所有已接受 ADR（跳过 Proposed/Deprecated/Superseded）、`docs/technical-preferences.md`（命名约定、性能预算、禁止模式）、引擎参考（VERSION.md、deprecated-apis.md、best-practices.md）。

---

## 2. 从每个 ADR 提取规则

对每个已接受 ADR，提取：
- **Required Patterns**（来自 Implementation Guidelines）
- **Forbidden Approaches**（来自 Alternatives Considered）
- **Performance Guardrails**（来自 Performance Implications）
- **Engine API Constraints**（来自 Engine Compatibility）

按架构层分类：Foundation / Core / Feature / Presentation。

---

## 3. 添加全局规则

从 technical-preferences.md：命名约定、性能预算、已批准库
从 deprecated-apis.md：所有已弃用 API → Forbidden API 条目

---

## 4. 呈现规则摘要

向用户呈现每层规则计数，使用 AskUserQuestion 确认完整性。

---

## 4b: 技术总监审查（可选）

如使用 full 审查模式，可扮演 technical-director 角色检查规则是否完整、准确、有来源。

---

## 5. 写入控制清单

使用 AskUserQuestion 获取写入批准。格式：清单头部 + Foundation/Core/Feature/Presentation 层规则 + 全局规则。

---

## 6. 建议下一步

- 如 Epics/Stories 尚不存在：运行 create-epics → create-stories
- 如是重新生成：通知团队变更的规则

---

## 协作协议

1. 静默加载—在所有输入加载前不呈现
2. 先展示摘要—让用户看到范围后才写入
3. 写入前询问—始终确认
4. 每条规则必须追溯来源—绝不在无效追溯的情况下添加规则
5. 不解释—按ADR原文提取规则，不改变意义的改写

Verdict: **COMPLETE** — 控制清单已写入。
