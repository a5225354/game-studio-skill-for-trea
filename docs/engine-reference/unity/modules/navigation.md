# Unity 6.3 — 导航模块参考

**最后验证:** 2026-02-13
**知识差距:** Unity 6 NavMesh 改进

---

## 概述

Unity 6 导航系统:
- **NavMesh**: 内置 AI 寻路系统
- **NavMeshComponents**: 运行时 NavMesh 构建包

---

## NavMesh 基础

### 烘焙导航网格

1. 标记可行走表面:
   - 选择 GameObject（地板/地形）
   - Inspector > Navigation > Object 选项卡
   - 勾选 "Navigation Static"

2. 烘焙 NavMesh:
   - `Window > AI > Navigation`
   - Bake 选项卡
   - 点击 "Bake"

3. 配置设置:
   - **Agent Radius**: 代理宽度（默认 0.5m）
   - **Agent Height**: 代理高度（默认 2m）
   - **Max Slope**: 最大可行走坡度（默认 45°）
   - **Step Height**: 最大可攀爬台阶高度（默认 0.4m）

---

## NavMeshAgent（AI 移动）

### 基本代理设置

```csharp
using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour {
    private NavMeshAgent agent;
    public Transform target;

    void Start() {
        agent = GetComponent<NavMeshAgent>();
    }

    void Update() {
        // ✅ 移动到目标
        agent.SetDestination(target.position);
    }
}
```

---

### NavMeshAgent 属性

```csharp
NavMeshAgent agent = GetComponent<NavMeshAgent>();

// 速度
agent.speed = 3.5f;

// 加速度
agent.acceleration = 8f;

// 停止距离
agent.stoppingDistance = 2f; // 距目的地 2m 处停止

// 自动刹车（到达目的地时减速）
agent.autoBraking = true;

// 旋转速度
agent.angularSpeed = 120f; // 度/秒

// 障碍物规避
agent.obstacleAvoidanceType = ObstacleAvoidanceType.HighQualityObstacleAvoidance;
```

---

### 检查路径状态

```csharp
void Update() {
    agent.SetDestination(target.position);

    // 检查代理是否有路径
    if (agent.hasPath) {
        // 检查路径是否完整
        if (agent.pathStatus == NavMeshPathStatus.PathComplete) {
            Debug.Log("有效路径");
        } else if (agent.pathStatus == NavMeshPathStatus.PathPartial) {
            Debug.Log("部分路径（目的地不可达）");
        } else {
            Debug.Log("无效路径");
        }
    }

    // 检查代理是否到达目的地
    if (!agent.pathPending && agent.remainingDistance <= agent.stoppingDistance) {
        Debug.Log("已到达目的地");
    }
}
```

---

### 计算路径（暂不移动）

```csharp
NavMeshPath path = new NavMeshPath();
agent.CalculatePath(targetPosition, path);

if (path.status == NavMeshPathStatus.PathComplete) {
    // 存在有效路径
    agent.SetPath(path); // 应用路径
}
```

---

## NavMesh 区域（可行走代价）

### 定义区域
`Window > AI > Navigation > Areas 选项卡`
- **Walkable**: 代价 1（默认）
- **Not Walkable**: 不可行走
- **Jump**: 代价 2（优先选择其他路线）
- **自定义**: 定义你自己的区域

### 分配区域代价

```csharp
// 优先选择较短路径而非低代价路径
agent.areaMask = NavMesh.AllAreas; // 在所有区域上行走

// 仅在 "Walkable" 区域上行走（避免 "Jump"）
agent.areaMask = 1 << NavMesh.GetAreaFromName("Walkable");
```

---

## NavMesh 障碍物（动态障碍物）

### NavMeshObstacle 组件

```csharp
// 添加: GameObject > Add Component > NavMesh Obstacle

// Carve: 在 NavMesh 中创建洞（代理会绕行）
// Don't Carve: 代理会被推开（局部规避）
```

### 动态雕刻（移动障碍物）

```csharp
NavMeshObstacle obstacle = GetComponent<NavMeshObstacle>();
obstacle.carving = true; // 在 NavMesh 中创建动态洞
```

