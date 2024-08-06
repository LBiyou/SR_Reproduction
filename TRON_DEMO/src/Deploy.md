### How to deploy

1. 部署 ProjectAdmin.sol

2. 部署 FundPoolImplement.sol

3. 部署 FundPool.sol
    - _logic: FundPoolImplement's address
    - _admin: ProjectAdmin's address
    - data：“0x”
4. 部署 TreasuryImplement.sol
5. 部署 Treasury.sol
    - _logic: TreasuryImplement's address
    - _admin: ProjectAdmin's address
    - data：“0x”
6. 部署 AToken
    - _treasury: Treasury's address
7. 部署 BToken
    - _treasury: Treasury's address
8. 部署 USDT

***NOTE: 初始化Treasury合约***

```solidity
    function initialize(
        address _owner,
        address _aToken,
        address _bToken,
        address _usdt,
        address payable _fundPool
    ) external reinitializer(uint8(1)) {
        require(_owner != address(0), "The _owner must not be zero.");
        _transferOwnership(_owner);
        aToken = AToken(_aToken);
        bToken = BToken(_bToken);
        USDT = IERC20(_usdt);
        fundPool = FundPool(_fundPool);
    }
```

通过低级调用初始化，发送calldata。