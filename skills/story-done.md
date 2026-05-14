# Story Done — Story完成审查

本技能在设计和实现之间关闭循环。在实现任何 Story 结束时运行。确保每个验收标准在被标记为完成之前被验证。

**输出:** 更新的 Story 文件（Status: Complete）+ 呈现的下一就绪 Story。

---

## 触发条件

- 用户说"Story完成" / "story done" / "标记完成" / "关闭Story"

---

## 阶段1: 找到Story

**如提供文件路径**: 直接读取。

**如无参数**: 检查 `production/session-state/active.md` → 当前冲刺文件 → 使用 AskUserQuestion 列出进行中 Story。

---

## 阶段2: 读取Story

Read Story 完整文件，提取：Story 名称和 ID、TR-ID(s)、Manifest Version、ADR 引用、验收标准、实现文件、Story Type、引擎说明、完成定义。

同时 Read：TR 注册表（获取当前需求文本）、被引用的 GDD 章节、被引用的 ADR、控制清单。

---

## 阶段3: 验证验收标准

对每个验收标准使用三种方法之一验证：

### 自动验证（自动运行）
- 文件存在性检查
- 测试通过检查（如果指定了测试文件路径，运行之）
- 无硬编码数值检查
- 无硬编码字符串检查

### 带确认的手动验证（AskUserQuestion）
成批最多4个手动验证问题合并到单个 `AskUserQuestion` 调用。

### 不可验证（标记但不阻塞）
需要完整游戏构建才能测试的标准。

### 测试-标准可追溯性
映射每个验收标准到覆盖它的测试，生成可追溯表。如果 >50% 标准 UNTESTED → BLOCKING。

---

## 阶段4: 检查偏差

比较实现与设计文档。自动运行检查：
1. GDD 规则检查
2. 清单版本过时检查
3. ADR 约束检查
4. 硬编码数值检查
5. 范围检查

对每个偏差分类：**BLOCKING**（必须修复）/ **ADVISORY**（文档化）/ **OUT OF SCOPE**。

---

## 阶段4b: QA 覆盖门禁（可选 full 模式）

如使用 full 审查模式，可扮演 qa-lead 角色审查测试覆盖。

---

## 阶段5: 首席程序员代码审查门禁（可选）

如使用 full 审查模式，扮演 lead-programmer 角色审查代码。如 lean 模式，使用 AskUserQuestion 询问用户是否已运行 code-review。

---

## 阶段6: 呈现完成报告

在更新文件之前呈现完整报告：
- 验收标准通过/失败
- 测试-标准可追溯表
- 测试证据状态
- 偏差
- 范围
- 裁决: COMPLETE / COMPLETE WITH NOTES / BLOCKED

**裁决定义:**
- **COMPLETE**: 所有标准通过，无阻塞偏差
- **COMPLETE WITH NOTES**: 所有标准通过，已文档化建议偏差
- **BLOCKED**: 失败标准或阻塞偏差必须先解决

如果裁决为 **BLOCKED**: 不进入阶段7，列出必须修复的内容。

---

## 阶段7: 更新Story状态

使用 AskUserQuestion 获取写入批准。如批准：
1. 更新 Status: Complete
2. 更新 Last Updated 日期
3. 添加 Completion Notes 章节
4. 可选：记录建议偏差到 `docs/tech-debt-register.md`
5. 更新 `production/sprint-status.yaml`（如存在）
6. 建议 git commit 命令

---

## 阶段8: 呈现下一Story

帮助开发者保持动力：读取当前冲刺计划，找到就绪且未被阻塞的 Story，呈现在"Next Up"部分。

如果冲刺所有 Must Have Story 完成，呈现关闭序列：smoke-check → team-qa → retrospective → gate-check → sprint-plan new。

---

## 协作协议

- **绝不未经用户批准标记完成** — 阶段7需明确"是"
- **绝不自动修复失败标准** — 报告并询问
- **偏差是事实而非评判** — 中立呈现
- **BLOCKED 裁决是建议性的** — 用户可覆盖并标记完成
- 使用 AskUserQuestion 获取代码审查提示和批量手动确认

Verdict: COMPLETE / COMPLETE WITH NOTES / BLOCKED
