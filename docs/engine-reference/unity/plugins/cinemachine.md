# Unity 6.3 — Cinemachine

**最后验证:** 2026-02-13
**状态:** 生产就绪
**包:** `com.unity.cinemachine` v3.0+ (Package Manager)

---

## 概述

**Cinemachine** 是 Unity 的虚拟摄像机系统，无需手动编写脚本即可实现专业的动态摄像机行为。它是 Unity 摄像机工作的行业标准。

**适用场景:**
- 第三人称跟随摄像机
- 过场动画和电影镜头
- 摄像机混合与过渡
- 动态摄像机构图
- 屏幕震动和摄像机特效

**⚠️ 知识差距:** Cinemachine 3.0 (Unity 6) 是从 2.x 的重大重写。
许多 API 名称和组件已变更。

---

## 安装

### 通过 Package Manager 安装

1. `Window > Package Manager`
2. Unity Registry > 搜索 "Cinemachine"
3. 安装 `Cinemachine`（版本 3.0+）

---

## 核心概念

### 1. **虚拟摄像机 (Virtual Cameras)**
- 定义摄像机行为（位置、旋转、镜头）
- 可以存在多个虚拟摄像机；同一时间只有一个处于 "激活" 状态

### 2. **Cinemachine Brain**
- 主摄像机上的组件
- 在虚拟摄像机之间混合
- 将虚拟摄像机设置应用到 Unity 摄像机

### 3. **优先级 (Priorities)**
- 虚拟摄像机具有优先级值
- 最高优先级的摄像机处于激活状态
- 优先级变更时平滑混合

---

## 基本设置

### 1. 将 Cinemachine Brain 添加到主摄像机

```csharp
// 创建第一个虚拟摄像机时自动添加
// 或手动: Add Component > Cinemachine Brain
```

### 2. 创建虚拟摄像机

`GameObject > Cinemachine > Cinemachine Camera`

这将创建一个带有默认设置的 **CinemachineCamera** GameObject。

---

## 虚拟摄像机组件

### CinemachineCamera (Unity 6 / Cinemachine 3.0+)

```csharp
using Unity.Cinemachine;

public class CameraController : MonoBehaviour {
    public CinemachineCamera virtualCamera;

    void Start() {
        // 设置优先级（越高越优先）
        virtualCamera.Priority = 10;

        // 设置跟随目标
        virtualCamera.Follow = playerTransform;

        // 设置注视目标
        virtualCamera.LookAt = playerTransform;
    }
}
```

---

## 跟随模式（Body 组件）

### 第三人称跟随（轨道跟随）

```csharp
// 在 Inspector 中:
// CinemachineCamera > Body > 3rd Person Follow

// 配置:
// - Shoulder Offset: (0.5, 0, 0) 用于越肩视角
// - Camera Distance: 5.0
// - Vertical Damping: 0.5（平滑上下）
```

### Framing Transposer（平滑跟随）

```csharp
// CinemachineCamera > Body > Position Composer

// 配置:
// - Screen Position: 居中 (0.5, 0.5)
// - Dead Zone: 目标在区域内时不移动摄像机
// - Damping: 平滑跟随
```

### Hard Lock（精确跟随）

```csharp
// CinemachineCamera > Body > Hard Lock to Target
// 摄像机精确匹配目标位置（无偏移或阻尼）
```

---

## 瞄准模式（Aim 组件）

### Composer（构图目标）

```csharp
// CinemachineCamera > Aim > Composer

// 配置:
// - Tracked Object Offset: 瞄准目标头部而非脚部
// - Screen Position: 目标出现在屏幕上的位置
// - Dead Zone: 目标在区域内时不旋转
```

### Look At Target（注视目标）

```csharp
// CinemachineCamera > Aim > Rotate With Follow Target
// 摄像机旋转匹配目标旋转（如第一人称）
```

---

## 摄像机间混合

### 基于优先级的混合

```csharp
public CinemachineCamera normalCamera; // 优先级: 10
public CinemachineCamera aimCamera;    // 优先级: 5

void StartAiming() {
    // 设置瞄准摄像机为更高优先级
    aimCamera.Priority = 15; // 现在激活
    // Brain 自动从 normalCamera 混合到 aimCamera
}

void StopAiming() {
    aimCamera.Priority = 5; // 恢复正常
}
```

