// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error PresaleEnded();
error GoalReached();
error notOwner();
error notFinished();
error withdrawFailed();
error ClaimDisabled();
error TooSmall();

contract TokenPresale{

    address public immutable owner; // 项目方地址
    uint256 public immutable presaleEndTime; // 预售结束时间戳
    uint256 public immutable goalInUsd; // 募集目标，单位 USD
    uint256 public totalUsdRaised; // 当前已募资总额 1e18精度
    bool public isClaimEnabled; // 是否允许用户领取 Token
    uint256 public immutable tokenPerUsdRate; // 代币兑换比例，例如 100 = 1 USD 得 100 Token
    uint256 public unlockStartTime; // 线性解锁起始时间
    uint256 public constant unlockDuration = 1 days; // 解锁总时长
    mapping(address => uint256) public userUsdContributed; // 用户捐赠的 USD 金额 1e18精度
    mapping(address => uint256) public userClaimedTokens; // 用户已领取的代币数量
    address[] public contributors; // 所有参与用户列表（辅助遍历）
    mapping(address => bool) public hasContributed; // 判断用户是否募集过
    mapping (address => uint) public userTotalToken; // 用户总共的代币数量
    bool public paused; //紧急暂停项目

    using PriceConverter for uint256;

    constructor(){
        owner = msg.sender;
        presaleEndTime = block.timestamp + 30*60; // 30min
        goalInUsd = 50 * 1e18; // 100usd,要对齐18位精度，因为priceconverter 返回的值也是18位精度的美元 比如 100 * 1e18
        tokenPerUsdRate = 100; // 100 = 1 USD 得 100 Token
    }

    /*
    捐赠 ETH，内部换算为 USD，校验时间与目标，更新映射
    */
    function fund() public payable notPaused{
        // 时间结束
        if (block.timestamp > presaleEndTime) revert PresaleEnded();
        // 目标完成
        if (totalUsdRaised.getLatestETHPriceInUSD() >= goalInUsd) revert GoalReached();

        uint256 minUsd = 10 * 1e18;
        if (msg.value.getLatestETHPriceInUSD() < minUsd) revert TooSmall();

        if (!hasContributed[msg.sender]){
            hasContributed[msg.sender] = true;
            contributors.push(msg.sender);
        }
        
        uint256 contributedUsd = msg.value.getLatestETHPriceInUSD();
        userUsdContributed[msg.sender] += contributedUsd;
        totalUsdRaised += contributedUsd;
    }

    modifier onlyOwner(){
        if (msg.sender != owner) revert notOwner();
        _;
    }
    modifier canWithdraw(){
        if (totalUsdRaised.getLatestETHPriceInUSD() < goalInUsd && block.timestamp <= presaleEndTime) revert notFinished();
        _;
    }
    modifier canClaim(){
        if (!isClaimEnabled) revert ClaimDisabled();
        _;
    }
    modifier notPaused(){
        require(!paused);
        _;
    }


    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    /*
    项目方提现 ETH（call方式）
    */
    function withdrawETH() public payable onlyOwner canWithdraw{
        //不能清零mapping和contributors，因为还要根据余额发token
        (bool isSuccess, )= payable (owner).call{value: address(this).balance}("");
        if (!isSuccess) revert withdrawFailed();

        enableClaim();
    }
    
    /*
    计算出每个user的token
    */
    function calculateTokens() private {
        for (uint256 i = 0;i < contributors.length;++i){
            address contributor = contributors[i];
            uint256 contributedUsd = userUsdContributed[contributor] / 1e18;
            require(contributedUsd > 0, "Not Contributed");
            
            //算出总的token数量
            userTotalToken[contributor] = contributedUsd * tokenPerUsdRate;
        }
    }

    /*
    查询某地址可领取的 Token 数量
    */
    function getTokenClaimable(address user) public view canClaim returns (uint256){
        //算出已解锁的token数量
        uint256 elapsed = block.timestamp - unlockStartTime;
        if (elapsed > unlockDuration) elapsed = unlockDuration;
        uint256 unlockToken = (userTotalToken[user] * elapsed) / unlockDuration;
        //算出还可以领取的token
        uint256 claimable = unlockToken - userClaimedTokens[user];
        if (claimable <= 0) return 0;

        return claimable;
    }

    /*
    用户调用，按时间线性领取尚未领取的 Token
    */
    function claimTokens() public canClaim{
        uint256 claimable = getTokenClaimable(msg.sender);

        userClaimedTokens[msg.sender] += claimable;

        // 发放 Token 的真实逻辑可通过集成 IERC20 合约调用实现：
        // IERC20(tokenAddress).transfer(msg.sender, claimable);
        // 此处仅记录已领取，不涉及实际转账（仅用于练习场景）
    }

    /*
    用户是否可以领取token
    */
    function enableClaim() private {
        isClaimEnabled = true;
        unlockStartTime = block.timestamp;
        calculateTokens();
    }

    /*
    返回用户贡献 USD、已领取 Token、可领取 Token
    */
    function getUserInfo(address user) public view returns (uint256, uint256, uint256){
        return (userUsdContributed[user] / 1e18, userClaimedTokens[user] , getTokenClaimable(user));
    }

    /*
    转账没数据就receive，其他全是fallback
    */
    receive() external payable { fund();}

    fallback() external payable { fund();}


}