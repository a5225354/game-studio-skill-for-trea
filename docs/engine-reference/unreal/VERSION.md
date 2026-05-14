# Unreal Engine — 版本参考

| 字段 | 值 |
|-------|-------|
| **引擎版本** | Unreal Engine 5.7 |
| **发布日期** | 2025 年 11 月 |
| **项目锁定日期** | 2026-02-13 |
| **文档最后验证** | 2026-02-13 |
| **LLM 知识截止日期** | 2025 年 5 月 |

## 知识缺口警告

LLM 的训练数据可能仅覆盖 Unreal Engine 至约 5.3 版本。5.4、5.5、5.6 和 5.7 版本引入了重大变更，模型并不了解这些内容。在建议 Unreal API 调用前，务必交叉参考本目录。

## 知识截止后的版本时间线

| 版本 | 发布时间 | 风险等级 | 主要主题 |
|---------|---------|------------|-----------|
| 5.4 | ~2025 年中 | 高 | Motion Design 工具、动画改进、PCG 增强 |
| 5.5 | ~2025 年 9 月 | 高 | Megalights（百万级光源）、动画创作、MegaCity 演示 |
| 5.6 | ~2025 年 10 月 | 中 | 性能优化、错误修复 |
| 5.7 | 2025 年 11 月 | 高 | PCG 生产就绪、Substrate 生产就绪、AI 助手 |

## 从 UE 5.3 到 UE 5.7 的主要变更

### 破坏性变更 (Breaking Changes)
- **Substrate 材质系统**：新的材质框架（替代旧版材质）
- **PCG（程序化内容生成，Procedural Content Generation）**：生产就绪，重大 API 变更
- **Megalights**：新的光照系统（百万级动态光源）
- **动画创作 (Animation Authoring)**：新的绑定和动画工具
- **AI 助手**：编辑器内 AI 指导（实验性）

### 新特性（知识截止后）
- **Megalights**：大规模动态光照（百万级光源）
- **Substrate 材质**：生产就绪的模块化材质系统
- **PCG 框架**：程序化世界生成（5.7 生产就绪）
- **增强虚拟制片 (Enhanced Virtual Production)**：MetaHuman 集成，更深入的 VP 工作流
- **动画改进**：更好的绑定、混合、程序化动画
- **AI 助手**：编辑器内 AI 帮助（实验性）

### 已弃用系统
- **旧版材质系统**：新项目请迁移到 Substrate
- **旧版 PCG API**：请使用新的生产就绪 PCG API（5.7+）

## 已验证来源

- 官方文档：https://docs.unrealengine.com/5.7/
- UE 5.7 发行说明：https://dev.epicgames.com/documentation/en-us/unreal-engine/unreal-engine-5-7-release-notes
- 5.7 新功能：https://dev.epicgames.com/documentation/en-us/unreal-engine/whats-new
- UE 5.7 公告：https://www.unrealengine.com/en-US/news/unreal-engine-5-7-is-now-available
- UE 5.5 博客：https://www.unrealengine.com/en-US/blog/unreal-engine-5-5-is-now-available
- 迁移指南：https://docs.unrealengine.com/5.7/en-US/upgrading-projects/
