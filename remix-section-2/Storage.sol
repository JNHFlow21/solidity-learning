// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
🧱 项目名称：智能保险箱工厂系统（Smart Vault Factory）

⸻

🎯 项目目标：

构建一个可以部署多个保险箱（Vault）的工厂合约系统。每个保险箱都是一个独立合约，具有以下功能：
	•	储存数字
	•	储存保险箱的名称 -> 合约地址
	•	限制设置的数字范围（继承并重写）
	•	工厂可与这些保险箱交互

⸻

🧩 项目组成

你需要创建 3 个合约文件：

⸻

📄 1. Storage.sol

功能要求：
	•	定义一个 uint 类型的变量 number。
	•	提供 setNumber 函数用于设置数字。
	•	提供 getNumber 函数用于读取数字。
⸻

🏆 Bonus（加分任务）
	•	为 NamedStorage 添加一个 creator 地址，只有创建者能调用 setNumber()。
	•	在 Factory 中添加 getAllVaultsCount() 函数，返回保险箱数量。
	•	创建另一个继承 Storage 的 SuperStorage 合约，覆盖 setNumber() 逻辑（例如最多 500），并尝试支持 Factory 创建不同类型保险箱。

*/

contract InitialVault{
    uint number; //默认是internal，只有本合约和继承合约可以访问，如果是private就只有本合约可以访问

    function setNumber(uint _number) public virtual {
        number = _number;
    }

    function getNumber() public view returns (uint){
        return number;
    }
}