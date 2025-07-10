Web3 Study Log 004

2025-7-6

今天做完了昨天说的那个练习，有点难度，但是还好。今天天气很好，外面晴空万里，窗外蓝天白云，再泡杯茶，放点音乐，坐在桌前写代码，很舒服，平静的生活。下午出去锻炼了一会，回来不想学习，也不知道干嘛，才发现自己的社交圈很窄，我是很习惯一个人的生活，社交比较累，消耗能量，但是有时候，可能每两三个月就很想和朋友一起出去爆玩一下，但是都是临时起意，一般都约不成，大家都有自己的安排，哎... 希望能认识些新的朋友，准备吃晚饭了，晚上一个人去洪崖洞逛逛，散散步，感受下人气，生活就是这么平淡

O_O，对了，希望刷到的朋友，想学习智能合约开发的朋友可以star我的仓库啊：https://github.com/JNHFlow21/solidity-learning，我会一直持续更新的，里面有我自己整理使用的智能合约开发的资料。

**Web3 Study Log 003**

**2025-07-06**

finished the practice exercise i mentioned yesterday

a bit tricky but managed to get through it

the weather today was amazing — clear blue skies and bright sun

brewed some tea, put on some music, and sat down to code

simple moments like that feel peaceful

this is the kind of life i enjoy

went out for a quick workout in the afternoon

came back and didn’t really feel like studying

wasn’t sure what to do honestly

kinda realized how small my social circle is

i’m pretty used to being on my own — socializing drains energy

but every couple months, i get this sudden urge to hang out and go wild with friends

thing is… it’s always spontaneous

so most of the time it doesn’t happen — everyone’s got their own life

ah well… would be nice to meet some new people

anyway, about to go grab dinner

thinking of walking around Hongyadong alone tonight

just to soak in the city energy a bit

nothing fancy — just regular quiet life

------

# **📘 DeFi 项目实战练习笔记：Token Presale with Linear Vesting**

## **🪙 练习背景说明**

在 DeFi 项目中，新代币上线前通常会开展预售以筹集启动资金。本练习模拟一个典型的 Token 预售场景，目标是设计一个**支持 ETH 捐赠、Chainlink 汇率转换、线性释放代币**的智能合约 TokenPresale。

------

## **📋 功能需求文档（题目要求）**

### **✅ 场景设定**

- 项目方设置一个 USD 募集目标（如 5000 USD）。
- 投资人通过 ETH 参与预售。
- 使用 Chainlink ETH/USD 预言机进行汇率转换。
- 设置预售结束时间。
- 设置线性解锁规则（如 180 天内逐步释放 Token）。
- 项目方提现后，用户根据贡献领取 Token，不能退款。

------

### **✅ 状态变量设计**

| **变量名**         | **说明**                                       |
| ------------------ | ---------------------------------------------- |
| owner              | 项目方地址                                     |
| presaleEndTime     | 预售结束时间戳                                 |
| goalInUsd          | 募集目标（USD）                                |
| tokenPerUsdRate    | 1 USD 可兑换多少 Token（如 1 USD = 100 Token） |
| totalUsdRaised     | 当前已募资总额（USD）                          |
| unlockStartTime    | 解锁起始时间（提现后设置）                     |
| unlockDuration     | 解锁总时长（如 180 天，练习中设置为 1 天）     |
| isClaimEnabled     | 是否允许用户领取 Token                         |
| userUsdContributed | 每个用户贡献的 USD 金额（单位：1e18）          |
| userTotalToken     | 每个用户应得的 Token 数量                      |
| userClaimedTokens  | 每个用户已领取的 Token 数量                    |
| contributors       | 所有参与过捐赠的地址                           |
| paused             | 紧急暂停开关                                   |

------

### **✅ 函数需求**

