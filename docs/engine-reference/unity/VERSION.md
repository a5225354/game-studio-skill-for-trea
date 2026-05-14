# Unity 引擎 — 版本参考

| 字段 | 值 |
|-------|-------|
| **引擎版本** | Unity 6.3 LTS |
| **发布日期** | 2025 年 12 月 |
| **项目锁定日期** | 2026-02-13 |
| **文档最后验证** | 2026-02-13 |
| **LLM 知识截止日期** | 2025 年 5 月 |

## 知识差距警告

LLM 的训练数据可能仅覆盖到 Unity ~2022 LTS (2022.3)。整个 Unity 6 系列（前身为 Unity 2023 技术流）引入了重大变更，模型并不知晓。在建议 Unity API 调用之前，务必交叉参考本目录。

## 截止日期后的版本时间线

| 版本 | 发布 | 风险等级 | 主要主题 |
|---------|---------|------------|-----------|
| 6.0 | 2024 年 10 月 | 高 | Unity 6 品牌重塑、新渲染功能、Entities 1.3、DOTS 改进 |
| 6.1 | 2024 年 11 月 | 中 | Bug 修复、稳定性改进 |
| 6.2 | 2024 年 12 月 | 中 | 性能优化、新输入系统改进 |
| 6.3 LTS | 2025 年 12 月 | 高 | 6.0 以来首个 LTS 版本、生产就绪的 DOTS、增强的图形功能 |

## 从 2022 LTS 到 Unity 6.3 LTS 的重大变更

### 破坏性变更
- **Entities/DOTS**: Entities 1.0+ 的大规模 API 重构，ECS 模式完全重新设计
- **输入系统**: 旧版 Input Manager 已弃用，新 Input System 成为默认
- **渲染**: URP/HDRP 重大升级，SRP Batcher 改进
- **Addressables**: 资源管理工作流变更
- **脚本**: C# 9 支持，新 API 模式

### 新功能（截止日期后）
- **DOTS**: 生产就绪的 Entity Component System (Entities 1.3+)
- **图形**: 增强的 URP/HDRP 管线、GPU Resident Drawer
- **多人游戏**: Netcode for GameObjects 改进
- **UI Toolkit**: 运行时 UI 生产就绪（替代 UGUI 用于新项目）
- **异步资源加载**: 改进的 Addressables 性能
- **Web**: WebGPU 支持

### 已弃用系统
- **旧版 Input Manager**: 使用新 Input System 包
- **旧版粒子系统**: 使用 Visual Effect Graph
- **UGUI**: 仍然支持，但推荐 UI Toolkit 用于新项目
- **旧版 ECS (GameObjectEntity)**: 被现代 DOTS/Entities 替代

## 已验证来源

- 官方文档: https://docs.unity3d.com/6000.0/Documentation/Manual/index.html
- Unity 6 发布: https://unity.com/releases/unity-6
- Unity 6.3 LTS 公告: https://unity.com/blog/unity-6-3-lts-is-now-available
- 迁移指南: https://docs.unity3d.com/6000.0/Documentation/Manual/upgrade-guides.html
- Unity 6 支持: https://unity.com/releases/unity-6/support
- C# API 参考: https://docs.unity3d.com/6000.0/Documentation/ScriptReference/index.html
