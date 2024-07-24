// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPandaFactory} from "../src/interfaces/IPandaFactory.sol";
import {IPandaPair} from "../src/interfaces/IPandaPair.sol";
import {PandaFactory} from "../src/PandaFactory.sol";
import {PandaPair} from "../src/PandaPair.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";
import {PandaToken} from "../src/token/PandaToken.sol";
import {USDT} from "../src/token/USDT.sol";

import {Test, console2} from "forge-std/Test.sol";

contract TestFactory_Pair is Test {

    IPandaFactory factory;
    IPandaPair pair;
    IERC20 usdt;
    IERC20 panda;
    address owner;
    address zero_addr = address(0);

    function setUp() external {

        owner = makeAddr("owner");

        // create token0 and token1
        usdt = IERC20(new USDT(owner));   
        panda = IERC20(new Panda(owner)); 
        console2.log(address(usdt));
        console2.log(address(panda));

        // create factory and pair
        factory = new PandaFactory(zero_addr);
        pair = factory.createPair(address(usdt), address(panda));

    }
}