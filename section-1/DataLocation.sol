// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
✍️ 练习题：理解数据位置

请你完成如下智能合约：

创建一个合约 DataHandler，实现以下功能：
	1.	声明一个状态变量 string public storedData；
	2.	编写一个函数 saveData(string memory _data)，将参数保存到 storedData；
	3.	编写一个 external 函数 previewData(string calldata _input)，返回传入的字符串。
*/

contract DataHandler{
    string public storedData;
    function saveData(string memory _data) public {
        storedData = _data;
    }
    function previewData(string calldata _input) external pure returns (string memory){
        return _input;
    }
    function echoBytes(bytes calldata _input) external pure returns (bytes memory){
        return _input;
    }
}