# Godot 音频 — 快速参考

最后验证：2026-02-12 | 引擎：Godot 4.6

## 自 ~4.3 以来的变更（LLM 截止后）

4.4–4.6 中音频 API 没有重大破坏性变更。核心音频系统
保持稳定。主要更新为工作流改进：

### 4.6 变更
- **本次发布无音频特定的破坏性变更**

### 4.5 变更
- **本次发布无音频特定的破坏性变更**

## 当前 API 模式

### 播放音频
```gdscript
@onready var sfx_player: AudioStreamPlayer = %SFXPlayer
@onready var music_player: AudioStreamPlayer = %MusicPlayer

func play_sfx(stream: AudioStream) -> void:
    sfx_player.stream = stream
    sfx_player.play()

func play_music(stream: AudioStream, fade_time: float = 1.0) -> void:
    var tween: Tween = create_tween()
    tween.tween_property(music_player, "volume_db", -80.0, fade_time)
    await tween.finished
    music_player.stream = stream
    music_player.volume_db = 0.0
    music_player.play()
```

### 3D 空间音频
```gdscript
@onready var audio_3d: AudioStreamPlayer3D = %AudioPlayer3D

func _ready() -> void:
    audio_3d.max_distance = 50.0
    audio_3d.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
    audio_3d.unit_size = 10.0
```

### 音频总线
```gdscript
# 设置总线音量
AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), volume_db)
AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"SFX"), volume_db)

# 静音总线
AudioServer.set_bus_mute(AudioServer.get_bus_index(&"Music"), true)
```

### 音效对象池
```gdscript
# 预创建多个 AudioStreamPlayer 节点用于并发声音
var _sfx_pool: Array[AudioStreamPlayer] = []

func _ready() -> void:
    for i in range(8):
        var player := AudioStreamPlayer.new()
        player.bus = &"SFX"
        add_child(player)
        _sfx_pool.append(player)

func play_pooled(stream: AudioStream) -> void:
    for player in _sfx_pool:
        if not player.playing:
            player.stream = stream
            player.play()
            return
```

## 常见错误
- 在运行时创建新的 AudioStreamPlayer 节点而非使用对象池
- 未使用音频总线进行音量分类（音乐、音效、UI、语音）
- 使用 `_process()` 处理音频计时而非使用信号（`finished`）
