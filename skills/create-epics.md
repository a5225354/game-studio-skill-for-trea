# Create Epics — Epic创建

一个 Epic 是一个命名的、有边界的工作体，映射到一个架构模块。它定义了**构建什么**以及**谁在架构上拥有它**。它不规定实现步骤 — 那是故事的工作。

**按层运行此技能一次**：Foundation → Core → Feature → Presentation。

**输出:** `production/epics/[epic-slug]/EPIC.md` + `production/epics/index.md`

---

## 触发条件

- 用户说"创建Epic" / "create epics" / "划分Epic"

---

## 1. 解析参数

**模式:**
- `all` — 按层顺序处理所有系统
- `layer: foundation` — 仅 Foundation 层
- `layer: core` — 仅 Core 层
- `[系统名]` — 一个特定系统
- 无参数 — 询问用户

---

## 2. 加载输入

### 步骤2a — 摘要扫描
Grep 所有 GDD 的 `## Summary` 章节。

### 步骤2b — 完整文档加载（仅范围内系统）
Read 仅范围内系统需要的文档：`systems-index.md`、范围内 GDD、范围内已接受 ADR、`architecture.md`、`control-manifest.md`、`tr-registry.yaml`、引擎 VERSION.md。

---

## 3. 处理顺序

按依赖安全的层顺序处理：Foundation → Core → Feature → Presentation。每层内使用 `systems-index.md` 中的顺序。

---

## 4. 定义每个 Epic

对每个系统，将其映射到 `architecture.md` 中的架构模块。检查 ADR 覆盖，对未覆盖需求发出警告。

呈现 Epic 定义（包含层、GDD、架构模块、治理 ADR、引擎风险、GDD 需求覆盖）并征求批准。

---

## 4b. 制作人 Epic 结构门禁（可选）

如果实施了审查模式，可扮演 producer 角色检查 Epic 结构是否合理。

---

## 5. 写入 Epic 文件

征求批准后写入 `production/epics/[epic-slug]/EPIC.md` 并更新 `production/epics/index.md`。

Epic 文件包含：概览、治理 ADR 表、GDD 需求表（含TR-ID）、完成定义、下一步。

---

## 6. 门禁提醒

Foundation + Core 完成后，提醒需要运行 `gate-check production`。

---

## 协作协议

1. **一次一个 Epic** — 在创建之前呈现每个 Epic 定义
2. **对缺口发出警告** — 继续之前标记未覆盖需求
3. **写入前询问** — 每个 Epic 写入前征得批准
4. **不发明内容** — 所有内容来自 GDD、ADR 和架构文档
5. **绝不创建故事** — 本技能停止在 Epic 级别

Verdict: **COMPLETE** — [N] 个 Epic 已写入。运行 create-stories 每个 Epic。
