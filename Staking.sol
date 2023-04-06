// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Token.sol";

contract Staking {
    Token public token;
    mapping(address => uint) public stakes;
    mapping(address => uint) public rewards;
    uint public totalStakes;
    uint public rewardPerStake;

    constructor(Token _token) {
        token = _token;
        rewardPerStake = 25; // Здесь устанавливаем количество токенов награды, которые будут получать пользователи за стейкинг в 1 токен
    }

    function stake(uint _amount) public {
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        stakes[msg.sender] += _amount;
        totalStakes += _amount;
    }

    function unstake(uint _amount) public {
        require(stakes[msg.sender] >= _amount, "Insufficient stake");

        uint reward = calculateReward(msg.sender);

        stakes[msg.sender] -= _amount;
        totalStakes -= _amount;

        require(token.transfer(msg.sender, _amount + reward), "Transfer failed");

        rewards[msg.sender] = reward;
    }

    function calculateReward(address _addr) public view returns (uint) {
        return stakes[_addr] * rewardPerStake - rewards[_addr];
    }
}
