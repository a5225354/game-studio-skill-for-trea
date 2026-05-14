# Unity 6.3 — 网络模块参考

**最后验证:** 2026-02-13
**知识差距:** Unity 6 使用 Netcode for GameObjects（UNet 已弃用）

---

## 概述

Unity 6 网络方案:
- **Netcode for GameObjects**（推荐）: Unity 官方多人游戏框架
- **Mirror**: 社区驱动（UNet 继任者）
- **Photon**: 第三方服务 (PUN2)
- **自定义**: 底层 Socket

**UNet（旧版）**: 已弃用，请勿使用。

---

## Netcode for GameObjects

### 安装
1. `Window > Package Manager`
2. 搜索 "Netcode for GameObjects"
3. 安装 `com.unity.netcode.gameobjects`

---

## 基本设置

### NetworkManager

```csharp
// 添加到场景: GameObject > Add Component > NetworkManager

// 或创建自定义 NetworkManager:
using Unity.Netcode;

public class CustomNetworkManager : MonoBehaviour {
    void Start() {
        NetworkManager.Singleton.StartHost(); // 服务器 + 客户端
        // 或
        NetworkManager.Singleton.StartServer(); // 专用服务器
        // 或
        NetworkManager.Singleton.StartClient(); // 仅客户端
    }
}
```

---

## NetworkObject（网络 GameObject）

### 将 GameObject 标记为网络对象

1. 为 GameObject 添加 `NetworkObject` 组件
2. 必须在预制体的根部（不能嵌套）
3. 在 `NetworkManager > NetworkPrefabs List` 中注册预制体

### 生成网络对象

```csharp
using Unity.Netcode;

public class GameManager : NetworkBehaviour {
    public GameObject playerPrefab;

    [ServerRpc(RequireOwnership = false)]
    public void SpawnPlayerServerRpc(ulong clientId) {
        GameObject player = Instantiate(playerPrefab);
        player.GetComponent<NetworkObject>().SpawnAsPlayerObject(clientId);
    }
}
```

---

## NetworkBehaviour（网络脚本）

### NetworkBehaviour 基类

```csharp
using Unity.Netcode;

public class Player : NetworkBehaviour {
    // 在网络上生成时调用
    public override void OnNetworkSpawn() {
        if (IsOwner) {
            // 仅在拥有者的客户端上运行
            GetComponent<Camera>().enabled = true;
        }
    }

    void Update() {
        if (!IsOwner) return; // 仅拥有者可控制

        // 处理输入
        if (Input.GetKey(KeyCode.W)) {
            MoveServerRpc(Vector3.forward);
        }
    }

    [ServerRpc]
    void MoveServerRpc(Vector3 direction) {
        // 在服务器上运行
        transform.position += direction * Time.deltaTime;
    }
}
```

---

## 网络变量（同步状态）

### NetworkVariable<T>

```csharp
using Unity.Netcode;

public class Player : NetworkBehaviour {
    // ✅ 跨客户端自动同步
    private NetworkVariable<int> health = new NetworkVariable<int>(100);

    public override void OnNetworkSpawn() {
        // 订阅值变更
        health.OnValueChanged += OnHealthChanged;
    }

    void OnHealthChanged(int oldValue, int newValue) {
        Debug.Log($"生命值变更: {oldValue} -> {newValue}");
        UpdateHealthUI(newValue);
    }

    [ServerRpc]
    public void TakeDamageServerRpc(int damage) {
        // 仅服务器可修改 NetworkVariable
        health.Value -= damage;
    }
}
```

### NetworkVariable 权限

```csharp
// 服务器可写入，客户端只读（默认）
private NetworkVariable<int> score = new NetworkVariable<int>();

// 拥有者可写入
private NetworkVariable<int> ammo = new NetworkVariable<int>(
    default,
    NetworkVariableReadPermission.Everyone,
    NetworkVariableWritePermission.Owner
);
```

---

## RPC（远程过程调用）

### ServerRpc（客户端 → 服务器）

```csharp
// 客户端调用，服务器执行
[ServerRpc]
void FireWeaponServerRpc() {
    // 在服务器上运行
    Debug.Log("服务器: 武器已开火");
}

// 从客户端调用:
if (IsOwner && Input.GetKeyDown(KeyCode.Space)) {
    FireWeaponServerRpc();
}
```

