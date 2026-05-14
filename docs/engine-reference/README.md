# 引擎参考文档

本目录包含为项目中使用的游戏引擎精选的、版本锁定的文档快照。
这些文件存在的原因是**LLM 知识有截止日期**，而游戏引擎频繁更新。

## 为什么需要这个

AI 模型的训练数据有知识截止日期。
Godot、Unity 和 Unreal 等游戏引擎不断发布更新，引入破坏性 API 变更、
新功能和废弃的模式。如果没有这些参考文件，AI 角色会建议过时的代码。

## 结构

每个引擎有自己的目录：

```
<engine>/
├── VERSION.md              # 锁定版本、验证日期、知识缺口窗口
├── breaking-changes.md     # 版本间的 API 变更，按风险级别组织
├── deprecated-apis.md      # "不要用 X → 改用 Y" 查找表
├── current-best-practices.md  # 模型训练数据中没有的新实践
└── modules/                # 按子系统的快速参考（每个最多 ~150 行）
    ├── rendering.md
    ├── physics.md
    └── ...
```

## 引擎专家角色如何使用这些文件

引擎专家角色被指示执行：

1. 读取 `VERSION.md` 确认当前引擎版本
2. 在建议任何引擎 API 之前检查 `deprecated-apis.md`
3. 查阅 `breaking-changes.md` 了解版本特定问题
4. 读取相关的 `modules/*.md` 进行子系统特定工作

## 维护

### 何时更新

- 升级引擎版本后
- AI 模型更新后（新的知识截止日期）
- 发现模型弄错的 API 时

### 如何更新

1. 在 `VERSION.md` 中更新新的引擎版本和日期
2. 为版本过渡在 `breaking-changes.md` 中添加新条目
3. 将新废弃的 API 移入 `deprecated-apis.md`
4. 用新模式更新 `current-best-practices.md`
5. 用 API 变更更新相关的 `modules/*.md`
6. 在所有修改的文件上设置"最后验证"日期

### 质量规则

- 每个文件必须有"最后验证：YYYY-MM-DD"日期
- 保持模块文件在 150 行以内（上下文预算）
- 包含代码示例展示正确/错误模式
- 链接到官方文档 URL 以供验证
- 只记录与模型训练数据不同的内容
