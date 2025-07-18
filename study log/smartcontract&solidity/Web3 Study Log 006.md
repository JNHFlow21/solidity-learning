**Web3 Study Log 006**

**2025-07-11**

如果我这是真钱该多好,那可以躺平了，ETH今天冲上3000又下来了...

我热烈的温哦，今天继续完善了token-presale-foundry这个项目，写了个前端，本来以为花不了多久，出了好多bug，改了好久。

首先就是我是昨天就写好了test和deploy，结果今天部署和前端交互之后，出现了第一个问题，我的pricefeed写死了是chainlink提供的，然后部署在anvil链上就查询不到价格，要重构代码，因为不想改动太多，我是最少改动，结果改完测试全报错了，又重新老实改了一遍。

然后是provider初始化有问题，获取不了正确chainid，解决就是不要使用polling: true。

然后就是metamask连接anvil，又出现些莫名其妙的问题，导入提供的私钥到钱包，居然是余额0，但是我在终端查询又显示有余额，然后又报错访问不存在区块，解决方案就是重启了一遍电脑就好了。

后面总算没问题了，withdrawETH的时候，发现交易是确认了，可是钱包里的交易显示0ETH，去etherscan上面查了才知道，withdrawETH是内部交易，虽然交易value为0，但资金会通过内部交易转移。在以太坊智能合约中，内部交易是指合约代码执行过程中触发的ETH转账，而不是交易本身直接携带的ETH。

这几天睡的也晚，好几天也没锻炼，日吗对自己好一点，写完了马上就去锻炼下，今晚再睡个好觉。明天估计要弄其他的事情，这个又得缓缓，哎，怪我效率太低。

**Web3 Study Log 005**

**2025-07-11**



i’m burning hot today lol

kept working on my token-presale-foundry project — built a front end for it

thought it’d be quick… but so many bugs came up it took forever



yesterday i had tests + deploy scripts all done

but once i connected the frontend, first issue:

i hardcoded the Chainlink price feed address (mainnet), but i deployed on Anvil — no price shows up

tried to refactor with minimal changes, broke all my tests

so yeah… rewrote it properly the second time



then came a provider issue — couldn’t fetch the correct chain ID

fix: don’t use polling: true when setting up the provider



next, Metamask wouldn’t connect to Anvil properly

imported the private key it gave me, but balance showed 0 in wallet

while terminal said the account had ETH

then I got a weird “block not found” error



turned out… a full reboot fixed everything lol



finally got it working

but then I noticed something weird when calling withdrawETH

transaction confirmed, but Metamask showed 0 ETH transferred

checked on Etherscan — turns out withdrawETH was an **internal transaction**

which means value is transferred **inside the contract**, not directly via the tx itself

so the tx value is 0, but ETH still moves

just one of those Ethereum things 🤷‍♂️



been sleeping late the past few days

haven’t worked out either

time to treat myself better — gonna hit a quick workout now and crash early tonight

probably gotta handle other stuff tomorrow so this project’s gonna pause again

guess i just gotta work on my efficiency