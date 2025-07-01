// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Calculator{
    /*
    1.	添加一个函数 add(uint a, uint b)，返回两个数字相加结果（用 pure 修饰符）
	2.	添加一个函数 getOwner()，返回合约部署者地址（用 view 修饰符）
	3.	添加一个状态变量 owner，在合约构造时设置为 msg.sender
    */
    address public owner; //不添加public会怎么样？就不会显示owner ui按钮，只能通过getOwner访问

    constructor (){
        owner = msg.sender;// 这里的msg是全局函数，不是contract中定义的变量
    }

    //pure 不能读链，不能改链，只能用参数或内部变量
    function add(uint a, uint b) public  pure returns (uint) {
        return a + b;  //显示return
    }

    //所有 pure 或 view 函数 必须显式 return 或自动 return 命名变量
    function mine(uint a, uint b) public pure returns (uint res) {
        res = a - b;
    }

    //view 是只能读链，不能修改
    function getOwner() public view returns (address){
        return owner;
    }


    
}