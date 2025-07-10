Web3 Study Log 005

2025-7-11

现在是01:04，有时候很喜欢在大早上和凌晨写代码，非常的安静，没人打扰，感觉思路很清晰，放点音乐，很爽，很自由。今晚情绪到了，必须听下张杰...

这几天又是一堆事情，总算是把founry搞完了，在之前的token-presale合约上做的二次开发，写的测试，部署。难度不大，就是挺繁琐的。国内不要按照教程使用alchemy，要使用infuro，还遇到什么问题，我忘了，记不清了。这个智能合约感觉写精度需要注意，一不小心就容易搞错，精度对不齐，出现些莫名其妙的错误。

写测试就按照https://blog.csdn.net/fjh_ready_sonaa/article/details/149234167?spm=1001.2014.3001.5501写，让ai写，写完了检查一下就好。

我的repo：https://github.com/JNHFlow21/solidity-learning（学习资料在这里）

**Web3 Study Log 005**

**2025-07-11**



it’s 01:04 right now

sometimes i just love coding in the early morning or late at night — it’s super quiet, no distractions, brain feels clear

throw on some music, vibe out

felt a bit emotional tonight… had to loop some Zhang Jie songs lol



past few days were kinda chaotic again

finally wrapped up some Foundry work — extended my previous token-presale contract, added tests and deployment scripts

nothing too hard, just tedious af



btw if you’re in China, **don’t follow tutorials using Alchemy** — use Infura instead

ran into some issues… can’t even remember what exactly went wrong, just know it was annoying lol



writing smart contracts really makes you respect precision

just one decimal mismatch and you’ll get the weirdest errors



for tests, i followed this blog:

https://blog.csdn.net/fjh_ready_sonaa/article/details/149234167?spm=1001.2014.3001.5501

honestly just let AI write them and check after, works fine



my repo’s here btw:

🔗 https://github.com/JNHFlow21/solidity-learning

(all my learning materials go here)

------

## **一、Foundry 核心组件简介**

| **工具名** | **说明**                                   |
| ---------- | ------------------------------------------ |
| forge      | 合约开发、测试、编译的主工具               |
| cast       | 与链交互工具：查询数据、发送交易、部署合约 |
| anvil      | 本地模拟链，用于测试、开发和 fork 主网数据 |

------

## **二、基础开发结构**

```
forge init token-presale-foundry
```

生成项目目录结构：

```
token-presale-foundry/
├── src/                # 合约代码
├── test/               # 测试代码
├── script/             # 部署脚本
├── foundry.toml        # 配置文件
├── .env                # 环境变量
```

------

## **三、合约开发与部署流程**

### **1. 编写合约（src/TokenPresale.sol）**

使用 PriceConverter 库，实现预售逻辑，包含：

- fund()：捐赠 ETH -> USD 换算
- withdrawETH()：项目方提现
- claimTokens()：线性解锁后用户领取 token
- modifiers 修饰器：权限、时间、状态判断
- fallback/receive 函数自动处理 ETH 转账

### **2. 编译合约**

```
forge build
```

------

## **四、合约测试模块详解**

### **1. 单元测试（unit）**

```
contract TokenPresaleTest_Unit is Test {
  address owner = makeAddr("owner");
  ...
}
```

- 使用 makeAddr("user1") 创建虚拟地址
- vm.prank(user)：模拟下一个 tx 由 user 发出
- vm.startPrank(user) 与 vm.stopPrank() 配套使用模拟多条 tx
- vm.expectRevert(Error.selector) 断言 revert 错误

### **2. 测试** 

### **fund**

###  **函数最小捐赠限制**

```
function testFund_RevertWhenTooSmall() public {
    uint256 tooSmallAmount = 0.009 ether;
    vm.prank(user1);
    vm.expectRevert(TooSmall.selector);
    tokenPresale.fund{value: tooSmallAmount}();
}
```

知识点：

