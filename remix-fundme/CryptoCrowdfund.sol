// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./GetPrice.sol";

error notOwner();
error notFinish();
error withdrawFailed();

contract CryptoCrowdfund{

    using PriceConverter for uint256;

    address public immutable i_owner; // 合约所有者
    uint256 public immutable i_goal;// 募集目标
    uint public immutable i_deadline;// 截止时间
    mapping(address => uint256) public addressToAmountFunded;  // 每个地址捐了多少
	address[] public funders;  // 所有捐款人地址
    uint256 public totalAmount; // 目前总的额度
    mapping (address => bool) public hasFunded; //判断账户是否捐款过
    bool public goalReached; //是否完成目标
    

    constructor(){
        i_owner = msg.sender;
        i_goal = 50 * 1e18; //50usd
        i_deadline = block.timestamp +  30*60; //30min     //7*24*60*60; // one week
    }

    /*
    fund() 函数：
	•	必须是 payable。
	•	使用 Chainlink 获取当前 ETH/USD 汇率，将捐款 ETH 转换为 USD。 //0x694AA1769357215DE4FAC081bf1f309aDC325306
	•	require 总捐款不能超过目标金额，且时间不能超出 i_deadline。
	•	将捐赠记录到 mapping 和数组中。
    */
    function fund() public payable {
        require(block.timestamp < i_deadline, "Crowdfund: Project ended"); // 时间戳是全局变量
        require(!goalReached, "Crowdfund: Goal already reached");

        if (!hasFunded[msg.sender]){
            hasFunded[msg.sender] = true;
            funders.push(msg.sender);
        }

        addressToAmountFunded[msg.sender] += msg.value;
        totalAmount += msg.value;

        // 只要总额达到或超过目标就视为达成
        uint256 newTotalUsd = totalAmount.getLatestETHPriceInUSD();
        if (newTotalUsd >= i_goal) {
            goalReached = true;
        }
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Not Owner!"); 使用error节省gas
        if (msg.sender != i_owner) revert notOwner();
        _;
    }

    modifier fundSuccessOrTimeout(){
        // require(block.timestamp >= i_deadline || getTotalRaisedInUsd() >= i_goal,
        // "Not ended or goal not met");
        if (block.timestamp < i_deadline && getTotalRaisedInUsd() < i_goal) revert notFinish();
        _;
    }

    function withdraw() public onlyOwner fundSuccessOrTimeout{
        // 清空mapping和funders
        for (uint256 index = 0; index < funders.length; index ++){
            addressToAmountFunded[funders[index]] = 0;
        }
        funders = new address[](0);
        // 调用call把所有募集到的钱全部打给owner
        /*
        call的返回值是一个bool表示调用是否成功，和一个bytes类型返回数据，是调用函数返回值的abi编码

        call的用法就是 address.call{}("") {}是可以不写的，但是()是必须内容，最简单的就是 Address.call("");
        ()中的内容就是calldata
            {value: X, gas: Y, salt: Z} value的单位是wei
            () 调用合约的某个函数:// 调用目标地址的 foo(uint256) 函数，并传入参数 123
                Address.call{value: 1 ether}(abi.encodeWithSignature("foo(uint256)", 123));
            
        */
        (bool isSuccess, )= payable(/*msg.sender*/ i_owner).call{value:address(this).balance}("");
        //require(isSuccess, "Withdraw failed!");
        if (!isSuccess) revert withdrawFailed();
    }

    function  getRemainingTime() public view returns(uint256) {
        if (block.timestamp >= i_deadline) return 0;
        return i_deadline - block.timestamp;
    }


    /*
    都必须external payable
    转账没数据：走 receive()；其他全走 fallback()！
    想看有没有：看 msg.data.length！如何？
    */
    receive() external payable { fund(); }

    fallback() external payable {fund(); }

    function getTotalRaisedInUsd() public view returns (uint256){
        uint256 total;
        for (uint256 index = 0; index < funders.length; index++){
            total += addressToAmountFunded[funders[index]];
        }
        return total.getLatestETHPriceInUSD();
    }

}