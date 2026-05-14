# Godot UI — 快速参考

最后验证：2026-02-12 | 引擎：Godot 4.6

## 自 ~4.3 以来的变更（LLM 截止后）

### 4.6 变更
- **双焦点系统**：鼠标/触摸焦点现在与键盘/手柄焦点**分离**
  - 不同输入方式的视觉反馈不同
  - 自定义焦点实现可能需要更新
- **TabContainer**：标签页属性可直接在检查器中编辑
- **TileMapLayer 场景瓦片旋转**：场景瓦片现在可以像图集瓦片一样旋转

### 4.5 变更
- **FoldableContainer**：新手风琴式 UI 节点，用于可折叠区域
- **递归 Control 行为**：通过单一属性禁用整个节点层级的鼠标/焦点交互
- **屏幕阅读器支持**：Control 节点通过 AccessKit 与辅助工具配合
- **实时翻译预览**：在编辑器中测试不同语言环境
- **`RichTextLabel.push_meta`**：新增可选 `tooltip` 参数（来自 4.4）

### 4.4 变更
- **`GraphEdit.connect_node`**：新增可选 `keep_alive` 参数

## 当前 API 模式

### 主题与样式（4.6）
```gdscript
# 编辑器默认使用新的"现代"主题
# 游戏UI仍像以前一样使用自定义主题：
var theme := Theme.new()
theme.set_color(&"font_color", &"Label", Color.WHITE)
theme.set_font_size(&"font_size", &"Label", 24)
```

### 焦点管理（4.6 — 已变更）
```gdscript
# 键盘/手柄焦点（grab_focus 仍然有效）
func _ready() -> void:
    %StartButton.grab_focus()

# 重要：在 4.6 中，鼠标悬停与键盘焦点是分离的
# 两者可以同时在不同控件上活跃
# 请使用鼠标和键盘/手柄**两种**方式测试你的 UI

# 焦点邻居（未变更）
%Button1.focus_neighbor_bottom = %Button2.get_path()
%Button1.focus_neighbor_right = %Button3.get_path()
```

### FoldableContainer（4.5 — 新增）
```gdscript
# 手风琴式可折叠容器
# 添加为要实现可折叠内容区域的父节点
# 子节点在点击标题时显示/隐藏
# 通过编辑器属性或代码配置
```

### 递归禁用（4.5 — 新增）
```gdscript
# 禁用整个层级的所有鼠标/焦点交互
# 适用于禁用整个菜单区域
%SettingsPanel.mouse_filter = Control.MOUSE_FILTER_IGNORE
# 在 4.5+ 中，这可以递归传播到子节点
```

### 本地化就绪 UI（最佳实践）
```gdscript
# 对所有可见字符串使用 tr()
label.text = tr("MENU_START_GAME")

# 对标签使用自动换行（文本长度因语言而异）
label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

# 在编辑器中使用实时翻译预览进行测试（4.5+）
```

## 常见错误
- 假设 `grab_focus()` 会影响鼠标焦点（4.6 中仅影响键盘/手柄）
- 升级到 4.6 后未使用鼠标和手柄两种方式测试 UI
- 硬编码字符串而非使用 `tr()` 进行本地化
- 未使用 `FoldableContainer` 实现可折叠 UI（4.5 新增，比自定义方案更简洁）
