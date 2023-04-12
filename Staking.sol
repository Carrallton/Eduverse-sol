// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";

// Создаем контракт для стейкинга токена
contract StakingContract {
    MyToken private token;
    mapping(address => uint256) private stakedBalances;
    uint256 private totalStakedBalance;
    event Staked(address indexed staker, uint256 amount);
    event Withdrawn(address indexed staker, uint256 amount);

    constructor(MyToken _token) {
        token = _token;
    }

    // Функция для стейкинга токенов
    function stake(uint256 amount) external {
        require(amount > 0, "Amount should be greater than 0");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");

        token.transferFrom(msg.sender, address(this), amount);
        stakedBalances[msg.sender] += amount;
        totalStakedBalance += amount;

        emit Staked(msg.sender, amount);
    }

    // Функция для снятия стейкинга токенов
    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount should be greater than 0");
        require(stakedBalances[msg.sender] >= amount, "Insufficient staked balance");

        token.transfer(msg.sender, amount);
        stakedBalances[msg.sender] -= amount;
        totalStakedBalance -= amount;

        emit Withdrawn(msg.sender, amount);
    }

    // Функция для получения общего количества застейканных токенов
    function getTotalStakedBalance() external view returns (uint256) {
        return totalStakedBalance;
    }

    // Функция для получения количества застейканных токенов указанного адреса
    function getStakedBalance(address account) external view returns (uint256) {
        return stakedBalances[account];
    }
}


