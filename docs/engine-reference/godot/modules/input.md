# Godot 输入 — 快速参考

最后验证：2026-02-12 | 引擎：Godot 4.6

## 自 ~4.3 以来的变更（LLM 截止后）

### 4.6 变更
- **双焦点系统**：鼠标/触摸焦点现在与键盘/手柄焦点分离
  - 不同输入方式的视觉反馈不同
  - 自定义焦点实现可能需要更新
- **选择模式快捷键变更**："选择模式"现在为 `v` 键；旧模式重命名为"变换模式"（`q` 键）

### 4.5 变更
- **SDL3 手柄驱动**：手柄处理委托给 SDL 库，实现更好的跨平台支持
- **递归 Control 禁用**：单一属性禁用整个节点层级的鼠标/焦点交互

### 4.3 变更（在训练数据中）
- **InputEventShortcut**：专用于菜单快捷键的事件类型（可选）

## 当前 API 模式

### 输入动作（未变更）
```gdscript
func _physics_process(delta: float) -> void:
    var input_dir: Vector2 = Input.get_vector(
        &"move_left", &"move_right", &"move_forward", &"move_back"
    )
    if Input.is_action_just_pressed(&"jump"):
        jump()
```

### 输入事件（未变更）
```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            handle_click(event.position)
    elif event is InputEventKey:
        if event.keycode == KEY_ESCAPE and event.pressed:
            toggle_pause()
```

### 焦点管理（4.6 — 已变更）
```gdscript
# 鼠标/触摸和键盘/手柄焦点现在是分离的
# 视觉样式可能因活跃的输入方式而异
# 如果你有自定义焦点绘制，请使用两种输入方式进行测试

# 标准方式仍然有效：
func _ready() -> void:
    %StartButton.grab_focus()  # 键盘/手柄焦点

# 但请注意：在 4.6 中鼠标悬停焦点 != 键盘焦点
```

### 手柄（4.5+ — SDL3 后端）
```gdscript
# API 未变，但 SDL3 提供：
# - 更好的跨平台设备检测
# - 改进的震动支持
# - 更一致的面键映射

func _input(event: InputEvent) -> void:
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            confirm_selection()
```

## 常见错误
- 未测试鼠标和键盘焦点路径（4.6 双焦点系统）
- 假设 `grab_focus()` 会影响鼠标焦点（4.6 中仅影响键盘/手柄）
- 在热路径中使用字符串字面量而非 `StringName`（`&"action"`）作为动作名
