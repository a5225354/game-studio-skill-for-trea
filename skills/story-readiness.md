# Story Readiness — Story就绪验证

验证 Story 文件包含开发者开始实现所需的一切 — 无中期冲刺设计中断、无猜测、无模糊验收标准。在分配 Story 之前运行。

**输出:** 每个 Story 的裁决（READY / NEEDS WORK / BLOCKED）+ 每个非就绪 Story 的特定缺口列表。

---

## 触发条件

- 用户说"Story就绪" / "story readiness" / "检查Story" / "可以开始做这个Story吗"

---

## 1. 解析参数

- **特定路径** — 验证该 Story 文件
- **`sprint`** — 读取当前冲刺计划，提取所有引用的 Story 路径
- **`all`** — Glob `production/epics/**/*.md`，验证所有找到的 Story 文件
- **无参数** — 使用 AskUserQuestion 询问

---

## 2. 加载支持上下文

一次性加载（不按 Story 重复）：
- `design/gdd/systems-index.md`
- `docs/architecture/control-manifest.md`（如存在）
- `docs/architecture/tr-registry.yaml` — 索引所有条目
- 所有 ADR 状态字段
- 当前冲刺文件（如范围为 `sprint`）

---

## 3. Story 就绪清单

对每个 Story 文件评估以下每个项目：

### 设计完整性
- [ ] GDD 需求已引用
- [ ] 需求自包含
- [ ] 验收标准可测试
- [ ] 无需要判断调用的验收标准（Visual/Feel 类型自动通过）

### 架构完整性
- [ ] ADR 已引用或明确 N/A
- [ ] ADR 为 Accepted（非 Proposed）— Proposed → BLOCKED
- [ ] TR-ID 有效且活跃
- [ ] 清单版本为当前版本
- [ ] 引擎说明存在
- [ ] 控制清单规则已注明

### 范围清晰度
- [ ] 估算存在
- [ ] 范围内/范围外边界已陈述
- [ ] Story 依赖已列出

### 开放问题
- [ ] 无未解决的设计问题
- [ ] 依赖 Story 不在 DRAFT 状态

### 资产引用检查
- [ ] 引用的资产存在（存在性检查）

### 完成定义
- [ ] 按 Story 类型的最低可测试验收标准数量达标
- [ ] 性能预算已注明（如适用）
- [ ] Story 类型已声明
- [ ] 测试证据需求明确

---

## 4. 裁决分配

三种裁决每个 Story：
- **READY** — 所有清单项目通过或有明确 N/A 理由
- **NEEDS WORK** — 一个或多个清单项目失败，但所有依赖 Story 存在且非 DRAFT
- **BLOCKED** — 一个或多个依赖 Story 缺失或为 DRAFT，或关键设计问题无责任人

---

## 5. 输出格式

单个 Story 输出：标题、文件、裁决、通过检查、缺口（含修复说明）、阻塞项。

多个 Story 聚合输出：就绪/需工作/阻塞统计 + 每类简要列表 + 非就绪 Story 详细信息。

### 冲刺升级

如果范围是 `sprint` 且任何 Must Have Story 为 NEEDS WORK 或 BLOCKED，在输出顶部添加突出警告。

---

## 6. 协作协议

本技能只读 — 绝不提议编辑或请求写入文件。

报告后提供："是否需要我帮助填补这些 Story 的缺口？我可以起草缺失章节供你批准。"

**重定向规则:**
- Story 文件完全缺失 → "运行 create-epics 然后 create-stories"
- Story 无 GDD 引用且工作较小 → "运行 quick-design"
- Story 范围增长超出原始规模 → "考虑拆分或上报给 producer"

---

## 7. 下一Story交接

完成单个 Story 就绪检查后，读取当前冲刺文件，列出最多3个其他就绪 Story。

---

## 8: 可选 QA 门禁（full模式）

如使用 full 审查模式，可扮演 qa-lead 角色进行额外审查。

Verdict: **COMPLETE** — 已识别下一步。
