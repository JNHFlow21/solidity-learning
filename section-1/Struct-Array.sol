// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
    💡 题目描述：
请你编写一个智能合约 PeopleList，实现以下功能：
	1.	定义一个结构体 Person，包含 name（string）和 age（uint）；
	2.	声明一个 动态数组 people 用来保存所有 Person；
	3.	实现一个函数 addPerson(string memory _name, uint _age)：
	•	使用 push 添加一个新的 Person 到数组中；
	4.	实现一个函数 getPerson(uint index)，返回该位置上的人的姓名和年龄。
*/

contract PeopleList{
    struct Person{
        string name;
        uint age;
    }

    Person[] public people;

    function addPerson(string memory _name, uint _age) public {
        people.push(Person(_name, _age));
    }
    
    //internal/public 函数参数是数组或 string ，只需要读所以view
    function getPerson(uint index) public view returns (string memory name, uint){
        require(index < people.length);
        return (people[index].name, people[index].age);
    }
}