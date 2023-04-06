// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "Token.sol";

contract Farming {
    Token public token;

    address public owner;

    struct Stake {
        uint256 amount;
        uint256 start;
        uint256 end;
    }

    mapping (address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount, uint256 start, uint256 end);
    event Withdrawn(address indexed user, uint256 amount);
    event Reward(address indexed user, uint256 amount);

    constructor(Token _token) {
        token = _token;
        owner = msg.sender;
    }

    function stake(uint256 amount, uint256 duration) external {
        require(token.balanceOf(msg.sender) >= amount, "Not enough tokens to stake");
        require(stakes[msg.sender].amount == 0, "Already staked");
        
        uint256 start = block.timestamp;
        uint256 end = start + duration;
        stakes[msg.sender] = Stake(amount, start, end);

        token.transferFrom(msg.sender, address(this), amount);

        emit Staked(msg.sender, amount, start, end);
    }

    function withdraw() external {
        require(stakes[msg.sender].end < block.timestamp, "Staking period not over");
        
        uint256 amount = stakes[msg.sender].amount;
        stakes[msg.sender].amount = 0;

        token.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    function reward() external {
        require(stakes[msg.sender].end < block.timestamp, "Staking period not over");

        uint256 amount = calculateReward(msg.sender);
        require(amount > 0, "No reward to claim");

        stakes[msg.sender].start = block.timestamp;
        
        token.transfer(msg.sender, amount);

        emit Reward(msg.sender, amount);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory s = stakes[user];
        uint256 duration = s.end - s.start;
        uint256 rewardRate = 1000;
        uint256 reward = (s.amount * duration * rewardRate) / 31536000; // 1 year
        return reward;
    }
}