| **函数名**          | **功能说明**                                      |
| ------------------- | ------------------------------------------------- |
| fund()              | 接收 ETH 并记录捐赠；检查时间、汇率转换、最小金额 |
| withdrawETH()       | 项目方提现 ETH，触发解锁逻辑                      |
| enableClaim()       | 内部函数，设置 unlockStartTime，初始化解锁参数    |
| claimTokens()       | 用户按比例领取解锁的 Token                        |
| getTokenClaimable() | 查看当前可领取的 Token 数量                       |
| getUserInfo()       | 返回某地址的总捐、已领取、可领取 Token            |
| pause() / unpause() | 项目暂停与恢复                                    |

------

### **✅ 使用的知识点**

- modifier onlyOwner, canWithdraw, canClaim, notPaused
- Chainlink 预言机（ETH/USD）
- 精度控制（1e18 单位）
- receive() 和 fallback() 用于自动接收 ETH
- 解锁比率 = (当前时间 - 解锁起始时间) / 总解锁时间
- call 转账方式
- 自定义错误（如 PresaleEnded, GoalReached, TooSmall）

------

## **🧠 学习过程中遇到的问题与解答**

### **❓ Q1: Remix 部署时是否需要单独部署** PriceConverter？

**答**：不需要。PriceConverter 是 library，你导入并使用了其中的函数（例如 getLatestETHPriceInUSD）。只需要部署主合约 TokenPresale，Remix 会自动链接依赖。

------

### **❓ Q2: Chainlink 返回的汇率精度是多少？**

**答**：你使用的 Aggregator 地址返回的是 8 位小数的价格（如 1850.12345678），需要将其转换为 18 位精度：

```
uint256 ethPrice = uint256(answer * 1e10);
```

最终 USD = ethPrice * msg.value / 1e18，单位是 1e18 精度。

------

### **❓ Q3: 什么是线性解锁？起始时间和总时长如何设置？**

**答**：

- **线性解锁**：Token 不是一次性领取，而是根据时间比例逐步解锁（如每天解锁 1/180）。
- **起始时间**：通常是项目方提现之后，即 TGE（Token Generation Event）开始。
- **总时长**：是从 unlockStartTime 开始，到 unlockStartTime + unlockDuration 结束。

```
unlockStartTime = block.timestamp; // enableClaim() 触发时设置
unlockDuration = 1 days; // 模拟练习
```

------

## **🛠️ 我的最终合约设计亮点**

- ✅ 使用 Chainlink 获取 ETH/USD 实时汇率
- ✅ 限制最低捐赠金额 10 USD
- ✅ 自动判断时间与目标达成
- ✅ withdraw 后立即 enableClaim 并初始化解锁
- ✅ 用户通过 claimTokens 按比例领取 Token
- ✅ 使用 modifier 限制非法操作
- ✅ 实现 pause/unpause
- ✅ 提供 getUserInfo 一键查看用户状态

------

## **✅ 示例代码片段：claimTokens**

```
function claimTokens() public canClaim {
    uint256 claimable = getTokenClaimable(msg.sender);
    userClaimedTokens[msg.sender] += claimable;

    // 模拟转账（如有 Token 合约应调用 transfer）
    // IERC20(tokenAddress).transfer(msg.sender, claimable);
}
```

------

## **🔗 本练习关联仓库结构说明**

仓库地址：https://github.com/JNHFlow21/solidity-learning

| **文件夹名**    | **说明**           |
| --------------- | ------------------ |
| remix-section-2 | section2 练习      |
| section-1       | 基础部分           |
| remix-fundme    | 项目 FundMe 实战   |
| DeFi 预售合约   | 本练习的完整实现   |
| artifacts       | Remix 编译产物     |
| README.md       | 学习流程总说明文档 |

------

## **📌 总结**

通过本练习，你掌握了：

- Solidity 合约开发中的典型 DeFi 场景
- 汇率转换、线性解锁、项目方提现、捐赠映射等典型合约逻辑
- modifier 与自定义错误机制的结合使用
- 多 mapping 的综合状态管理
- 合约结构与代码组织思路

练习帮助你走出简单函数调用的阶段，开始真正构建具有完整生命周期的 DeFi 项目智能合约。建议下一个项目尝试接入 **ERC20 Token 接口 + 实际 Token 交互**，完成完整的领取与转账。

