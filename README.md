# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

# case

    1. 固定收益 : 算力 乘以固定值 除以  缺点 没币可提
    2. 根据余额 : 当前合约余额/总算力*token算力 缺点 当用户提取后 其他的人收益会减少 如果体现后 余额不变 会出现无法提币的情况
    2. 根据NFT总量 : 当前合约余额/nft总量  缺点 和算力没有任何关系 且
    2. 中心化结合 : 后台监听算力数据  pool 余额 根据时间 分配金额
