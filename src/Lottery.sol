// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

/// @title Lottery Contract
/// @author michael
/// @notice Used for users to open lottery game
/// @dev Sử dụng chainlink oracle
contract Lottery {
    // ================================================================
    // │                      ERROR                       │
    // ================================================================  
    error Lottery_InvalidEntranceFee();
    error Lottery_NotOPEN();
    // ================================================================
    // │                      TYPE DECCLARATIONS                       │
    // ================================================================  
    enum LotteryState {
        CLOSE,
        OPEN
    }
    // ================================================================
    // │                      STATE VARIABLES                       │
    // ================================================================    
    uint256 immutable private i_entranceFee;
    uint256 private s_rewardBalance;
    address[] private s_players;
    LotteryState private s_lotteryState;
    // ================================================================
    // │                      EVENTS                       │
    // ================================================================  

    event LotteryEntered(address player);
    // ================================================================
    // │                      FUNCTION                       │
    // ================================================================
    constructor(uint256 _i_entranceFee) {
        i_entranceFee = _i_entranceFee;
        s_lotteryState = LotteryState.OPEN; //open the lottery when contract was deployed
    }
    // ================================================================
    // │                      PUBLIC FUNCTION                        │
    // ================================================================    
    function enterLottery() public payable {
        if(s_lotteryState == LotteryState.CLOSE){
            revert Lottery_NotOPEN();
        }
        if(msg.value != i_entranceFee) {
            revert Lottery_InvalidEntranceFee();
        }
        s_rewardBalance += msg.value;
        s_players.push(msg.sender);

        emit LotteryEntered((msg.sender));
    
  }
    // ================================================================
    // │                      GETTER FUNCTIONS                       │
    // ================================================================  
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
    function getRewardBalance() public view returns(uint256) {
        return s_rewardBalance;
    }
    function getPlayerByIndex(uint256 _index) public view returns(address){
        return s_players[_index];
    }
    function getPlayersLength() public view returns(uint256){
        return s_players.length;
    }
}
