# Unity 6.3 — DOTS / Entities (ECS)

**最后验证:** 2026-02-13
**状态:** 生产就绪（Entities 1.3+，Unity 6.3 LTS）
**包:** `com.unity.entities` (Package Manager)

---

## 概述

**DOTS (Data-Oriented Technology Stack, 面向数据技术栈)** 是 Unity 的高性能 ECS (Entity Component System, 实体组件系统) 框架。专为大规模场景（数千至数万个实体）的游戏设计。

**适用场景:**
- 即时战略游戏（数千个单位）
- 模拟（人群、交通、物理）
- 程序化内容生成
- 性能关键系统

**不适用场景:**
- 小型游戏（开销不值得）
- 需要频繁结构性变更的游戏逻辑
- 大量使用 UnityEngine API 的项目（MonoBehaviour 更简单）

**⚠️ 知识差距:** Entities 1.0+ (Unity 6) 是从 0.x 的完全重写。
许多 Entities 0.x 的教程现已过时。

---

## 安装

### 通过 Package Manager 安装

1. `Window > Package Manager`
2. Unity Registry > 搜索 "Entities"
3. 安装:
   - `Entities`（ECS 核心）
   - `Burst`（LLVM 编译器）
   - `Jobs`（自动安装）
   - `Mathematics`（SIMD 数学库）

---

## 核心概念

### 1. **Entity (实体)**
- 轻量级 ID (int)
- 无行为，仅是一个标识符

### 2. **Component (组件)**
- 仅包含数据（无方法）
- 实现 `IComponentData` 的结构体

### 3. **System (系统)**
- 操作组件的逻辑
- 实现 `ISystem` 的结构体

### 4. **Archetype (原型)**
- 组件类型的唯一组合
- 拥有相同组件的实体共享原型

---

## 基本 ECS 模式

### 定义组件

```csharp
using Unity.Entities;
using Unity.Mathematics;

// ✅ 组件: 仅包含数据，无方法
public struct Position : IComponentData {
    public float3 Value;
}

public struct Velocity : IComponentData {
    public float3 Value;
}
```

---

### 定义系统

```csharp
using Unity.Entities;
using Unity.Burst;

// ✅ 系统: 处理实体的逻辑
[BurstCompile]
public partial struct MovementSystem : ISystem {
    [BurstCompile]
    public void OnUpdate(ref SystemState state) {
        float deltaTime = SystemAPI.Time.DeltaTime;

        // 查询所有拥有 Position + Velocity 的实体
        foreach (var (transform, velocity) in
            SystemAPI.Query<RefRW<Position>, RefRO<Velocity>>()) {

            transform.ValueRW.Value += velocity.ValueRO.Value * deltaTime;
        }
    }
}
```

---

### 创建实体

```csharp
using Unity.Entities;
using Unity.Mathematics;

public partial class EntitySpawner : SystemBase {
    protected override void OnUpdate() {
        var em = EntityManager;

        // 创建实体
        Entity entity = em.CreateEntity();

        // 添加组件
        em.AddComponentData(entity, new Position { Value = float3.zero });
        em.AddComponentData(entity, new Velocity { Value = new float3(1, 0, 0) });
    }
}
```

---

## 混合 ECS（MonoBehaviour + ECS）

### Baker（将 GameObject 转换为 Entity）

```csharp
using Unity.Entities;
using UnityEngine;

public class PlayerAuthoring : MonoBehaviour {
    public float speed;
}

public class PlayerBaker : Baker<PlayerAuthoring> {
    public override void Bake(PlayerAuthoring authoring) {
        var entity = GetEntity(TransformUsageFlags.Dynamic);

        AddComponent(entity, new Position { Value = authoring.transform.position });
        AddComponent(entity, new Velocity { Value = new float3(authoring.speed, 0, 0) });
    }
}
```

**工作原理:**
1. 在编辑器中将 `PlayerAuthoring` 添加到 GameObject
2. Baker 在运行时自动转换为 Entity
3. Entity 拥有 Position + Velocity 组件

---

## 查询 (Queries)

### 查询所有拥有特定组件的实体

```csharp
foreach (var (position, velocity) in
    SystemAPI.Query<RefRW<Position>, RefRO<Velocity>>()) {

    position.ValueRW.Value += velocity.ValueRO.Value * deltaTime;
}
```

---

### 带实体访问的查询

```csharp
foreach (var (position, velocity, entity) in
    SystemAPI.Query<RefRW<Position>, RefRO<Velocity>>().WithEntityAccess()) {

    // 访问实体 ID
    Debug.Log($"实体: {entity}");
}
```

---

### 带过滤器的查询

```csharp
// 仅查询带有 "Enemy" 标签的实体
foreach (var position in
    SystemAPI.Query<RefRW<Position>>().WithAll<EnemyTag>()) {
    // 仅处理敌人
}
```

---

## Jobs（并行执行）

### IJobEntity（并行遍历）