### ClientRpc（服务器 → 所有客户端）

```csharp
// 服务器调用，所有客户端执行
[ClientRpc]
void PlayExplosionClientRpc(Vector3 position) {
    // 在所有客户端上运行
    Instantiate(explosionPrefab, position, Quaternion.identity);
}

// 从服务器调用:
[ServerRpc]
void ExplodeServerRpc(Vector3 position) {
    // 服务器逻辑
    DealDamageToNearbyPlayers(position);

    // 通知所有客户端
    PlayExplosionClientRpc(position);
}
```

### RPC 参数

```csharp
// ✅ 支持: 基本类型、结构体、字符串、数组
[ServerRpc]
void SetNameServerRpc(string playerName) { }

[ClientRpc]
void UpdateScoresClientRpc(int[] scores) { }

// ❌ 不支持: MonoBehaviour、GameObject（使用 NetworkObjectReference）
```

---

## 网络所有权

### 检查所有权

```csharp
if (IsOwner) {
    // 此客户端拥有此 NetworkObject
}

if (IsServer) {
    // 在服务器上运行
}

if (IsClient) {
    // 在客户端上运行
}

if (IsLocalPlayer) {
    // 这是本地玩家对象
}
```

### 转移所有权

```csharp
// 服务器转移所有权
NetworkObject netObj = GetComponent<NetworkObject>();
netObj.ChangeOwnership(newOwnerClientId);
```

---

## NetworkObjectReference（在 RPC 中传递 GameObject）

```csharp
using Unity.Netcode;

[ServerRpc]
void AttackTargetServerRpc(NetworkObjectReference targetRef) {
    if (targetRef.TryGet(out NetworkObject target)) {
        // 获取到目标对象
        target.GetComponent<Health>().TakeDamage(10);
    }
}

// 调用:
NetworkObject targetNetObj = target.GetComponent<NetworkObject>();
AttackTargetServerRpc(targetNetObj);
```

---

## 客户端-服务器架构

### 服务器权威模式（推荐）

```csharp
public class Player : NetworkBehaviour {
    private NetworkVariable<Vector3> position = new NetworkVariable<Vector3>();

    void Update() {
        if (IsOwner) {
            // 客户端: 将输入发送到服务器
            Vector3 input = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            MoveServerRpc(input);
        }

        // 所有客户端: 同步到网络位置
        transform.position = position.Value;
    }

    [ServerRpc]
    void MoveServerRpc(Vector3 input) {
        // 服务器: 验证并应用移动
        position.Value += input * Time.deltaTime * moveSpeed;
    }
}
```

---

## 网络传输 (Network Transport)

### Unity Transport（默认）

```csharp
// 在 NetworkManager 中配置:
// - Transport: Unity Transport
// - Address: 127.0.0.1 (localhost) 或服务器 IP
// - Port: 7777 (默认)
```

### 连接事件

```csharp
void Start() {
    NetworkManager.Singleton.OnClientConnectedCallback += OnClientConnected;
    NetworkManager.Singleton.OnClientDisconnectCallback += OnClientDisconnected;
}

void OnClientConnected(ulong clientId) {
    Debug.Log($"客户端 {clientId} 已连接");
}

void OnClientDisconnected(ulong clientId) {
    Debug.Log($"客户端 {clientId} 已断开");
}
```

---

## 性能提示

### 减少网络流量
- 对不常变化的状态使用 `NetworkVariable`
- 在同步前批量处理多个变更
- 对大数据使用增量压缩

### 预测与协调 (Prediction & Reconciliation)
- 本地运行移动以获得响应性
- 与服务器权威状态进行协调
- 使用插值实现平滑移动

---

## 调试

### Network Profiler
- `Window > Analysis > Network Profiler`
- 监控带宽、RPC 调用、变量更新

### Network Simulator（测试延迟/丢包）
- `NetworkManager > Network Simulator`
- 添加人工延迟和丢包用于测试

---

## 来源
- https://docs-multiplayer.unity3d.com/netcode/current/about/
- https://docs-multiplayer.unity3d.com/netcode/current/learn/bossroom/