---

## Off-Mesh Link（跳跃、传送）

### 创建 Off-Mesh Link

1. `GameObject > Create Empty`（在跳跃起点）
2. 添加 `Off Mesh Link` 组件
3. 设置起始/结束 Transform
4. 配置:
   - **Bi-Directional**: 可双向穿越
   - **Cost Override**: 该链接的路径代价

### 检测 Off-Mesh Link 穿越

```csharp
void Update() {
    // 检查代理是否在 off-mesh link 上
    if (agent.isOnOffMeshLink) {
        // 手动穿越（如播放跳跃动画）
        StartCoroutine(TraverseOffMeshLink());
    }
}

IEnumerator TraverseOffMeshLink() {
    OffMeshLinkData data = agent.currentOffMeshLinkData;
    Vector3 startPos = agent.transform.position;
    Vector3 endPos = data.endPos;

    float duration = 0.5f;
    float elapsed = 0f;

    while (elapsed < duration) {
        agent.transform.position = Vector3.Lerp(startPos, endPos, elapsed / duration);
        elapsed += Time.deltaTime;
        yield return null;
    }

    agent.CompleteOffMeshLink(); // 恢复正常寻路
}
```

---

## NavMeshComponents 包（运行时烘焙）

### 安装
1. `Window > Package Manager`
2. 从 Git URL 添加: `com.unity.ai.navigation`

### 运行时 NavMesh 烘焙

```csharp
using Unity.AI.Navigation;

public class NavMeshBuilder : MonoBehaviour {
    public NavMeshSurface surface;

    void Start() {
        // 在运行时烘焙 NavMesh
        surface.BuildNavMesh();
    }

    void UpdateNavMesh() {
        // 地形变更后更新 NavMesh
        surface.UpdateNavMesh(surface.navMeshData);
    }
}
```

---

## 常用模式

### 在路点之间巡逻

```csharp
public Transform[] waypoints;
private int currentWaypoint = 0;

void Update() {
    if (!agent.pathPending && agent.remainingDistance < 0.5f) {
        // 到达路点，移动到下一个
        currentWaypoint = (currentWaypoint + 1) % waypoints.Length;
        agent.SetDestination(waypoints[currentWaypoint].position);
    }
}
```

### 追逐玩家

```csharp
public Transform player;
public float chaseRange = 10f;

void Update() {
    float distance = Vector3.Distance(transform.position, player.position);

    if (distance <= chaseRange) {
        agent.SetDestination(player.position);
    } else {
        agent.ResetPath(); // 停止移动
    }
}
```

### 逃离玩家

```csharp
public Transform player;
public float fleeRange = 5f;

void Update() {
    float distance = Vector3.Distance(transform.position, player.position);

    if (distance <= fleeRange) {
        // 远离玩家逃跑
        Vector3 fleeDirection = transform.position - player.position;
        Vector3 fleeTarget = transform.position + fleeDirection.normalized * 10f;

        agent.SetDestination(fleeTarget);
    }
}
```

---

## 调试

### NavMesh 可视化
- `Window > AI > Navigation > Bake 选项卡`
- 勾选 "Show NavMesh" 可视化可行走区域

### 代理路径 Gizmos

```csharp
void OnDrawGizmos() {
    if (agent != null && agent.hasPath) {
        Gizmos.color = Color.green;
        Vector3[] corners = agent.path.corners;

        for (int i = 0; i < corners.Length - 1; i++) {
            Gizmos.DrawLine(corners[i], corners[i + 1]);
        }
    }
}
```

---

## 性能提示

- **限制障碍物规避质量**: 远距离代理使用 `LowQualityObstacleAvoidance`
- **更新频率**: 如果目标未移动，不要每帧调用 `SetDestination()`
- **区域遮罩**: 限制可行走区域以缩小寻路搜索空间
- **NavMesh 分块**: 大世界使用分块 NavMesh（NavMeshComponents 包）

---

## 来源
- https://docs.unity3d.com/6000.0/Documentation/Manual/Navigation.html
- https://docs.unity3d.com/Packages/com.unity.ai.navigation@2.0/manual/index.html
