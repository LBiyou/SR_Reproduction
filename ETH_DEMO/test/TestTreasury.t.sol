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

import "forge-std/Test.sol";

contract TestTreasury is Test {

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
        treasury = new Treasury(address(treasuryImplement),address(projectAdmin),"");
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

    function beforeTest(address _treasury, uint256 amount) internal {
        usdt.approve(address(_treasury), amount);
        bytes memory data = abi.encodeWithSignature(
            "depositToken(uint256)", amount
        );
        (bool success, ) = address(_treasury).call(data);
        require(success, "call faild");
    }

    function testDeposit() external {

        vm.startPrank(user1);
        beforeTest(address(treasury), 1 ether);
        uint256 funds = TreasuryImplement(address(treasury)).getUserFunds();
        emit log_named_uint("Treasury's funds  =>",(funds));

        uint256 aTokenBalance = aToken.balanceOf(address(fundPool));
        emit log_named_uint("FundPool's AToken =>", (aTokenBalance));

        uint256 bTokenBalance = bToken.balanceOf(address(user1));
        emit log_named_uint("User1's BToken    =>", (bTokenBalance));

        uint256 usdt_Balance = usdt.balanceOf(address(user1));
        emit log_named_uint("User1's  USDT     =>", (usdt_Balance));

        vm.stopPrank();
    }

    function testWithdraw() external {

        vm.startPrank(user1);
        beforeTest(address(treasury), 1 ether);
        TreasuryImplement(address(treasury)).withdraw(1 ether);

        uint256 bTokenBalance = bToken.balanceOf(address(user1));
        emit log_named_uint("User1's BToken =>", bTokenBalance);

        uint256 usdt_Balance = usdt.balanceOf(address(user1));
        emit log_named_uint("User1's  USDT  =>", usdt_Balance);

    }
}
