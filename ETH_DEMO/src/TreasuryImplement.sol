// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AToken} from "./tokens/AToken.sol";
import {BToken} from "./tokens/BToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract TreasuryImplement is Ownable, Initializable {

    AToken public aToken;
    BToken public bToken;

    // according to initializable() function to init the TreasuryProxy
    function initialize(address _owner, address _aToken, address _bToken) external initializer {
        require(_owner != address(0), "The _owner must not be zero.");
        _transferOwnership(_owner);
        aToken = AToken(_aToken);
        bToken = BToken(_bToken);
    }

    function deposit() external payable {
        aToken.mint(msg.sender, msg.value);
    }
    
}