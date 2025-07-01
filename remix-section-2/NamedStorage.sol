// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
⸻

📄 2. NamedStorage.sol

功能要求：
	•	导入 Storage.sol 中的合约。
	•	继承 Storage。
	•	在构造函数中设置一个字符串变量 name，表示该保险箱的名称。
	•	重写 setNumber 函数：只有 _num <= 1000 时才允许设置。
	•	提供 getName() 函数返回保险箱名称。

⸻
*/

import {InitialVault} from "./Storage.sol";

contract NamedVault is InitialVault{
    string name;
    address creator;

    constructor(string memory _name){
        name = _name;
        creator = msg.sender;
    }

    function setNumber(uint _number) public override {
        require(msg.sender == creator);
        require(this.getNumber() <= 1000);
        // super.setNumber(_number); 可以这样使用吗？但是我重写了父类方法，还调用super，应该不对吧？
        number = _number;
    }

    function getName() public view returns (string memory){
        return name;
    }
}