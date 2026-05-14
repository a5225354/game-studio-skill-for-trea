# Consistency Check — 一致性检查

通过对比所有 GDD 与实体注册表来检测跨文档不一致：同名实体不同值、同物品不同值、同公式不同变量。采用 grep-first 方法 — 只读取冲突的 GDD 章节。

---

## 触发条件

- 用户说"一致性检查" / "consistency check" / "检测不一致"

---

## 阶段1: 解析参数和加载注册表

**模式**: `full` / `since-last-review` / `entity:<name>` / `item:<name>`

Read `design/registry/entities.yaml`。如果文件不存在或无条目，停止。

---

## 阶段2: 定位范围内 GDD

Glob `design/gdd/*.md`，排除 `game-concept.md`、`systems-index.md`、`game-pillars.md`。

---

## 阶段3: Grep-First 冲突扫描

对每个已注册条目，grep 每个范围内 GDD 搜索条目名 — 不做完整读取。

- **3a**: 实体扫描
- **3b**: 物品扫描
- **3c**: 公式扫描
- **3d**: 常量扫描

---

## 阶段4: 深度调查（仅冲突）

对每个发现的冲突，做目标化完整章节读取以获取精确上下文。分类为：🔴 CONFLICT / ⚠️ STALE REGISTRY / ℹ️ UNVERIFIABLE。

---

## 阶段5: 输出报告

```
## Consistency Check Report
### Conflicts Found / Stale Registry / Unverifiable / Clean Entries
Verdict: PASS | CONFLICTS FOUND
```

---

## 阶段6: 注册表修正

询问修正过期注册表条目。绝不删除注册表条目 — 设置 `status: deprecated`。

---

## 阶段7: 会话状态和关闭

使用 AskUserQuestion 小部件关闭。

---

## 协作协议

Grep-first 方法确保性能 — 不完整读取所有 GDD，仅目标化检查冲突。
