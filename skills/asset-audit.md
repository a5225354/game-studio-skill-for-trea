# Asset Audit — 资产审核技能

触发条件:
- 用户说"资源审计" / "asset audit" / "资源检查" / "资产检查"
- 用户指定了资产类别或 "all"

---

当用户触发此技能时:

## 1. 读取资产标准

读取项目命名约定和资产标准。

## 2. 扫描目标资产目录

- `assets/art/**/*` — 美术资产
- `assets/audio/**/*` — 音频资产
- `assets/vfx/**/*` — 视觉特效资产
- `assets/shaders/**/*` — 着色器
- `assets/data/**/*` — 数据文件

## 3. 检查命名约定

- 美术：`[category]_[name]_[variant]_[size].[ext]`
- 音频：`[category]_[context]_[name]_[variant].[ext]`
- 所有文件必须为小写，使用下划线分隔

## 4. 检查文件标准

- 纹理：2的幂次尺寸，格式正确
- 音频：采样率正确，格式正确
- 数据：有效的 JSON/YAML，符合 Schema

## 5. 检查孤立项

在代码中搜索对每个资产文件的引用，找出不被引用的孤立资产。

## 6. 检查缺失资产

在代码中搜索资产引用，验证文件是否存在。

## 7. 输出审核报告

```markdown
# Asset Audit Report -- [Category] -- [Date]

## Summary
- **Total assets scanned**: [N]
- **Naming violations**: [N]
- **Size violations**: [N]
- **Format violations**: [N]
- **Orphaned assets**: [N]
- **Missing assets**: [N]
- **Overall health**: [CLEAN / MINOR ISSUES / NEEDS ATTENTION]

## Naming Violations
| File | Expected Pattern | Issue |
|------|-----------------|-------|

## Orphaned Assets
| File | Last Modified | Size | Recommendation |
|------|-------------|------|---------------|

## Missing Assets
| Reference Location | Expected Path |
|-------------------|---------------|

## Recommendations
[Prioritized list of fixes]
```

## 协作协议

1. 扫描资产目录和代码引用
2. 对照标准检查
3. 展示完整审核报告
4. 只读模式 — 展示发现，不修改文件