```csharp
using Unity.Entities;
using Unity.Burst;

[BurstCompile]
public partial struct MovementJob : IJobEntity {
    public float DeltaTime;

    // Execute 为每个实体并行运行
    void Execute(ref Position position, in Velocity velocity) {
        position.Value += velocity.Value * DeltaTime;
    }
}

[BurstCompile]
public partial struct MovementSystem : ISystem {
    public void OnUpdate(ref SystemState state) {
        var job = new MovementJob {
            DeltaTime = SystemAPI.Time.DeltaTime
        };
        job.ScheduleParallel(); // 并行执行
    }
}
```

---

## Burst Compiler（性能）

### 启用 Burst

```csharp
using Unity.Burst;

[BurstCompile] // 比常规 C# 快 10-100 倍
public partial struct MySystem : ISystem {
    [BurstCompile]
    public void OnUpdate(ref SystemState state) {
        // Burst 编译的代码
    }
}
```

**Burst 限制:**
- 不允许托管引用（类、字符串等）
- 仅允许 Blittable 类型（结构体、基本类型、Unity.Mathematics 类型）
- 不允许异常

---

## Entity Command Buffer（结构变更）

### 延迟结构变更

```csharp
using Unity.Entities;

public partial struct SpawnSystem : ISystem {
    public void OnUpdate(ref SystemState state) {
        var ecb = new EntityCommandBuffer(Allocator.Temp);

        // 延迟实体创建（迭代期间不修改）
        foreach (var spawner in SystemAPI.Query<Spawner>()) {
            Entity newEntity = ecb.CreateEntity();
            ecb.AddComponent(newEntity, new Position { Value = spawner.SpawnPos });
        }

        ecb.Playback(state.EntityManager); // 应用变更
        ecb.Dispose();
    }
}
```

---

## Dynamic Buffer（类数组组件）

### 定义 Dynamic Buffer

```csharp
public struct PathWaypoint : IBufferElementData {
    public float3 Position;
}
```

### 使用 Dynamic Buffer

```csharp
// 为实体添加 Buffer
var buffer = EntityManager.AddBuffer<PathWaypoint>(entity);
buffer.Add(new PathWaypoint { Position = new float3(0, 0, 0) });
buffer.Add(new PathWaypoint { Position = new float3(10, 0, 0) });

// 查询 Buffer
foreach (var buffer in SystemAPI.Query<DynamicBuffer<PathWaypoint>>()) {
    foreach (var waypoint in buffer) {
        Debug.Log(waypoint.Position);
    }
}
```

---

## Tags（零大小组件）

### 定义 Tag

```csharp
public struct EnemyTag : IComponentData { } // 空组件 = 标签
```

### 使用 Tag 进行过滤

```csharp
// 仅处理带有 EnemyTag 的实体
foreach (var position in
    SystemAPI.Query<RefRW<Position>>().WithAll<EnemyTag>()) {
    // 敌人特定逻辑
}
```

---

## 系统排序

### 显式排序

```csharp
[UpdateBefore(typeof(PhysicsSystem))]
public partial struct InputSystem : ISystem { }

[UpdateAfter(typeof(PhysicsSystem))]
public partial struct RenderSystem : ISystem { }
```

---

## 性能模式

### Chunk 迭代（最高性能）

```csharp
public void OnUpdate(ref SystemState state) {
    var query = SystemAPI.QueryBuilder().WithAll<Position, Velocity>().Build();

    var chunks = query.ToArchetypeChunkArray(Allocator.Temp);
    var positionType = state.GetComponentTypeHandle<Position>();
    var velocityType = state.GetComponentTypeHandle<Velocity>(true); // 只读

    foreach (var chunk in chunks) {
        var positions = chunk.GetNativeArray(ref positionType);
        var velocities = chunk.GetNativeArray(ref velocityType);

        for (int i = 0; i < chunk.Count; i++) {
            positions[i] = new Position {
                Value = positions[i].Value + velocities[i].Value * deltaTime
            };
        }
    }

    chunks.Dispose();
}
```

---

## 从 MonoBehaviour 迁移

```csharp
// ❌ 旧版: MonoBehaviour（面向对象）
public class Enemy : MonoBehaviour {
    public float speed;
    void Update() {
        transform.position += Vector3.forward * speed * Time.deltaTime;
    }
}

// ✅ 新版: DOTS (ECS)
public struct EnemyData : IComponentData {
    public float Speed;
}

[BurstCompile]
public partial struct EnemyMovementSystem : ISystem {
    public void OnUpdate(ref SystemState state) {
        float dt = SystemAPI.Time.DeltaTime;
        foreach (var (transform, enemy) in
            SystemAPI.Query<RefRW<LocalTransform>, RefRO<EnemyData>>()) {
            transform.ValueRW.Position += new float3(0, 0, enemy.ValueRO.Speed * dt);
        }
    }
}
```

---

## 调试

### Entities Hierarchy 窗口

`Window > Entities > Hierarchy`

- 显示所有实体及其组件
- 按原型、组件类型过滤

### Entities Profiler

`Window > Analysis > Profiler > Entities`

- 系统执行时间
- 每个原型的内存使用

---

## 来源
- https://docs.unity3d.com/Packages/com.unity.entities@1.3/manual/index.html
- https://docs.unity3d.com/Packages/com.unity.burst@1.8/manual/index.html
- https://learn.unity.com/tutorial/entity-component-system
