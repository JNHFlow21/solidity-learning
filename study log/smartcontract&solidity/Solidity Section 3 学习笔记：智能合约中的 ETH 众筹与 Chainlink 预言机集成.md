Web3 Study Log 003

2025-7-5

这几天各种各样的琐事，处理完了，真的烦，估计能消停一段时间了....

今天终于能够坐下来好好学习，今天学习了chainlink的使用，能够获取 ETH/USD 实时价格，然后写了一个简单的众筹项目，用到现在学习到所有知识，智能合约涉及到钱的地方，确实要谨慎谨慎再谨慎，今天一个提款条件写错了，钱筹集完整之后，提不出来...幸好只是Testnet。

明天准备继续写一个项目，DeFi 预售合约TokenPresale，说项目可能太夸张了，就是一道综合练习题，巩固下目前所学习的知识。背景为：一个新项目要发币，在正式上线前对早期支持者进行预售。规则如下：

1. 项目方设置目标：**募集多少 USD 价值的 ETH**，例如 $5000。
2. 使用 Chainlink ETH/USD 汇率，支持 ETH 捐赠，**捐赠最小值为 10 USD**。
3. 项目方设置预售结束时间（例如一周后）。
4. 预售结束后：
   - 项目方可提款；
   - 投资人不可退款。
5. 上线后，投资人可 **线性解锁领取代币（Token）**，解锁期为 180 天。
6. 投资人通过 claimTokens() 领取尚未解锁的部分，领取多少由合约计算。

**Web3 Study Log 003**

**2025-07-05**

been dealing with a bunch of random life stuff lately — finally cleared up

man it was annoying lol… but looks like i’ll finally get some peace for a while

today i finally sat down to actually study

learned how to use Chainlink to fetch real-time ETH/USD price

then built a simple crowdfunding contract that brings together everything i’ve learned so far

any time a smart contract handles funds… you *really* gotta be careful

made a mistake in the withdraw condition — funds hit the goal but couldn’t be withdrawn lol

good thing it was just on testnet

tomorrow i’m planning to build another contract — a TokenPresale for a fake DeFi project

not really a full project tbh, more like a comprehensive practice exercise

goal is just to solidify what i’ve learned so far



here’s the idea:

1. project owner sets a **target funding goal in USD**, e.g. $5000
2. use Chainlink ETH/USD price feed — support ETH donations, **min $10 USD per donation**
3. project owner sets a deadline (e.g. 1 week from start)
4. after deadline:
   - project owner can withdraw
   - investors can’t refund
5. once token launches, investors can **claim tokens linearly over 180 days**
6. claimTokens() lets investors withdraw their unlocked tokens, based on contract calculation

------

# **Solidity Section 3 学习笔记：智能合约中的 ETH 众筹与 Chainlink 预言机集成**

## **一、学习目标**

通过构建一个具备以下功能的智能合约，系统掌握 Solidity 中的重要语法与实际开发场景：

- 使用 Chainlink AggregatorV3Interface 获取 ETH/USD 实时价格
- 实现一个 ETH 捐赠众筹合约，支持募资、价格换算、提款功能
- 使用 fallback() 和 receive() 函数接收 ETH
- 掌握 call/send/transfer 差异
- 使用 modifier 进行权限控制
- 使用 error 和 revert 优化 gas
- 使用 library 封装常用逻辑
- 了解 calldata 的作用及检查方式
- 在 Remix 上调试合约的部署与调用

------

## **二、关键概念与代码讲解**

### **1. Chainlink ETH/USD 预言机价格获取**

#### **调用方式**

```
AggregatorV3Interface priceFeed = AggregatorV3Interface(address);
(, int answer,,,) = priceFeed.latestRoundData();
```

#### **精度换算**

