// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
✍️ 练习题：合约 RoleCheck

现在请你完成下面这个练习：

📌 功能需求：
	1.	有一个 private 状态变量 adminCode
	2.	一个 constructor 在部署时初始化 adminCode = 8888
	3.	编写一个 public 函数 isAdmin(uint _code)，返回布尔值
	4.	用一个 private 函数 _checkCode(uint) 实际做判断
	5.	再写一个 external 函数 exposeCheck(uint _code)，外部账户调用时会触发 _checkCode 判断
*/

contract RoleCheck{
    uint private adminCode;

    constructor(){
        adminCode = 8888;
    }

    function isAdmin(uint _code) public view returns(bool){
        return _checkCode(_code);
    }

    function _checkCode(uint _code) private view returns (bool){
        return _code == adminCode;
    }

    function exposeCheck(uint _code) external view {
        _checkCode(_code);
    }

}