# Asset Spec — 资产规格

从GDD、关卡文档或角色档案生成逐个资产的视觉规格和AI生成提示词。生成结构化规格文件并更新主资产清单。

---

## 触发条件

- 用户说"资产规格" / "asset spec" / "视觉规格" / "生成资产规格"

---

## 阶段0: 解析参数

- `system:[name]` / `level:[name]` / `character:[name]`

如无参数且无已有清单 → 运行实体和界面清单流程(Phase 0b)。

## 阶段0b: 实体和界面清单

从所有源文档中收集：GDD系统、关卡、角色、HUD、VFX、UI界面。按类别组织，呈现并征求用户批准后写入 `design/assets/entity-inventory.md`。

---

## 阶段1: 收集上下文

**必读:** `design/art/art-bible.md` (失败如果缺失: 先运行 art-bible)，`docs/technical-preferences.md`

**按目标类型:** 
- system: Read GDD的 Visual/Audio Requirements 章节
- level: Read `design/levels/[target].md`
- character: Read `design/narrative/characters/[target].md`

---

## 阶段2: 资产识别

从源文档提取每个显式和隐含资产类型，按类别分组。使用 AskUserQuestion 确认资产列表。

---

## 阶段3: 规格生成

**Full 模式**: 顺序扮演 art-director 和 technical-artist 角色（Read `agents/art-director.md` 和 `agents/technical-artist.md`），生成视觉描述+AI提示词+技术规格。

**Lean 模式**: 仅扮演 art-director。

**Solo 模式**: 仅从 art bible 规则推导。

如两者冲突 → 暴露冲突，不静默解决。

---

## 阶段4: 编译和审查

使用 `ASSET-[NNN]` 格式组合规格，呈现所有规格征求审查。

---

## 阶段5: 写入文件

征求批准后写入 `design/assets/specs/[target]-assets.md` 并更新 `design/assets/asset-manifest.md`。

---

## 阶段6: 关闭

使用 AskUserQuestion 询问下一步。

---

## 协作协议

- 绝不未经确认资产列表就编写规格
- 始终以 art bible 为锚点
- 暴露所有角色分歧
- 写入规格文件前明确批准
- 写入后立即更新清单

Verdict: **COMPLETE** — 资产规格已写入。
