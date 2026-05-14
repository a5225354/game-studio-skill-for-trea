# Test Helpers — 测试辅助库

为项目的测试套件生成引擎特定的测试辅助库。生成 `tests/helpers/` 目录，包含断言工具、工厂函数和针对项目系统定制的模拟对象。

**输出:** `tests/helpers/` 目录

---

## 触发条件

- 用户说"测试辅助" / "test helpers" / "生成测试工具"

---

## 1. 解析参数

**模式:** `[system-name]` / `all` / `scaffold`

---

## 2. 检测引擎和语言

Read `docs/technical-preferences.md` 提取 Engine 和 Language 值。

---

## 3. 加载已有测试模式

Glob `tests/**/*_test.*`，从代表性测试文件中提取：setup 模式、常用断言、对象创建模式、模拟模式。

---

## 4. 生成引擎特定辅助

### Godot 4 (GDUnit4 / GDScript)
- `tests/helpers/game_assertions.gd` — assert_in_range, assert_signal_emitted, assert_node_exists 等
- `tests/helpers/game_factory.gd` — make_player, make_attacker, make_target 等工厂
- `tests/helpers/scene_runner_helper.gd` — 场景集成测试工具

### Unity (NUnit / C#)
- `tests/helpers/GameAssertions.cs` — AssertInRange, AssertEventRaised, AssertHasComponent
- `tests/helpers/GameFactory.cs` — MakeGameObject, MakeScriptableObject

### Unreal Engine (C++)
- `tests/helpers/GameTestHelpers.h` — GAME_TEST_ASSERT_IN_RANGE 宏, CreateTestWorld

---

## 5. 生成系统特定辅助

Read 系统 GDD 的公式、数据类型和边界情况，生成 `tests/helpers/[system]_factory.[ext]`。

---

## 6. 写入输出

呈现创建摘要，询问批准。**绝不覆盖已有文件。**

Verdict: **COMPLETE** — 辅助文件已创建。

---

## 协作协议

- 绝不覆盖已有辅助文件 — 它们可能已含手工定制
- 生成的代码是起点 — 应适配实际类结构
- 辅助文件应反映 GDD — 边界和常量追溯到公式章节
- 写入前询问
