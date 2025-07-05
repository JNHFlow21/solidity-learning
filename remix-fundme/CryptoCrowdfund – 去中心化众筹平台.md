好的！以下是一道综合练习题，结合了你在 Remix Section 1~3 中学习的 Solidity 核心知识点，包括：payable、msg.value、library、interface、modifier、fallback/receive、constructor、mapping、call/send/transfer、Chainlink price feed、自定义错误、constant/immutable 等，适合作为项目实战练习👇

⸻

🧩 综合练习题：CryptoCrowdfund – 去中心化众筹平台

📝 项目简介：

你要开发一个 去中心化众筹平台合约 CryptoCrowdfund，允许项目发起者设定目标金额和截止时间，并接收 ETH 捐赠。当时间到达或目标金额达到后，项目方可以提取资金。

⸻

🎯 功能需求：

🧱 Part 1：基本功能
	1.	创建一个 Crowdfund 合约，包含以下状态变量：
	•	address public immutable i_owner; → 发起人
	•	uint256 public immutable i_goal; → 募资目标（单位：USD，使用 Chainlink 价格换算）
	•	uint256 public immutable i_deadline; → 截止时间（单位：时间戳）
	•	mapping(address => uint256) public addressToAmountFunded; → 每个地址捐了多少
	•	address[] public funders; → 所有捐款人地址
	2.	构造函数设置 i_owner, i_goal, i_deadline。
	3.	fund() 函数：
	•	必须是 payable。
	•	使用 Chainlink 获取当前 ETH/USD 汇率，将捐款 ETH 转换为 USD。
	•	require 总捐款不能超过目标金额，且时间不能超出 i_deadline。
	•	将捐赠记录到 mapping 和数组中。
	4.	getTotalRaisedInUsd()：
	•	返回总共筹集的 USD 金额（换算后的）。

⸻

🔐 Part 2：提取功能 + 安全性
	5.	withdraw()：
	•	只有 owner 可调用（使用 modifier）。
	•	仅当目标达成或时间到达才允许提取。
	•	清空 mapping 和 funders。
	•	使用 .call{value: ...}("") 向项目方提取 ETH。
	6.	使用 error 和 revert 优化 gas，例如 error NotOwner();、error NotFundable();
	7.	添加 fallback() 和 receive()，调用 fund()。

⸻

✨ Bonus（加分项）
	8.	创建一个 library PriceConverter 用于 ETH -> USD 换算。
	9.	refund
	10.	添加 getRemainingTime() 函数返回剩余众筹时间。

⸻

✅ 覆盖知识点清单：

知识点	应用位置
payable & msg.value	fund()、receive()
Chainlink 预言机	getConversionRate()
mapping & array	存储捐赠信息
modifier	onlyOwner 修饰符
call 转账	提取资金
library 使用	PriceConverter
require / revert / error	参数检查、安全性处理
fallback/receive	接收 ETH 时自动捐款
immutable / constant	gas 优化
interface	Chainlink 数据读取接口


⸻

你可以用多个 .sol 文件组织项目结构，例如：
	•	CryptoCrowdfund.sol → 主合约
	•	PriceConverter.sol → ETH/USD 换算库
	•	AggregatorV3Interface.sol → Chainlink 接口