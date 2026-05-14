# Review All GDDs — 跨GDD审查

本技能同时读取每个系统 GDD，执行两种不能在单独 GDD 隔离中完成的互补审查：

1. **跨GDD一致性** — 文档间的矛盾、过时引用和所有权冲突
2. **游戏设计整体论** — 仅在看到所有系统在一起时才出现的问题

---

## 触发条件

- 用户说"审查所有GDD" / "review all GDDs" / "跨GDD审查"

**Focus:** `full`(默认) / `consistency` / `design-theory` / `since-last-review`

---

## 阶段1: 加载一切

### 1a: 摘要扫描
Grep 所有 GDD 的 `## Summary` 章节。

### 1b: 注册表预加载
Read `design/registry/entities.yaml` 作为冲突基线。

### 1c: 完整文档加载
Read：game-concept.md、game-pillars.md（如存在）、systems-index.md、每个系统 GDD。

如果系统 GDD 少于2个，停止—跨 GDD 审查需要至少2个。

**并行执行**: 阶段2（一致性）和阶段3（设计理论）是独立的—按顺序执行，将结果收集后合并为报告。

---

## 阶段2: 跨GDD一致性

### 2a: 依赖双向性
### 2b: 规则矛盾
### 2c: 过时引用
### 2d: 数据和 Tuning Knob 所有权冲突
### 2e: 公式兼容性
### 2f: 验收标准交叉检查

---

## 阶段3: 游戏设计整体论

### 3a: 进程循环竞争
### 3b: 玩家注意力预算
### 3c: 优势策略检测
### 3d: 经济循环分析
### 3e: 难度曲线一致性
### 3f: 支柱对齐
### 3g: 玩家幻想连贯性

---

## 阶段4: 跨系统场景走查

识别3-5个最重要玩家面对的跨系统时刻并逐步走查：触发器→激活顺序→数据流→玩家体验→失败模式。

---

## 阶段5: 输出审查报告

```
## Cross-GDD Review Report
### 一致性议题 (Blocking / Warnings)
### 游戏设计议题 (Blocking / Warnings)
### 跨系统场景议题
### 标记需修订的GDD
### Verdict: PASS / CONCERNS / FAIL
```

---

## 阶段6: 写入报告和标记GDD

使用 AskUserQuestion 询问写入 `design/gdd/gdd-cross-review-[date].md`。

---

## 阶段7: 交接

使用 AskUserQuestion 询问上下文感知的下一步。

---

## 协作协议

1. 静默读取—加载所有GDD后再呈现
2. 展示一切—在询问行动前呈现完整分析
3. 区分阻塞和建议—不是每个议题都需要阻塞
4. 不做设计决策—标记矛盾但不单方面决定哪个GDD正确
5. 写入前询问
6. 保持具体—每个议题必须引用确切的GDD、章节和文本
