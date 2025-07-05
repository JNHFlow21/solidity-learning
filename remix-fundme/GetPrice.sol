// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
        function getLatestETHPriceInUSD(uint ethAmountInWei) internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer, 
            /* 
            返回的answer是1e8精度
            answer = 200000000000
            200000000000 / 1e8 = 2000 USD
            我们习惯将价格扩展到 1e18 精度，以便与 ETH（Wei 单位）进行精确相乘。
            */
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        /*
        ethPrice是每个eth的usd价格，由于ethAmount是1e18的精度，所以我们首先要对其精度 *1e10
        */
        uint256 ethPrice = uint256 (answer * 1e10); 

        /*
        在solidity中调用 msg.value、传递 payable 函数时，都会默认单位是 Wei，是eth的最小单位
        1 eth = 1e18 wei
        所以说 ethAmount表示的不是多少个eth，而是多少个eth对应的wei，我们需要知道eth的usd价格，所以最后要 / 1e18
        */
        return (ethPrice * ethAmountInWei) / 1e18; // solidity中永远先乘法再除法

        /*
        为何要精度要对齐1e18，而不是1e10？
        因为DeFi协议统一标准和ERC20的精度都是1e18，这样方便和其他协议交互

        举例说明：
        如果 answer = 2000 * 1e8 = 200000000000 => ethPrice = 2000 * 1e18 （经过 × 1e10 扩精度）

        如果 ethAmount = 1.5 ETH = 1.5 * 1e18 wei
        则 usdAmount = (2000 * 1e18) * (1.5 * 1e18) / 1e18 = 3000 * 1e18（即 $3000，18 位精度）
        */
    }
}