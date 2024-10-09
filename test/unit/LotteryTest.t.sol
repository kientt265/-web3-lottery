// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployLottery} from "script/DeployLottery.s.sol";
import {Lottery} from "src/Lottery.sol";
import {ENTRANCE_FEE} from "script/Constant.sol";
contract LotteryTest is Test{
    Lottery public lottery;
    address public player = makeAddr("player");
    uint256 public constant INIT_AMOUNT = 10 ether;
    event LotteryEntered(address player);
    function setUp() external {
        DeployLottery deployer = new DeployLottery();
        lottery = deployer.deployLottery();
        vm.deal(player, INIT_AMOUNT);

    }
    function test_setUp() view public{
        assertEq(lottery.getEntranceFee(), ENTRANCE_FEE);
    }
    function test_enterLottery() public {
        //revert when invalid entrance fee
        vm.expectRevert(Lottery.Lottery_InvalidEntranceFee.selector);
        lottery.enterLottery();
        vm.expectEmit();
        emit LotteryEntered(player);
        //Arrange

        //Action
        vm.prank(player);
        lottery.enterLottery{value: ENTRANCE_FEE}();

        // vm.startPrank();
        // vm.stopPrank();
        //Assert 
        assertEq(player.balance, INIT_AMOUNT - ENTRANCE_FEE);
        assertEq(lottery.getRewardBalance(), ENTRANCE_FEE);
        assertEq(player, lottery.getPlayerByIndex(0));
        assertEq(1, lottery.getPlayersLength());
    }
}