# Solidity 学习笔记仓库

本仓库是我系统学习智能合约开发（Solidity）的过程记录与代码合集。内容将**持续更新**，包括视频学习笔记、实战练习题、综合项目等，供自己复习巩固，也希望能帮助到其他 Web3 学习者。
目前的目标是把 2️⃣ Solidity 的课程学习完，然后去参加一个黑客松。

---

## 💡 学习心得

- 我刚开始学习的时候，感觉无从下手，中文资料确实很少，而且网上一搜教程就是让你看各种论文，白皮书，而不是 coding，我并不喜欢这种学习方式，非常的低效，所以我把学习 solidity，学习智能合约开发的过程记录下来。
- 一定要利用好 AI，每次看完视频之后，可以把知识点发给他，然后让他给你整理下知识，再生成一两道综合练习题，如果能做出来，就可以继续往下了，coding 的能力就是这样才能不断提高。

---

## 🧭 学习路径规划

本项目严格按照“**理论 + 实战 + 项目巩固**”三步法进行。

### 1️⃣ 基础理论入门（中文）

- **学习资源**：北京大学肖臻老师《区块链技术与应用》课程
- **观看地址**：[B 站课程链接](https://www.bilibili.com/video/BV1Vt411X7JF?p=26)
- **学习目标**：理解区块链原理、共识机制、智能合约模型、账户结构等
- ✅ 本阶段以**理解区块链底层运作机制为主**
- **学习建议**：对于不太理解的内容，不用太纠结，这只是让你有个大概的印象，大致了解是个什么东西即可，后面 Patrick Collins 的视频也会再次讲述这些知识，只不过没怎么详细。

---

### 2️⃣ Solidity 全套开发实战（英文）

- **学习阶段**：[Remix](https://github.com/JNHFlow21/solidity-learning) - [Foundry](https://github.com/JNHFlow21/token-presale-foundry) - ...
- **学习资源**：[Patrick Collins 的完整 Solidity 教程（YouTube）](https://www.youtube.com/watch?v=-1GB6m39-rM&t=24284s)
- **学习方式**：边看视频边敲代码，章节同步编写练习
- **我的项目**：
  - [foundry-token-presale（前端+合约）](https://github.com/JNHFlow21/token-presale-foundry):Token Presale Foundry 是一个完整的代币预售解决方案，允许项目方通过智能合约进行去中心化的代币预售。用户可以使用ETH参与预售，系统自动使用Chainlink预言机将ETH转换为等值USD，并在预售结束后按照设定比例线性释放代币给参与者。
- **学习工具**：
  - [ETH 单位换算工具（eth-converter）](https://eth-converter.com/)
  - [Sepolia 测试网水龙头（Google Faucet）](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)
  - [Chainlink Price Feed 地址文档](https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1)
  - [Chainlink 如何使用数据喂价教程](https://docs.chain.link/data-feeds/using-data-feeds)
  - [MetaMask 连接其他网络，连接本地的 Anvil 区块链节点](https://blog.csdn.net/fjh_ready_sonaa/article/details/149271836)
  - [Foundry智能合约测试设计流程](https://blog.csdn.net/fjh_ready_sonaa/article/details/149234167)

---

### 3️⃣ 未完待续...

- **学习资源**：
- **学习方式**：

---

## 📂 仓库结构说明

```bash
solidity-learning/
├── DeFi 预售合约（Token Presale with Linear Vesting）   # Patrick Collins Remix课程 综合练习：DeFi 预售合约（带线性解锁）
├── remix-fundme/                                        # Remix-Section 3：CryptoCrowdfund 练习
├── remix-section-2/                                     # Remix-Section 2：数据位置与存储练习（Storage、Memory）
├── section-1/                                            # Remix-Section 1：Solidity 基础语法练习（Hello World）
└── README.md                                            # 项目说明文件（当前这个文档）

```

---

📬 联系我

如有建议或交流意愿，欢迎 Issue 或 PR。
也可以添加下面的联系方式，欢迎各位 web3 的朋友！

- GitHub: @JNHFlow21
- 小红书: 1017180966
- X: [JNH.Flow21](https://x.com/jerry4junhao)
- TG: @JJJFlow21
