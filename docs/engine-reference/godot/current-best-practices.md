# Godot — 当前最佳实践

最后验证：2026-02-12 | 引擎：Godot 4.6

自模型训练数据（~4.3）以来**新增或变更**的实践。
本文档补充（而非替代）agent 的内置知识。

## GDScript（4.5+）

- **可变参数（Variadic arguments）**：函数可以接受任意数量的参数
  ```gdscript
  func log_values(prefix: String, values: Variant...) -> void:
      for v in values:
          print(prefix, ": ", v)
  ```

- **抽象类和方法**：使用 `@abstract` 强制继承
  ```gdscript
  @abstract
  class_name BaseEnemy extends CharacterBody3D

  @abstract
  func get_attack_pattern() -> Array[Attack]:
      pass  # 子类必须重写
  ```

- **脚本回溯（Script backtracing）**：即使在 Release 构建中也可获取详细调用栈

## 物理（4.6）

- **Jolt Physics 是新项目的默认 3D 引擎**
  - 比 GodotPhysics3D 具有更好的确定性和稳定性
  - 部分 HingeJoint3D 属性（`damp`）仅在 GodotPhysics 中生效
  - 切换方式：项目设置 → Physics → 3D → Physics Engine
  - 2D 物理未变（仍为 Godot Physics 2D）

## 渲染（4.6）

- **D3D12 是 Windows 默认渲染后端**（之前为 Vulkan）——为了更好的驱动兼容性
- **辉光现在在色调映射之前处理**，使用屏幕混合模式 —— 现有辉光设置外观可能不同
- **SSR 全面重做** —— 真实感、稳定性和性能大幅提升
- **AgX 色调映射器** —— 新增白点和对比度控制

## 渲染（4.5）

- **着色器烘焙器（Shader Baker）**：预编译着色器以消除启动卡顿
- **SMAA 1x**：新抗锯齿选项 —— 比 FXAA 更锐利，比 TAA 更轻量
- **模板缓冲（Stencil buffer）**：可用于高级遮罩/传送门效果
- **弯曲法线贴图（Bent normal maps）**：法线贴图纹理中编码方向性遮蔽
- **镜面反射遮蔽（Specular occlusion）**：环境光遮蔽现在会影响反射

## 无障碍（4.5+）

- **屏幕阅读器支持**：Control 节点通过 AccessKit 与辅助工具集成
- **实时翻译预览**：直接在编辑器中测试不同语言的 GUI 布局
- **FoldableContainer**：新手风琴式 UI 节点，用于可折叠区域
- **递归 Control 禁用**：通过单一属性禁用整个节点层级的鼠标/焦点交互

## 动画（4.5+）

- **BoneConstraint3D**：使用修饰器将骨骼绑定到其他骨骼
  - AimModifier3D、CopyTransformModifier3D、ConvertTransformModifier3D

## 动画（4.6）

- **IK 系统完全恢复**：为 3D 重新引入完整的反向运动学
  - 可用修饰器：CCDIK、FABRIK、Jacobian IK、Spline IK、TwoBoneIK
  - 通过 `SkeletonModifier3D` 节点应用

## 资源（4.5+）

- **`duplicate_deep()`**：嵌套资源树的显式深拷贝
  - 旧的 `duplicate()` 行为保留以保持向后兼容
  - 当需要嵌套资源的逐实例副本时使用 `duplicate_deep()`

## 导航（4.5+）

- **专用 2D 导航服务器**：不再代理到 3D NavigationServer
  - 减少了仅 2D 游戏的导出二进制体积

## UI（4.6）

- **双焦点系统**：鼠标/触摸焦点现在与键盘/手柄焦点分离
  - 不同输入方式的视觉反馈不同
  - 设计自定义焦点行为时需考虑这一点

## 编辑器工作流（4.6）

- 灵活的停靠面板拖放，带蓝色轮廓预览（包括底部面板）
- 大多数面板支持浮动窗口（调试器除外）
- 新快捷键：Alt+O（输出）、Alt+S（着色器）
- 导出变量自动生成：将资源从文件系统拖入脚本编辑器
- 启用"实时预览"后，快速打开对话框中支持实时预览
- 新增"选择模式"（v 键）防止意外变换；旧模式重命名为"变换模式"（q 键）

## 平台（4.5+）

- **visionOS 导出**：开源以来首个新平台（窗口应用模式）
- **SDL3 手柄驱动**：更好的跨平台手柄支持
- **Android**：全面屏显示、摄像头画面访问、16KB 页面支持（Android 15+）
- **Linux**：Wayland 子窗口支持，实现多窗口能力
