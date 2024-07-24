// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PandaToken} from "../src/token/PandaToken.sol";
import {Test, console2} from "forge-std/Test.sol";

contract PandaTokenTest is Test {
    PandaToken pt;
    address owner;
    address user;

    function setUp() external {
        owner = makeAddr("owner");
        user = makeAddr("user");
        pt = new PandaToken(owner);
    }

    function testMint() external {
        vm.prank(owner);
        pt.mint(address(1), 1e20);
        assertEq(pt.balanceOf(address(1)), 1e20);
    }

    function testFailMint() external {
        vm.prank(user);
        pt.mint(address(1), 1e20);
    }
}