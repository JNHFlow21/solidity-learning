/*
📄 3. Factory.sol

功能要求：
	•	提供 createVault(string memory _name)，用于部署一个 NamedStorage 合约。
	•	用一个数组 allVaults 存储所有已部署的保险箱地址。
	•	提供以下函数与某个保险箱交互（通过索引 _index）：
	•	getVault(uint _index)：返回某个保险箱合约实例。
	•	setVaultNumber(uint _index, uint _num)
	•	getVaultNumber(uint _index)
	•	getVaultName(uint _index)
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {InitialVault} from "./Storage.sol";
import {NamedVault} from "./NamedStorage.sol";
import {SuperVault} from "./SuperStorage.sol";

enum VaultType { Named, Super }

contract Factory {
    InitialVault[] public allVaults;

    // 创建保险箱，根据类型部署 NamedVault 或 SuperVault
    function createVault(string memory _name, VaultType _type) public {
        if (_type == VaultType.Named) {
            allVaults.push(new NamedVault(_name));
        } else {
            allVaults.push(new SuperVault());
        }
    }

    // 获取保险箱数量
    function getAllVaultsCount() external view returns (uint) {
        return allVaults.length;
    }

    // 获取保险箱合约实例（返回通用 InitialVault 类型）
    function getVault(uint _index) public view returns (InitialVault) {
        return allVaults[_index];
    }

    // 获取保险箱中的数字
    function getVaultNumber(uint _index) public view returns (uint) {
        return allVaults[_index].getNumber();
    }

    // 设置保险箱中的数字
    function setVaultNumber(uint _index, uint _num) public {
        allVaults[_index].setNumber(_num);
    }

    // 获取保险箱名称（仅适用于 NamedVault，需做类型转换）
    function getVaultName(uint _index) public view returns (string memory) {
        NamedVault named = NamedVault(address(allVaults[_index]));
        return named.getName();
    }
}