### 自定义混合时间

```csharp
// 创建 Custom Blends 资源:
// Assets > Create > Cinemachine > Cinemachine Blender Settings

// 在 Cinemachine Brain 中:
// - Custom Blends = 你的资源
// - 配置每对摄像机之间的混合时间
```

---

## 摄像机震动

### Impulse Source（触发震动）

```csharp
using Unity.Cinemachine;

public class ExplosionShake : MonoBehaviour {
    public CinemachineImpulseSource impulseSource;

    void Explode() {
        // 触发摄像机震动
        impulseSource.GenerateImpulse();
    }
}
```

### Impulse Listener（接收震动）

```csharp
// 添加到 CinemachineCamera:
// Add Component > CinemachineImpulseListener

// Impulse Listener 自动接收附近 Impulse Source 的震动
```

---

## Freelook 摄像机（带鼠标视角的第三人称）

### Cinemachine Free Look

```csharp
// GameObject > Cinemachine > Cinemachine Free Look

// 创建 3 个 Rig（顶部、中部、底部），根据垂直输入混合
// 配置:
// - Orbit Radius: 与目标的距离
// - Height Offset: 每个 Rig 的摄像机高度
// - X/Y Axis: 鼠标或摇杆输入
```

---

## 状态驱动摄像机（基于动画）

### Cinemachine State-Driven Camera

```csharp
// GameObject > Cinemachine > Cinemachine State-Driven Camera

// 配置:
// - Animated Target: 带 Animator 的角色
// - Layer: 要跟踪的 Animator 层
// - State: 为每个动画状态分配摄像机（Idle、Run、Jump 等）

// 摄像机根据动画状态自动切换
```

---

## Dolly 轨道（过场动画）

### Cinemachine Dolly Track

```csharp
// 1. 创建样条线: GameObject > Cinemachine > Cinemachine Spline

// 2. 创建 Dolly Camera:
//    GameObject > Cinemachine > Cinemachine Camera
//    Body > Spline Dolly
//    指定 Spline

// 3. 在样条线上动画化 Dolly 位置（Timeline 或脚本）
```

---

## 常用模式

### 第三人称跟随摄像机

```csharp
// CinemachineCamera
// - Follow: 玩家 Transform
// - Body: 3rd Person Follow（肩偏移，距离: 5）
// - Aim: Composer（将玩家构在画面中心）
```

---

### 瞄准摄像机（拉近）

```csharp
// 普通摄像机 (优先级 10):
//   - Distance: 5.0

// 瞄准摄像机 (优先级 5):
//   - Distance: 2.0
//   - FOV: 更窄

// 脚本:
void StartAiming() {
    aimCamera.Priority = 15; // 混合到瞄准摄像机
}
```

---

### 过场摄像机序列

```csharp
// 使用 Timeline:
// 1. 创建 Timeline (Assets > Create > Timeline)
// 2. 添加 Cinemachine Track
// 3. 将虚拟摄像机添加为剪辑
// 4. Timeline 自动在摄像机之间混合
```

---

## 从 Cinemachine 2.x 迁移（Unity 2021）

### API 变更（Unity 6 / Cinemachine 3.0）

```csharp
// ❌ 旧版（Cinemachine 2.x）:
CinemachineVirtualCamera vcam;
vcam.m_Follow = target;

// ✅ 新版（Cinemachine 3.0+）:
CinemachineCamera vcam;
vcam.Follow = target; // 更简洁的 API
```

**重大变更:**
- `CinemachineVirtualCamera` → `CinemachineCamera`
- `m_Follow`, `m_LookAt` → `Follow`, `LookAt`（无 "m_" 前缀）
- 组件已重命名以更清晰
- 更好的性能

---

## 性能提示

- 限制活动虚拟摄像机数量（仅在需要时激活）
- 使用低优先级摄像机而非销毁/创建
- 远离玩家时禁用虚拟摄像机

---

## 调试

### Cinemachine 调试

```csharp
// Window > Analysis > Cinemachine Debugger
// 显示活动摄像机、混合信息、镜头质量
```

---

## 来源
- https://docs.unity3d.com/Packages/com.unity.cinemachine@3.0/manual/index.html
- https://learn.unity.com/tutorial/cinemachine
