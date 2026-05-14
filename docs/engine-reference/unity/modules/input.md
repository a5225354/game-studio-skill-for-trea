# Unity 6.3 — 输入模块参考

**最后验证:** 2026-02-13
**知识差距:** Unity 6 使用新 Input System（旧版 Input 已弃用）

---

## 概述

Unity 6 输入系统:
- **Input System 包**（推荐）: 跨平台、可重新绑定、现代化
- **旧版 Input Manager**: 已弃用，新项目避免使用

---

## 与 2022 LTS 的主要变更

### 旧版 Input 在 Unity 6 中已弃用

```csharp
// ❌ 已弃用: Input 类
if (Input.GetKeyDown(KeyCode.Space)) { }

// ✅ 新版: Input System 包
using UnityEngine.InputSystem;
if (Keyboard.current.spaceKey.wasPressedThisFrame) { }
```

**迁移要求:** 安装 `com.unity.inputsystem` 包。

---

## Input System 包设置

### 安装
1. `Window > Package Manager`
2. 搜索 "Input System"
3. 安装包
4. 提示时重启 Unity

### 启用新 Input System
`Edit > Project Settings > Player > Active Input Handling`:
- **Input System Package (New)** ✅ 推荐
- **Both**（迁移期间使用）

---

## Input Actions（推荐模式）

### 创建 Input Actions 资源

1. `Assets > Create > Input Actions`
2. 命名（如 "PlayerControls"）
3. 打开资源，定义动作:

```
Action Maps:
  Gameplay
    Actions:
      - Move (Value, Vector2)
      - Jump (Button)
      - Fire (Button)
      - Look (Value, Vector2)
```

4. **生成 C# 类**: 在 Inspector 中勾选 "Generate C# Class"
5. 点击 "Apply"

### 使用生成的 Input 类

```csharp
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour {
    private PlayerControls controls;

    void Awake() {
        controls = new PlayerControls();

        // 订阅动作
        controls.Gameplay.Jump.performed += ctx => Jump();
        controls.Gameplay.Fire.performed += ctx => Fire();
    }

    void OnEnable() => controls.Enable();
    void OnDisable() => controls.Disable();

    void Update() {
        // 读取持续输入
        Vector2 move = controls.Gameplay.Move.ReadValue<Vector2>();
        transform.Translate(new Vector3(move.x, 0, move.y) * Time.deltaTime);

        Vector2 look = controls.Gameplay.Look.ReadValue<Vector2>();
        // 应用摄像机旋转
    }

    void Jump() {
        Debug.Log("Jump!");
    }

    void Fire() {
        Debug.Log("Fire!");
    }
}
```

---

## 直接设备访问（快速方式）

### 键盘

```csharp
using UnityEngine.InputSystem;

void Update() {
    // 当前状态
    if (Keyboard.current.spaceKey.isPressed) { }

    // 本帧刚按下
    if (Keyboard.current.spaceKey.wasPressedThisFrame) { }

    // 本帧刚松开
    if (Keyboard.current.spaceKey.wasReleasedThisFrame) { }
}
```

### 鼠标

```csharp
using UnityEngine.InputSystem;

void Update() {
    // 鼠标位置
    Vector2 mousePos = Mouse.current.position.ReadValue();

    // 鼠标增量（移动量）
    Vector2 mouseDelta = Mouse.current.delta.ReadValue();

    // 鼠标按钮
    if (Mouse.current.leftButton.wasPressedThisFrame) { }
    if (Mouse.current.rightButton.isPressed) { }

    // 滚轮
    Vector2 scroll = Mouse.current.scroll.ReadValue();
}
```

### 手柄

```csharp
using UnityEngine.InputSystem;

void Update() {
    Gamepad gamepad = Gamepad.current;
    if (gamepad == null) return; // 没有连接手柄

    // 按钮
    if (gamepad.buttonSouth.wasPressedThisFrame) { } // A/Cross
    if (gamepad.buttonWest.wasPressedThisFrame) { }  // X/Square

    // 摇杆
    Vector2 leftStick = gamepad.leftStick.ReadValue();
    Vector2 rightStick = gamepad.rightStick.ReadValue();

    // 扳机
    float leftTrigger = gamepad.leftTrigger.ReadValue();
    float rightTrigger = gamepad.rightTrigger.ReadValue();

    // 方向键
    Vector2 dpad = gamepad.dpad.ReadValue();
}
```

