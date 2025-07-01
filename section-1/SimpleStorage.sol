// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; // 定义solidity的版本，^表示比这个版本高都行，也可以使用 >=0.8.18 <0.9来限制范围


contract SimpleStorage{
    // 类似于定义类 contract = class 后面是classname
    /*
        对于对象 类型 权限修饰符 名字
        对于函数 function 方法名 权限修饰符
    */
    uint256  public favoriteNumber;//声明一个变量
    string public s1 ;
    bytes32 public  s2 ;

    function store(uint256 _newNumber) public {//存储函数
        favoriteNumber = _newNumber;//赋值操作
    }

    function storeString(string memory _s1) public {
        s1 = _s1;
    }

    function storeBytes32(bytes32 _s2) public {
        s2 = _s2;
    }

}