# Godot 渲染 — 快速参考

最后验证：2026-02-12 | 引擎：Godot 4.6

## 自 ~4.3 以来的变更（LLM 截止后）

### 4.6 变更
- **D3D12 是 Windows 默认渲染后端**（之前为 Vulkan）
- **辉光在色调映射之前处理**（之前在之后）—— 使用屏幕混合模式
- **AgX 色调映射器**：新增白点和对比度控制
- **SSR 全面重做**：更好的真实感、视觉稳定性和性能

### 4.5 变更
- **着色器烘焙器（Shader Baker）**：预编译着色器以减少启动时间
- **SMAA 1x**：新抗锯齿选项（比 FXAA 更锐利，比 TAA 更轻量）
- **模板缓冲支持**：实现选择性几何遮罩/传送门效果
- **弯曲法线贴图（Bent normal maps）**：法线贴图纹理中编码方向性遮蔽
- **镜面反射遮蔽（Specular occlusion）**：环境光遮蔽现在正确影响反射

### 4.4 变更
- **`RenderingDevice.draw_list_begin`**：移除大量参数；新增可选 `breadcrumb` 参数
- **着色器纹理类型**：从 `Texture2D` 改为 `Texture` 基类型
- **粒子 `.restart()`**：新增可选 `keep_seed` 参数

### 4.3 变更（在训练数据中）
- **Compositor 节点**：`Compositor` + `CompositorEffect` 用于后处理链

## 当前 API 模式

### 后处理（4.3+）
```gdscript
# 使用 Compositor 节点 —— 而非手动视口着色器链
# 将 Compositor 添加为 WorldEnvironment 或 Camera3D 的子节点
# 为每个后处理步骤创建 CompositorEffect 资源
```

### 抗锯齿选项（4.6）
```
项目设置 → Rendering → Anti Aliasing:
- MSAA 2D/3D：硬件 MSAA（质量好但开销大）
- Screen Space AA：FXAA（快速，较模糊）或 SMAA（锐利，开销适中）  # SMAA 4.5 新增
- TAA：时间抗锯齿（质量最好，快速运动时有残影）
```

### 渲染后端选择（4.6）
```
项目设置 → Rendering → Renderer:
- Forward+（默认）：功能完整，面向桌面端
- Mobile：针对移动端/低端设备优化，功能有限
- Compatibility：OpenGL 3.3 / WebGL 2，最广泛的硬件支持

Windows 默认后端：D3D12（4.6 之前为 Vulkan）
```

## 常见错误
- 假设 Vulkan 是 Windows 默认后端（4.6 起为 D3D12）
- 后处理使用手动视口链而非 Compositor
- 着色器 uniform 类型使用 `Texture2D`（4.4 起使用 `Texture`）
- 拥有大量着色器变体的项目未使用着色器烘焙器
