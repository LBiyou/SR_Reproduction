// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {AToken} from "../tokens/AToken.sol";
import {BToken} from "../tokens/BToken.sol";
import {FundPool} from "../fundpool/FundPool.sol";

import {IERC20} from "@openzeppelin/contracts@4.8.3/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts@4.8.3/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts@4.8.3/access/Ownable.sol";
import {Initializable} from "@openzeppelin/contracts@4.8.3/proxy/utils/Initializable.sol";

contract TreasuryImplement is Ownable, Initializable {
    using SafeERC20 for IERC20; // TO voild the USDT without returnData makeing mistakes

    AToken public aToken;
    BToken public bToken;
    IERC20 public USDT;
    FundPool public fundPool;

    mapping(address => uint256) userFund;

    /// @dev initalize the Treasury proxy
    /// @param _owner the owner of the Treasury
    /// @param _aToken the token of the A
    /// @param _bToken the token of the B
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

    /// @dev current only support the usdt on etherum chain
    /// @param amount the amount of usdt
    function depositToken(uint256 amount) external {
        USDT.safeTransferFrom(msg.sender, address(this), amount);
        userFund[msg.sender] += amount;
        aToken.mint(address(fundPool), amount);
        bToken.mint(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(userFund[msg.sender] >= amount, "Insufficient funds!!!");
        userFund[msg.sender] -= amount;
        bToken.burn(msg.sender, amount);
        USDT.transfer(msg.sender, amount);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////   view functions  /////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////

    function getUserFunds() external view returns (uint256) {
        return userFund[msg.sender];
    }
}
