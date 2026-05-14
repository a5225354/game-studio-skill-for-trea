# Day-One Patch — 首发日补丁

为游戏发布准备首发日补丁。范围界定、优先级排序、实现和QA门禁一个聚焦补丁，处理在Gold Master之后发现的已知问题。将补丁视为一个具有自身QA门禁和回滚计划的迷你冲刺。

**输出:** `production/releases/day-one-patch-[version].md`

---

## 触发条件

- 用户说"首发补丁" / "day one patch" / "首发日修复"

---

## 阶段1: 加载发布上下文

Read `production/stage.txt` (确认在 Release 阶段)、最近门禁裁决、所有开放Bug、当前冲刺计划、最近安全审计。

如果不在 Release/Polish 阶段 → 停止。

---

## 阶段2: 界定补丁范围

### 2a: 分类开放Bug

对每个开放Bug评估是否纳入首发补丁：S1/S2+安全修复+<4小时 → 纳入；需架构变更 → 推迟到1.1；配置/数据修复 → 纳入(低风险)。

### 2b: 呈现范围

使用 AskUserQuestion 确认：纳入Bug表 + 推迟Bug表。

### 2c: 检查总范围

如果估算超过1天工作量 → 警告并征求减少范围。

---

## 阶段3: 回滚计划

在写任何代码前定义回滚程序(不可协商)。扮演 release-manager 角色生成回滚计划并写入 `production/releases/rollback-plan-[version].md`。

---

## 阶段4: 实现修复

对每个批准的Bug执行聚焦实现循环：
1. 扮演 lead-programmer 角色 (最小可行修复)
2. 扮演 qa-tester 角色 (验证Bug不再复现)

配置/数据修复：直接修改(无需程序员角色)。

---

## 阶段5: 补丁QA门禁

轻量级QA通行：扮演 qa-lead 角色决定冒烟测试 vs 回归测试。QA裁决必须是 PASS 或 PASS WITH WARNINGS 才能继续。

---

## 阶段6: 生成补丁记录

包含：补丁说明(内部) / 推迟Bug / QA签收 / 回滚计划 / 所需批准 / 玩家面向补丁说明

---

## 阶段7: 下一步

生成玩家补丁说明，运行 bug-report verify/close，安排发布后审查。

Verdict: **COMPLETE** — 首发补丁已写入。

---

## 协作协议

- **范围纪律是一切** — 抵制范围蔓延
- **回滚计划优先，总是优先**
- **推迟不等于遗忘**
- **玩家沟通是补丁的一部分**
