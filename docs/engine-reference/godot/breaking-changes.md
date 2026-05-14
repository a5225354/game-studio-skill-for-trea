# Godot — 破坏性变更

最后验证：2026-02-12

Godot 版本之间的变更，重点关注 LLM 知识截止后的变更（4.4+）。

## 4.5 → 4.6（2026 年 1 月 — 截止后发布，高风险）

| 子系统 | 变更 | 详情 |
|--------|------|------|
| 物理 | Jolt 现为默认 3D 物理引擎 | 新项目自动使用 Jolt。现有项目保留原有设置。部分 HingeJoint3D 属性（如 `damp`）仅在 GodotPhysics 中生效。 |
| 渲染 | 辉光在色调映射之前处理 | 之前在色调映射之后处理。包含辉光的场景外观将发生变化。需在 WorldEnvironment 中调整强度/混合。 |
| 渲染 | Windows 默认使用 D3D12 | 之前为 Vulkan。为了更好的驱动兼容性。 |
| 渲染 | AgX 色调映射新增控制 | 新增白点和对比度参数。 |
| 核心 | 四元数初始化为单位四元数 | 之前初始化为零。不太可能影响大多数代码，但属于技术性破坏性变更。 |
| UI | 双焦点系统 | 鼠标/触摸焦点现在与键盘/手柄焦点分离。不同输入方式的视觉反馈不同。 |
| 动画 | IK 系统完全恢复 | 通过 SkeletonModifier3D 节点实现 CCDIK、FABRIK、Jacobian IK、Spline IK、TwoBoneIK。 |
| 编辑器 | 新增"现代"主题默认值 | 灰度替代蓝色调。恢复方式：编辑器设置 → 界面 → 主题 → 样式：Classic |
| 编辑器 | "选择模式"快捷键变更 | 新增"选择模式"（v 键）防止意外变换。旧模式重命名为"变换模式"（q 键）。 |
| 2D | TileMapLayer 场景瓦片旋转 | 场景瓦片现在可以像图集瓦片一样旋转。 |
| 本地化 | CSV 复数形式支持 | 不再需要 Gettext 来处理复数。新增上下文列。 |
| C# | 自动字符串提取 | 翻译字符串从 C# 代码中自动提取。 |
| 插件 | 新增 EditorDock 类 | 专为插件停靠面板设计的容器，支持布局控制。 |

## 4.4 → 4.5（2025 年末 — 截止后发布，高风险）

| 子系统 | 变更 | 详情 |
|--------|------|------|
| GDScript | 新增可变参数 | 函数可以接受 `...` 任意数量参数 — 新语言特性 |
| GDScript | `@abstract` 装饰器 | 抽象类和方法现在可以强制继承 |
| GDScript | 脚本回溯 | 即使在 Release 构建中也可获取详细调用栈 |
| 渲染 | 模板缓冲支持 | 用于高级视觉效果的新功能 |
| 渲染 | SMAA 1x 抗锯齿 | 新的后处理抗锯齿选项 |
| 渲染 | 着色器烘焙器（Shader Baker） | 预编译着色器 — 据报告某些演示中启动速度提升约 20 倍 |
| 渲染 | 弯曲法线贴图、镜面反射遮蔽 | 新材质功能 |
| 无障碍 | 屏幕阅读器支持 | Control 节点通过 AccessKit 与辅助工具配合工作 |
| 编辑器 | 实时翻译预览 | 在编辑器中测试不同语言的 GUI 布局 |
| 物理 | 3D 插值重新架构 | 从 RenderingServer 移至 SceneTree。API 不变，但内部实现不同。 |
| 动画 | BoneConstraint3D | 新增：AimModifier3D、CopyTransformModifier3D、ConvertTransformModifier3D |
| 资源 | 新增 `duplicate_deep()` | 嵌套资源深拷贝的显式方法 |
| 导航 | 专用 2D 导航服务器 | 不再代理到 3D 导航；2D 游戏导出包更小 |
| UI | FoldableContainer 节点 | 新的手风琴式容器，用于可折叠 UI 区域 |
| UI | 递归 Control 行为 | 通过单一属性禁用整个节点层级的鼠标/焦点交互 |
| 平台 | visionOS 导出支持 | 新平台目标 |
| 平台 | SDL3 手柄驱动 | 手柄处理委托给 SDL 库 |
| 平台 | Android 16KB 页面支持 | 针对目标为 Android 15+ 的 Google Play 所需 |

## 4.3 → 4.4（2025 年中 — 接近截止，需验证）

| 子系统 | 变更 | 详情 |
|--------|------|------|
| 核心 | `FileAccess.store_*` 返回 `bool` | 之前返回 `void`。方法包括：`store_8`、`store_16`、`store_32`、`store_64`、`store_buffer`、`store_csv_line`、`store_double`、`store_float`、`store_half`、`store_line`、`store_pascal_string`、`store_real`、`store_string`、`store_var` |
| 核心 | `OS.execute_with_pipe` | 新增可选 `blocking` 参数 |
| 核心 | `RegEx.compile/create_from_string` | 新增可选 `show_error` 参数 |
| 渲染 | `RenderingDevice.draw_list_begin` | 移除大量参数；新增 `breadcrumb` 参数 |
| 渲染 | 着色器纹理类型 | 参数/返回类型从 `Texture2D` 改为 `Texture` |
| 粒子 | `.restart()` 方法 | 新增可选 `keep_seed` 参数（CPU/GPU 2D/3D） |
| GUI | `RichTextLabel.push_meta` | 新增可选 `tooltip` 参数 |
| GUI | `GraphEdit.connect_node` | 新增可选 `keep_alive` 参数 |

## 4.2 → 4.3（在训练数据中 — 低风险）

| 子系统 | 变更 | 详情 |
|--------|------|------|
| 动画 | `Skeleton3D.add_bone` 返回 `int32` | 之前返回 `void` |
| 动画 | `bone_pose_updated` 信号 | 被 `skeleton_updated` 替代 |
| TileMap | `TileMapLayer` 替代 `TileMap` | 每层一个节点，替代多层单一节点 |
| 导航 | `NavigationRegion2D` | 移除了 `avoidance_layers`、`constrain_avoidance` 属性 |
| 编辑器 | `EditorSceneFormatImporterFBX` | 重命名为 `EditorSceneFormatImporterFBX2GLTF` |
| 动画 | AnimationMixer 基类 | AnimationPlayer 和 AnimationTree 现在继承自 AnimationMixer |
