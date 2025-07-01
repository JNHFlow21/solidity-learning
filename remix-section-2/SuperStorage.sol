// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {InitialVault} from "./Storage.sol";

contract SuperVault is InitialVault {

    string name = "supervault";
    
    function setNumber(uint _number) public override {
        require(_number <= 500, "Number too large!");
        number = _number;
    }
}