web3 study log 

2025-6-30

今天跟着Patrick Collins学习了[Solidity 101 Section 1: Simple Storage](https://github.com/Cyfrin/foundry-full-course-cu#solidity-101-section-1-simple-storage)，在Sepolia Testnet上部署了我的第一个合约，感觉非常不错，学习的正反馈很好。

这节课内容不难，就是讲解的一些solidity的基础内容，重点是多写些代码。对于这种看视频都会的内容，我的学习方法是在视频对应的github仓库中找到对应的知识点，然后截图给chatgpt让他给我出练习题，然后写了代码再给他看，对于任何不懂的问题就问。弄完了就让gpt根据问答生成一份学习笔记就OK了，非常的方便。

准备把我的学习代码，一些做的练习都传到github上，以前学习其他东西的时候都是懒得弄，感觉还是要弄一下，以后找工作会需要。明天继续学习，非常的开心，好久没有这么充实的学习过了，希望能坚持下去！LFG🔥🔥🔥！

## **一、账户与合约基本原理**

### **1. 区块链账户类型**

- **EOA（Externally Owned Account）**：由用户私钥控制的钱包账户。
- **合约账户（Contract Account）**：由合约代码控制，部署时创建。

### **2. 合约部署与交易过程**

- 部署合约实际上是向区块链发送一笔特殊交易，to 为 null，input 是合约的字节码。
- 合约部署成功后会有一个生成的 contract address。
- 向合约发起交互（如调用函数）与向普通地址转账类似，区别在于 input data 包含函数签名与参数编码。

## **二、Solidity 合约基础语法**

### **1. 状态变量与函数**

- 语法格式：type visibility name，例如 uint public count;
- 函数定义顺序不能颠倒：function name(...) visibility view/pure returns (...)
- public 修饰变量会自动生成 getter 函数。

### **2. 函数修饰符**

- view：可读取状态变量，不能修改。
- pure：不能读取或修改状态变量（但可以使用 msg.sender、tx.origin 等全局变量）。
- external：只能被合约外部调用。
- internal：只能被当前合约或继承者内部调用。
- private：只能在当前合约内部调用。

## **三、数据位置关键字**

### **1. 数据位置类型**

| **关键字** | **说明**                   |
| ---------- | -------------------------- |
| storage    | 永久储存在链上（默认位置） |
| memory     | 函数执行期间的临时内存     |
| calldata   | 外部函数参数的只读数据区   |

### **2. 使用场景**

- string、bytes、数组、结构体等引用类型，必须在函数参数中指明数据位置。
- 外部函数参数使用 calldata 更节省 gas，内部函数参数或处理需要修改时用 memory。
- storage 用于访问和修改状态变量。

## **四、bytes vs string**

### **1. 对比**

| **类型** | **特点**                   |
| -------- | -------------------------- |
| string   | 动态长度，UTF-8 字符串     |
| bytes32  | 固定长度 32 字节，截断溢出 |
| bytes    | 可变长度原始字节数组       |

### **2. Gas 消耗对比**

- string s = "hello"：变长，gas 消耗高。
- bytes32 b = "hello"：固定长，只取前 32 字节，gas 更少。

## **五、输入数据与 ABI 编码**

### **1. input/output 解码**

- input 是 ABI 编码的函数签名和参数。
- output 是 ABI 编码的返回值。
- 可使用 Remix、Etherscan 等工具查看 decoded input/output。

### **2. 示例**

```
function store(uint _value) public {
    favoriteNumber = _value;
}
```

调用时 input 为：0x6057361d...（函数选择器+参数编码）

## **六、数组与结构体**

### **1. 数组**

- 固定数组：uint[3] nums;
- 动态数组：uint[] nums;，可用 push 添加元素

### **2. Struct（结构体）**

```
struct Person {
    string name;
    uint age;
}
Person[] public people;
```

## **七、映射（mapping）**

### **1. 基本用法**

```
mapping(address => bool) public hasVoted;
```

### **2. 特点**

- 类似哈希表，默认值为零值（如 false）。
- 不可遍历，不支持 length 或 keys。

## **八、Gas 消耗与交易明细分析**

### **1. Gas 含义**

- **Gas Limit**：最大允许消耗量。
- **Gas Used**：实际消耗。
- **Transaction Fee** = Gas Used × Gas Price。
- **Base Fee**：EIP-1559 后的最低 gas 费。
- **Priority Fee（小费）**：用户额外付给矿工的费用。
- **Burnt**：销毁的 base fee。

### **2. 示例分析**

```
Gas Limit: 266,567
Gas Used: 263,310
Base Fee: 0.008796225 Gwei
Priority Fee: 1.5 Gwei
总费用 = Gas Used × (Base + Priority)
```

## **九、练习题成果汇总**

- PeopleList：使用 struct + array
- Calculator：纯函数 add() 与视图函数 getOwner()
- RoleCheck：使用 private 函数封装逻辑
- DataHandler：使用 memory 与 calldata 的对比
- VoteBox：使用 mapping 实现防止重复投票

