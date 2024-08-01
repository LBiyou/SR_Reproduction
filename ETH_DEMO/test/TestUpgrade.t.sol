// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AToken} from "../src/tokens/AToken.sol";
import {BToken} from "../src/tokens/BToken.sol";
import {USDT} from "../src/tokens/USDT.sol";
import {ProjectAdmin} from "../src/ProjectAdmin.sol";
import {Treasury} from "../src/treasury/Treasury.sol";
import {TreasuryImplement} from "../src/treasury/TreasuryImplement.sol";

import {FundPool} from "../src/fundpool/FundPool.sol";
import {FundPoolImplement} from "../src/fundpool/FundPoolImplement.sol";

import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import "forge-std/Test.sol";

contract TestUpgrade is Test {
    address owner = address(0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa);
    address user1 = address(0x1);
    AToken aToken;
    BToken bToken;
    USDT usdt;
    FundPool fundPool;
    FundPoolImplement fundPoolImplement;
    Treasury treasury;
    TreasuryImplement treasuryImplement;
    ProjectAdmin projectAdmin;

    function setUp() external {
        vm.startPrank(owner);

        // init variables
        projectAdmin = new ProjectAdmin(); // duty of update proxy's implement
        treasuryImplement = new TreasuryImplement();
        treasury = new Treasury(
            address(treasuryImplement),
            address(projectAdmin),
            ""
        );
        fundPoolImplement = new FundPoolImplement();
        fundPool = new FundPool(address(fundPoolImplement), owner, "");
        aToken = new AToken(address(treasury));
        bToken = new BToken(address(treasury));
        usdt = new USDT();

        // init data

        usdt.mint(user1, 10 ether);

        {
            bytes memory treasuryInitData = abi.encodeWithSignature(
                "initialize(address,address,address,address,address)",
                owner,
                address(aToken),
                address(bToken),
                address(usdt),
                address(fundPool)
            );
            (bool success, ) = address(treasury).call(treasuryInitData);
            require(success, "call failed");
        }
        vm.stopPrank();
    }

    function _upgrade() internal {
        TreasuryImplement new_TreasuryImp = new TreasuryImplement();
        projectAdmin.upgrade(
            ITransparentUpgradeableProxy(address(treasury)),
            address(new_TreasuryImp)
        );
    }

    function testUpgradeTreasury() external {
        vm.startPrank(owner);
        bytes32 _old = vm.load(address(treasury), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);
        _upgrade();
        bytes32 _new = vm.load(address(treasury), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);
        emit log_named_bytes32("_old =>", _old);
        emit log_named_bytes32("_new =>", _new);
        assertNotEq(_old, _new);
        vm.stopPrank();
    }
}
