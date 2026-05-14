# Unity 6.3 LTS — 破坏性变更

**最后验证:** 2026-02-13

本文档追踪 Unity 2022 LTS（可能在模型训练数据中）与 Unity 6.3 LTS（当前版本）之间的破坏性 API 变更和行为差异。按风险等级组织。

## 高风险 — 将破坏现有代码

### Entities/DOTS API 完全重构
**版本:** Entities 1.0+ (Unity 6.0+)

```csharp
// ❌ 旧版（Unity 6 之前，GameObjectEntity 模式）
public class HealthComponent : ComponentData {
    public float Value;
}

// ✅ 新版（Unity 6+，IComponentData）
public struct HealthComponent : IComponentData {
    public float Value;
}

// ❌ 旧版: ComponentSystem
public class DamageSystem : ComponentSystem { }

// ✅ 新版: ISystem（非托管，Burst 兼容）
public partial struct DamageSystem : ISystem {
    public void OnCreate(ref SystemState state) { }
    public void OnUpdate(ref SystemState state) { }
}
```

**迁移:** 遵循 Unity 的 ECS 迁移指南。需要重大架构变更。

---

### 输入系统 — 旧版 Input 已弃用
**版本:** Unity 6.0+

```csharp
// ❌ 旧版: Input 类（已弃用）
if (Input.GetKeyDown(KeyCode.Space)) { }

// ✅ 新版: Input System 包
using UnityEngine.InputSystem;
if (Keyboard.current.spaceKey.wasPressedThisFrame) { }
```

**迁移:** 安装 Input System 包，将所有 `Input.*` 调用替换为新 API。

---

### URP/HDRP 渲染器特性 API 变更
**版本:** Unity 6.0+

```csharp
// ❌ 旧版: ScriptableRenderPass.Execute 签名
public override void Execute(ScriptableRenderContext context, ref RenderingData data)

// ✅ 新版: 使用 RenderGraph API
public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
```

**迁移:** 更新自定义渲染通道以使用 RenderGraph API。

---

## 中等风险 — 行为变更

### Addressables — 资源加载返回值变更
**版本:** Unity 6.2+

资源加载失败时现在默认抛出异常，而不是返回 null。
需要添加适当的异常处理，或使用 `TryLoad` 变体。

```csharp
// ❌ 旧版: 失败时静默返回 null
var handle = Addressables.LoadAssetAsync<Sprite>("key");
var sprite = handle.Result; // 失败时为 null

// ✅ 新版: 失败时抛出异常，使用 try/catch 或 TryLoad
try {
    var handle = Addressables.LoadAssetAsync<Sprite>("key");
    var sprite = await handle.Task;
} catch (Exception e) {
    Debug.LogError($"加载失败: {e}");
}
```

---

### 物理 — 默认求解器迭代次数变更
**版本:** Unity 6.0+

默认求解器迭代次数已增加以提高稳定性。
如果你依赖旧行为，请检查 `Physics.defaultSolverIterations`。

---

## 低风险 — 已弃用（仍可使用）

### UGUI（旧版 UI）
**状态:** 已弃用但仍受支持
**替代方案:** UI Toolkit

UGUI 仍然可用，但推荐 UI Toolkit 用于新项目。

---

### 旧版粒子系统
**状态:** 已弃用
**替代方案:** Visual Effect Graph (VFX Graph)

---

### 旧版动画系统
**状态:** 已弃用
**替代方案:** Animator Controller (Mecanim)

---

## 平台特定的破坏性变更

### WebGL
- **Unity 6.0+**: WebGPU 现为默认（可回退到 WebGL 2.0）
- 更新着色器以兼容 WebGPU

### Android
- **Unity 6.0+**: 最低 API 级别提升至 24 (Android 7.0)

### iOS
- **Unity 6.0+**: 最低部署目标提升至 iOS 13

---

## 迁移清单

从 2022 LTS 升级到 Unity 6.3 LTS 时:

- [ ] 审查所有 DOTS/ECS 代码（可能需要完全重写）
- [ ] 将 `Input` 类替换为 Input System 包
- [ ] 更新自定义渲染通道为 RenderGraph API
- [ ] 为 Addressables 调用添加异常处理
- [ ] 测试物理行为（求解器迭代次数已变更）
- [ ] 考虑将 UGUI 迁移到 UI Toolkit 用于新 UI
- [ ] 更新 WebGL 着色器以兼容 WebGPU
- [ ] 验证最低平台版本（Android/iOS）

---

**来源:**
- https://docs.unity3d.com/6000.0/Documentation/Manual/upgrade-guides.html
- https://docs.unity3d.com/Packages/com.unity.entities@1.3/manual/upgrade-guide.html
