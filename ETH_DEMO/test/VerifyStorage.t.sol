// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AToken} from "../src/tokens/AToken.sol";
import {BToken} from "../src/tokens/BToken.sol";
import {TreasuryImplement} from "../src/TreasuryImplement.sol";
import {ProjectAdmin} from "../src/ProjectAdmin.sol";
import {Treasury} from "../src/Treasury.sol";

import "forge-std/Test.sol";

contract VerifyStorage is Test {
    Treasury treasury;
    TreasuryImplement treasuryImplement;
    ProjectAdmin projectAdmin;
    AToken aToken;
    BToken bToken;

    address owner = address(0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa);

    function setUp() external {
        vm.startPrank(owner);

        // init variables
        projectAdmin = new ProjectAdmin(); // duty of update proxy's implement
        treasuryImplement = new TreasuryImplement();
        treasury = new Treasury(address(treasuryImplement), address(projectAdmin), "");

        aToken = new AToken(address(treasury));
        bToken = new BToken(address(treasury));

        bytes memory initdata = abi.encodeWithSignature(
            "initialize(address,address,address)",
            owner,
            address(aToken),
            address(bToken)
        );
        (bool success, ) = address(treasury).call(initdata);
        require(success, "call failed");
        vm.stopPrank();
    }

    function testFailMultiInitialize() external {
        bytes memory initdata = abi.encodeWithSignature(
            "initialize(address,address,address)",
            owner,
            address(aToken),
            address(bToken)
        );
        vm.prank(owner);
        (bool success, ) = address(treasury).call(initdata);
        require(success, "call failed");
    }

    function testStorage() external {
        bytes32 slot0 = vm.load(address(treasury), bytes32(uint256(0)));
        emit log_bytes32(slot0);
        bytes32 slot1 = vm.load(address(treasury), bytes32(uint256(1)));
        assertEq(address(uint160(uint256(slot1))), address(aToken));
        emit log_bytes32(slot1);
        bytes32 slot2 = vm.load(address(treasury), bytes32(uint256(2)));
        assertEq(address(uint160(uint256(slot2))), address(bToken));
        emit log_bytes32(slot2);
    }
}