- Chainlink 的 answer 返回的是带 8 位精度的价格（如 2000 * 1e8）
- ETH 金额通常以 wei（1 ETH = 1e18 wei）传入
- 为对齐精度，需将 answer * 1e10 扩展为 1e18 精度，再与 ETH 金额相乘，最后除以 1e18

### **2. 捐赠逻辑与单位换算**

```
uint256 usd = (ethPrice * ethAmountInWei) / 1e18;
```

- ethAmountInWei 是传入的实际金额（比如 msg.value）
- 如果捐入 0.02 ETH，即 0.02 * 1e18 wei，与 ETH 价格相乘换算为 USD

### **3. 捐赠函数 fund() 实现**

- 时间控制：block.timestamp < i_deadline
- 限制重复捐赠者：通过 mapping hasFunded 和 funders[]
- 检查目标达成（大于即可）：if (usdTotal >= i_goal) { goalReached = true; }

```
require(!goalReached, "Goal already reached");
```

### **4. fallback() 和 receive()**

- 用于接收 ETH，当调用没有 calldata 时触发 receive()
- 有 calldata 或调用未定义函数时触发 fallback()
- 推荐都定义为 external payable

### **5. 权限控制 modifier 与 error**

```
modifier onlyOwner {
    if (msg.sender != i_owner) revert NotOwner();
    _;
}

modifier fundSuccessOrTimeout {
    if (!(block.timestamp >= i_deadline || getTotalRaisedInUsd() >= i_goal)) {
        revert NotFinish();
    }
    _;
}
```

- 使用 revert ErrorName() 可节省 gas（与 require("string") 比较）
- 使用 !() 表示否定整个布尔表达式

### **6. call/send/transfer 的差异**

| **方法** | **gas 限制**                  | **返回值**         | **推荐程度** |
| -------- | ----------------------------- | ------------------ | ------------ |
| transfer | 固定 2300 gas                 | 无返回值           | 不推荐       |
| send     | 固定 2300 gas                 | 返回 bool          | 不推荐       |
| call     | 可设定 gas / value / calldata | 返回 (bool, bytes) | 推荐 ✅       |

常见调用方式：

```
(bool success, ) = payable(msg.sender).call{value: amount}("");
require(success, "Call failed");
```

------

## **三、调试常见问题总结**

### **问题1：fund 调用失败**

- 原因：getLatestETHPriceInUSD() 返回值类型未匹配，或传入 ETH 金额过少导致 USD 捐赠金额远小于 i_goal，报错
- 解决：确保传入 ETH 数量与 Chainlink 的实时价格能够换算为合适的 USD 金额

### **问题2：withdraw 提款失败**

- 检查是否满足 withdraw 的 modifier 条件，即：

```
block.timestamp >= i_deadline || getTotalRaisedInUsd() >= i_goal
```

- 如果 goalReached = true 但 getTotalRaisedInUsd() 小于 i_goal（例如汇率波动导致回落），仍会失败
- 建议改写为检查 goalReached 标志位配合 block.timestamp >= deadline 控制

## **四、library 的使用**

将 ETH 转 USD 的逻辑封装为 library PriceConverter，用法如下：

```
using PriceConverter for uint256;

totalAmount.getLatestETHPriceInUSD();
```

注意事项：

- library 中不能使用状态变量
- 通常定义为纯函数或 view
- 实现逻辑更清晰、可重用性更高

## **五、calldata 与 fallback 判断技巧**

```
if (msg.data.length == 0) {
    // receive() triggered
} else {
    // fallback() triggered
}
```

口诀总结：

```
转账没数据：走 receive()
其他情况：走 fallback()
想看有没有数据：看 msg.data.length
```

## **六、调试 Remix 的注意事项**

- 发送 ETH 需在 fund 函数旁边的 value 字段输入，如：0.01（单位是 ETH）
- fallback 区域中的 calldata 应填写 16 进制值（以 0x 开头）
- 如果要使用 fallback 或 receive 自动转入，需要将 ETH 发送给合约地址