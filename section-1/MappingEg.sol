// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
✍️ 练习题：编写一个简单投票映射系统

请你完成一个合约 VoteBox，实现以下功能：

📌 功能要求：
	1.	创建一个 mapping(address => bool) public hasVoted;
	2.	创建一个 uint public totalVotes;
	3.	实现一个函数 vote()：
	•	如果用户之前投过票，则禁止再次投票；
	•	如果没投过，记录他已投票，并使 totalVotes +1
✨ Bonus：
	•	添加一个函数 hasUserVoted(address _user) 返回这个地址是否投票过。
*/

contract VoteBox{
	mapping(address => bool) public hasVoted;
	uint public totalVotes;

	// 需要投票，要修改状态变量，所以状态修饰符为默认，不使用view
	function vote() public returns(bool){
		if (hasVoted[msg.sender]) return false;

		totalVotes += 1;
		hasVoted[msg.sender] = true;
		return true;
	}

	//需要访问状态变量，所以使用view而不是pure
	function hasUserVoted(address _user) public view returns (bool){
		return hasVoted[_user];
	}
}