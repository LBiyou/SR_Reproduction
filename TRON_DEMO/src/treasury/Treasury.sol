// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts@4.8.3/proxy/transparent/TransparentUpgradeableProxy.sol";


contract Treasury is TransparentUpgradeableProxy {
    constructor(
        address _logic,
        address admin_,
        bytes memory _data
    ) TransparentUpgradeableProxy(_logic, admin_, _data) payable {}
    
}