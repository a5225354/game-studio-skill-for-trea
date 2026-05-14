# Test Setup — 测试框架搭建

本技能为项目搭建自动化测试基础设施。检测已配置的引擎，生成对应的测试运行器配置，创建标准目录布局，并设置 CI/CD 使测试在每次推送时运行。

在 Technical Setup 阶段运行一次，在任何实现开始之前。冲刺开始时安装测试框架花费 30 分钟，冲刺四时安装花费 3 个冲刺。

**输出:** `tests/` 目录结构 + `.github/workflows/tests.yml`

---

## 触发条件

- 用户说"搭建测试" / "设置测试" / "test setup" / "测试框架"

---

## 阶段1: 检测引擎和现有状态

1. **读取引擎配置**: Read `docs/technical-preferences.md`，提取 `Engine:` 值。如果引擎未配置，停止并提示："引擎未配置。先运行 setup-engine 技能。"

2. **检查现有测试基础设施**: Glob 检查 `tests/`、`tests/unit/`、`tests/integration/`、`.github/workflows/`

3. **报告发现**: "引擎: [引擎]。测试目录: [找到/未找到]。CI工作流: [找到/未找到]。"
   - 如果一切已存在且未传 `force` 参数: "测试基础设施似乎已就位。重新运行并指定 force 重新生成。"

---

## 阶段2: 呈现计划

基于检测到的引擎和现有状态，呈现创建计划。询问："我可以创建这些文件吗？我不会覆盖已存在的测试文件。" 未经批准不得继续。

---

## 阶段3: 创建目录结构

创建以下内容：

### `tests/README.md` — 测试基础设施文档

包含引擎信息、测试框架说明、目录布局、运行测试命令、测试命名规范（`[system]_[feature]_test.[ext]`、`test_[scenario]_[expected]`）、Story Type 对应测试证据表。

### 引擎特定文件

**Godot 4**: 创建 `tests/gdunit4_runner.gd`（GdUnit4 测试运行器），提示安装 GdUnit4 插件的步骤。

**Unity**: 创建 `tests/EditMode/README.md` 和 `tests/PlayMode/README.md`。

**Unreal**: 创建 `Source/Tests/README.md`（UE 自动化测试框架）。

---

## 阶段4: 创建 CI/CD 工作流

根据检测到的引擎创建 `.github/workflows/tests.yml`：

- **Godot 4**: 使用 `MikeSchulze/gdunit4-action@v1`
- **Unity**: 使用 `game-ci/unity-test-runner@v4`（需 `UNITY_LICENSE` secret）
- **Unreal**: 使用自托管运行器 + 命令行自动化测试

---

## 阶段5: 创建冒烟测试种子

创建 `tests/smoke/critical-paths.md`，包含核心稳定性、核心机制、数据完整性和性能的 8 条基础检查项。

---

## 阶段6: 安装后摘要

报告创建的文件列表和下一步操作。

Verdict: **COMPLETE** — 测试框架搭建完成，CI/CD 已就绪。

---

## 协作协议

- **绝不覆盖现有测试文件** — 仅创建缺失的文件。
- **始终在创建文件前征得批准**。
- **引擎检测不可协商** — 如果引擎未配置，停止并重定向到 setup-engine。
- **`force` 标志跳过"已存在"早期退出但绝不覆盖**。
