// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ProjectAdmin} from "../src/ProjectAdmin.sol";
import {Treasury} from "../src/treasury/Treasury.sol";
import {TreasuryImplement} from "../src/treasury/TreasuryImplement.sol";
import {AToken} from "../src/tokens/AToken.sol";
import {BToken} from "../src/tokens/BToken.sol";
import {USDT} from "../src/tokens/USDT.sol";
import {FundPool} from "../src/fundpool/FundPool.sol";
import {FundPoolImplement} from "../src/fundpool/FundPoolImplement.sol";

import "forge-std/Script.sol";

contract Deploy is Script {

    function run() external returns (ProjectAdmin, Treasury, AToken, BToken, USDT,FundPool) {

        vm.startBroadcast();

        // Admin
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        ProjectAdmin projectAdmin = new ProjectAdmin();

        // Treasury contract
        TreasuryImplement treasuryImplement = new TreasuryImplement();
        Treasury treasury = new Treasury(address(treasuryImplement), address(projectAdmin), "");

        // Token contract
        AToken aToken = new AToken(address(treasury));
        BToken bToken = new BToken(address(treasury));
        USDT usdt = new USDT();

        // Fundpool contract 
        FundPoolImplement fundPoolImplement = new FundPoolImplement();
        FundPool fundPool = new FundPool(address(fundPoolImplement), address(projectAdmin), "");

        TreasuryImplement(address(treasury)).initialize(owner, address(aToken), address(bToken), address(usdt), payable(address(fundPool)));
        vm.stopBroadcast();
        
        return (projectAdmin, treasury, aToken, bToken, usdt, fundPool);
    }
}