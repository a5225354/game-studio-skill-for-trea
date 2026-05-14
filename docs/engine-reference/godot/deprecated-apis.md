# Godot — 已弃用的 API

最后验证：2026-02-12

如果 agent 建议使用"已弃用"列中的任何 API，**必须**替换为"替代方案"列中的 API。

## 节点与类

| 已弃用 | 替代方案 | 起始版本 | 备注 |
|--------|----------|----------|------|
| `TileMap` | `TileMapLayer` | 4.3 | 每层一个节点，替代多层节点 |
| `VisibilityNotifier2D` | `VisibleOnScreenNotifier2D` | 4.0 | 为清晰起见重命名 |
| `VisibilityNotifier3D` | `VisibleOnScreenNotifier3D` | 4.0 | 为清晰起见重命名 |
| `YSort` | `Node2D.y_sort_enabled` | 4.0 | 作为 Node2D 的属性，而非独立节点 |
| `Navigation2D` / `Navigation3D` | `NavigationServer2D` / `NavigationServer3D` | 4.0 | 基于服务器的 API |
| `EditorSceneFormatImporterFBX` | `EditorSceneFormatImporterFBX2GLTF` | 4.3 | 重命名 |

## 方法与属性

| 已弃用 | 替代方案 | 起始版本 | 备注 |
|--------|----------|----------|------|
| `yield()` | `await signal` | 4.0 | GDScript 2.0 协程语法 |
| `connect("signal", obj, "method")` | `signal.connect(callable)` | 4.0 | 基于 Callable 的连接 |
| `instance()` | `instantiate()` | 4.0 | 重命名 |
| `PackedScene.instance()` | `PackedScene.instantiate()` | 4.0 | 重命名 |
| `get_world()` | `get_world_3d()` | 4.0 | 明确的 2D/3D 分离 |
| `OS.get_ticks_msec()` | `Time.get_ticks_msec()` | 4.0 | 推荐使用 Time 单例 |
| 嵌套资源的 `duplicate()` | `duplicate_deep()` | 4.5 | 显式深拷贝控制 |
| `Skeleton3D` 信号 `bone_pose_updated` | `skeleton_updated` | 4.3 | 重命名 |
| `AnimationPlayer.method_call_mode` | `AnimationMixer.callback_mode_method` | 4.3 | 移至基类 |
| `AnimationPlayer.playback_active` | `AnimationMixer.active` | 4.3 | 移至基类 |

## 模式（不仅仅是 API）

| 已弃用模式 | 替代方案 | 原因 |
|------------|----------|------|
| 基于字符串的 `connect()` | 类型化信号连接 | 类型安全，便于重构 |
| 在 `_process()` 中使用 `$NodePath` | `@onready var` 缓存引用 | 性能：每帧都进行路径查找 |
| 无类型 `Array` / `Dictionary` | `Array[Type]`，类型化变量 | GDScript 编译器优化 |
| 着色器参数中的 `Texture2D` | `Texture` 基类型 | 4.4 中已变更 |
| 手动后处理视口链 | `Compositor` + `CompositorEffect` | 结构化后处理（4.3+） |
| 新项目使用 GodotPhysics3D | Jolt Physics 3D | 4.6 起为默认值；稳定性更好 |