- Solidity 中 .selector 是函数/错误签名的前 4 字节
- 不能用 TooSmall() 因为 .expectRevert 期望的是 bytes4

### **3. 使用 warp 模拟时间推移**

```
vm.warp(tokenPresale.unlockStartTime() + tokenPresale.unlockDuration() + 1);
```

- vm.warp() 模拟区块时间
- 解锁线性领取功能需要模拟时间推进

------

## **五、Fork 测试（Forked）**

使用主网预言机数据测试 ETH/USD 换算逻辑：

```
forge test --match-path test/forked/TokenPresaleTest_Forked.t.sol --fork-url $SEPOLIA_RPC_URL -vvvv
```

知识点：

- Fork 测试不会消耗 Metamask 测试币
- 使用 getLatestETHPriceInUSD() 查询主网预言机价格
- 容忍误差断言写法：

```
assertApproxEqAbs(actual, expected, tolerance, "msg");
```

------

## **六、Staging 测试（模拟完整流程）**

文件：test/staging/TokenPresaleTest_Staging.t.sol

流程覆盖：

1. 多用户捐赠 → 达成目标
2. owner 提现 → 启用领取
3. 模拟时间推进：领取 30%、60%、100%
4. 紧急暂停：验证暂停状态下逻辑和领取是否被影响

------

## **七、部署脚本与 Makefile 自动化**

### **1. 脚本文件**

```
contract DeployTokenPresale is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        TokenPresale tokenPresale = new TokenPresale();
        console.log("TokenPresale deployed at:", address(tokenPresale));
        vm.stopBroadcast();
    }
}
```

### **2. 本地** 

### **.env**

###  **示例**

```
SEPOLIA_PRIVATE_KEY=你的私钥
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/xxx
ETHERSCAN_API_KEY=xxx
MYWALLET_ADDRESS=0xf3...266
SEPOLIA_MYWALLET_ADDRESS=0x44...6c5
RPC_URL=http://127.0.0.1:8545
```

### **3. Makefile 自动化部署命令**

```
deploy-anvil:
	forge script script/DeployTokenPresale.s.sol:DeployTokenPresale \
		--rpc-url $(RPC_URL) \
		--broadcast \
		--wallet mywallet \
		--sig "run()" \
		-vvvv
```

注意：

- .env 不应上传至 GitHub，需加 .gitignore

------

## **八、cast send 直接部署（CLI 方式）**

```
cast send \
  --from 0xf39f...92266 \
  --rpc-url http://127.0.0.1:8545 \
  --create out/TokenPresale.sol/TokenPresale.json \
  -- \
  -vvvv
```

错误排查：

- --unlocked 错误使用
- --legacy 需要写在 -- 后
- mywallet 不能直接作为 --from，需先用 cast wallet 解锁并查地址

------

## **九、Foundry 调试日志解释**

调用结构如下：

```
TokenPresale::fund{value: 8091...}()
├─ EACAggregatorProxy::latestRoundData()
│  └─ AccessControlledOffchainAggregator::latestRoundData()
│     └─ 返回价格数据：24535，表示 $2453.5
```

关键术语解释：

- [staticcall]：只读调用（不改变链状态）
- [Return]：返回的字段为 (roundId, answer, startedAt, updatedAt, answeredInRound)
- 1 ether = 1e18 wei，ETH 捐赠在换算 USD 时自动转换精度

------

## **十、总结**

| **类别**     | **工具**                  | **用法**                             |
| ------------ | ------------------------- | ------------------------------------ |
| 合约编写     | Solidity                  | 编写逻辑：fund、claim、withdraw      |
| 本地模拟     | Anvil                     | anvil 启动本地链                     |
| 测试工具     | forge test                | 支持 unit / forked / staging         |
| 脚本部署     | forge script              | 搭配 .env 和 Makefile 实现自动化部署 |
| 链上交互     | cast send / call / wallet | 查询状态、部署合约、签名交易         |
| 环境变量管理 | .env + Makefile           | 配置私钥、钱包地址、RPC 节点等信息   |



