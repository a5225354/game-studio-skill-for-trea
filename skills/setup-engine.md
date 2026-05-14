# Setup Engine — 引擎配置技能

触发条件:
- 用户说"配置引擎" / "设置引擎" / "setup engine" / "选择引擎"
- 用户提到 "godot" / "unity" / "unreal" 并表达配置意愿
- 用户说 "refresh" 更新引擎参考文档

---

## 1. 解析参数

三种模式:

- **完整规格**: 用户提供引擎和版本（如"godot 4.6"）
- **仅引擎**: 用户提供引擎（如"unity"），版本将自动查找
- **无参数**: 完全引导模式（引擎推荐 + 版本选择）

---

## 2. 引导模式（无参数）

如果未指定引擎，运行交互式引擎选择流程：

### 检查现有游戏概念
- 如果存在，读取 `design/gdd/game-concept.md` — 提取游戏类型、范围、目标平台、美术风格、团队规模
- 如果概念不存在，告知用户：
  > "未找到游戏概念。建议先进行头脑风暴发现你想构建什么 — 它还会推荐引擎。或者告诉我你的游戏想法，我可以帮你选择。"

### 如果用户想在无概念的情况下选择，使用 AskUserQuestion 询问:
1. **什么类型的游戏？**（2D、3D，或两者兼具？）
2. **什么平台？**（PC、移动端、主机、网页？）
3. **团队规模和经验？**（单人新手、单人经验丰富、小团队？）
4. **有强烈的语言偏好吗？**（GDScript、C#、C++、可视化脚本？）
5. **引擎授权预算？**（仅免费，还是可接受商业授权？）

### 给出推荐

使用以下决策矩阵：

| 因素 | Godot 4 | Unity | Unreal Engine 5 |
|------|---------|-------|-----------------|
| **最适用于** | 2D 游戏、小型 3D、单人/小团队 | 移动端、中等规模 3D、跨平台 | 3A 级 3D、照片级写实、大型团队 |
| **语言** | GDScript（+ C#，通过扩展支持 C++） | C# | C++ / Blueprint |
| **费用** | 免费，MIT 许可证 | 收入门槛以下免费 | 收入门槛以下免费，5% 版税 |
| **学习曲线** | 平缓 | 中等 | 陡峭 |
| **2D 支持** | 优秀（原生） | 良好（但以 3D 为优先） | 可行但非理想选择 |
| **3D 质量上限** | 良好（快速提升中） | 非常好 | 业界领先 |
| **Web 导出** | 支持（原生） | 支持（有限制） | 不支持 |
| **主机导出** | 通过第三方 | 支持（需要授权） | 支持 |
| **开源** | 是 | 否 | 源码可用 |

给出排名前 1-2 的推荐及其与用户回答相关联的理由。让用户自行选择 — 永远不要强制推荐。

---

## 3. 查找当前版本

引擎确定后:
- 如果提供了版本，直接使用
- 如果未提供版本，使用 WebSearch 查找最新稳定版：
  - 搜索：`"[engine] latest stable version [当前年份]"`
  - 与用户确认："最新稳定版 [引擎] 是 [版本]。使用这个吗？"

---

## 4. 更新技术栈

更新项目的技术栈配置。将占位符替换为实际值：

**Godot:**
```
- 引擎: Godot [版本]
- 语言: GDScript（主要），通过 GDExtension 支持 C++（性能关键场景）
- 构建系统: SCons（引擎），Godot 导出模板
- 资产管线: Godot 导入系统 + 自定义资源管线
```

**Unity:**
```
- 引擎: Unity [版本]
- 语言: C#
- 构建系统: Unity Build Pipeline
- 资产管线: Unity Asset Import Pipeline + Addressables
```

**Unreal:**
```
- 引擎: Unreal Engine [版本]
- 语言: C++（主要），Blueprint（游戏玩法原型开发）
- 构建系统: Unreal Build Tool (UBT)
- 资产管线: Unreal Content Pipeline
```

---

## 5. 填充命名约定

向用户展示引擎对应的默认命名约定：

**Godot (GDScript):**
- 类名：PascalCase（如 `PlayerController`）
- 变量/函数：snake_case（如 `move_speed`）
- 信号：snake_case 过去时（如 `health_changed`）
- 文件名：snake_case 与类名匹配（如 `player_controller.gd`）
- 场景：PascalCase 与根节点匹配（如 `PlayerController.tscn`）
- 常量：UPPER_SNAKE_CASE（如 `MAX_HEALTH`）

**Unity (C#):**
- 类名：PascalCase（如 `PlayerController`）
- 公共字段/属性：PascalCase（如 `MoveSpeed`）
- 私有字段：_camelCase（如 `_moveSpeed`）
- 方法：PascalCase（如 `TakeDamage()`）
- 文件名：PascalCase 与类名匹配（如 `PlayerController.cs`）

**Unreal (C++):**
- 类名：带前缀的 PascalCase（`A` 表示 Actor，`U` 表示 UObject，`F` 表示结构体）
- 变量：PascalCase（如 `MoveSpeed`）
- 函数：PascalCase（如 `TakeDamage()`）
- 布尔值：`b` 前缀（如 `bIsAlive`）

协作确认:
> "这是 [引擎] 的默认命名约定。要自定义其中任何一项，还是直接使用默认值？"

---

## 6. 确定知识缺口

检查引擎版本是否可能超出 AI 训练数据范围:

- AI 知识截止日期：约 2025 年初
- Godot：可能覆盖到 ~4.3
- Unity：可能覆盖到 ~2023.x / 6000.x 早期版本
- Unreal：可能覆盖到 ~5.3 / 5.4 早期版本

评估:
- **在范围内** → `低风险` — 参考可选但推荐
- **接近边界** → `中风险` — 推荐参考文档
- **超出范围** → `高风险` — 建议使用 WebSearch 补充

告知用户所属类别。

---

## 7. 引擎参考文档

### 如果在训练范围内（低风险）:
告知用户风险低，引擎参考可通过此 Skill 的 `docs/engine-reference/` 获取，无需额外操作。

### 如果超出训练范围（中/高风险）:
1. 使用 WebSearch 搜索：
   - `"[engine] [版本] breaking changes"`
   - `"[engine] [版本] deprecated API"`
   - `"[engine] [版本] migration guide"`
2. 总结关键发现
3. 告知用户将这些信息保存到 `docs/engine-reference/<engine>/` 目录

---

## 8. Refresh 子命令

如果用户请求 refresh:
1. 检测当前已配置的引擎和版本
2. 使用 WebSearch 检查：
   - 自上次配置以来的新引擎发布
   - 更新的迁移指南
   - 新废弃的 API
3. 报告发现并建议更新

---

## 9. 输出摘要

设置完成后，输出:

```
引擎设置完成
=====================
引擎：            [名称] [版本]
知识风险：        [低/中/高]
命名约定：        [已配置]

后续步骤：
1. 查看 docs/engine-reference/<引擎>/ 获取引擎参考
2. 运行 系统映射 将概念分解为独立系统
3. 运行 系统设计 逐系统编写 GDD（引导式，按章节）
4. 运行 原型 [核心机制] 测试核心循环
5. 创建第一个冲刺：规划冲刺
```

## 护栏

- 绝对不要猜测引擎版本 — 始终通过 WebSearch 或用户确认来验证
- 始终在修改任何配置文件之前向用户展示将要修改的内容
- 如果 WebSearch 返回模糊结果，展示给用户并让其决定
- 如果已有不同引擎的配置，替换前先询问