### 触摸（移动端）

```csharp
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.EnhancedTouch;

void OnEnable() {
    EnhancedTouchSupport.Enable();
}

void Update() {
    foreach (var touch in UnityEngine.InputSystem.EnhancedTouch.Touch.activeTouches) {
        Debug.Log($"触摸位置: {touch.screenPosition}");
    }
}
```

---

## Input Action 回调

### 动作回调（事件驱动）

```csharp
// started: 输入开始（如扳机轻微按下）
controls.Gameplay.Fire.started += ctx => Debug.Log("Fire started");

// performed: 输入动作触发（如按钮完全按下）
controls.Gameplay.Fire.performed += ctx => Debug.Log("Fire performed");

// canceled: 输入释放或中断
controls.Gameplay.Fire.canceled += ctx => Debug.Log("Fire canceled");
```

### 上下文数据 (Context Data)

```csharp
controls.Gameplay.Move.performed += ctx => {
    Vector2 value = ctx.ReadValue<Vector2>();
    float duration = ctx.duration; // 输入持续时长
    InputControl control = ctx.control; // 哪个设备/控件触发的
};
```

---

## 控制方案与设备切换

### 在 Input Actions 资源中定义控制方案

```
Control Schemes:
  - Keyboard&Mouse (Keyboard, Mouse)
  - Gamepad (Gamepad)
  - Touch (Touchscreen)
```

### 设备变更时自动切换

```csharp
controls.Gameplay.Move.performed += ctx => {
    if (ctx.control.device is Keyboard) {
        Debug.Log("使用键盘");
    } else if (ctx.control.device is Gamepad) {
        Debug.Log("使用手柄");
    }
};
```

---

## 重新绑定（运行时按键映射）

### 交互式重新绑定

```csharp
using UnityEngine.InputSystem;

public void RebindJumpKey() {
    var rebindOperation = controls.Gameplay.Jump.PerformInteractiveRebinding()
        .WithControlsExcluding("Mouse") // 排除鼠标绑定
        .OnComplete(operation => {
            Debug.Log("重新绑定完成");
            operation.Dispose();
        })
        .Start();
}
```

### 保存/加载绑定

```csharp
// 保存
string rebinds = controls.SaveBindingOverridesAsJson();
PlayerPrefs.SetString("InputBindings", rebinds);

// 加载
string rebinds = PlayerPrefs.GetString("InputBindings");
controls.LoadBindingOverridesFromJson(rebinds);
```

---

## 动作类型

### Button（按下/释放）
- 单次按下/释放
- 示例: 跳跃、开火

### Value（连续值）
- 连续值（float、Vector2）
- 示例: 移动、视角、瞄准

### Pass-Through（即时传递）
- 无处理，即时值
- 示例: 鼠标位置

---

## 处理器（输入修饰器）

### Scale（缩放）

```csharp
// 在 Input Actions 资源中: Action > Properties > Processors > Add > Scale
// 将输入值乘以系数（如反转 Y 轴）
```

### Invert（反转）

```csharp
// 在 Input Actions 资源中: Action > Properties > Processors > Add > Invert
// 翻转输入符号
```

### Dead Zone（死区）

```csharp
// 在 Input Actions 资源中: Action > Properties > Processors > Add > Stick Deadzone
// 忽略摇杆的小幅移动
```

---

## PlayerInput 组件（简化设置）

### 自动输入设置

```csharp
// 添加组件: Player Input
// 指定 Input Actions 资源
// 行为: Send Messages / Invoke Unity Events / Invoke C# Events

// Send Messages 示例:
public class Player : MonoBehaviour {
    public void OnMove(InputValue value) {
        Vector2 move = value.Get<Vector2>();
        // 处理移动
    }

    public void OnJump(InputValue value) {
        if (value.isPressed) {
            Jump();
        }
    }
}
```

---

## 调试

### Input Debugger
- `Window > Analysis > Input Debugger`
- 查看活动设备、输入值、动作状态

---

## 来源
- https://docs.unity3d.com/Packages/com.unity.inputsystem@1.11/manual/index.html
- https://docs.unity3d.com/Packages/com.unity.inputsystem@1.11/manual/QuickStartGuide.html
