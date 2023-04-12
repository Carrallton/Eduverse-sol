// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Импортируем необходимые библиотеки OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Создаем контракт для нашего токена
contract MyToken is ERC20, Ownable {
    // Конструктор для создания токена
    constructor() ERC20("Eduverse", "EDV") {
        _mint(msg.sender, 1000000 * 10**18);
    }

    // Функция для добавления токенов на баланс указанного адреса
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    // Функция для сжигания токенов с баланса отправителя
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Функция для перевода токенов с баланса отправителя на баланс получателя
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // Функция для проверки баланса токенов на балансе указанного адреса
    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }

    // Функция для проверки доступного количества токенов для перевода с баланса отправителя на баланс получателя
    function allowance(address owner, address spender) public view override returns (uint256) {
        return super.allowance(owner, spender);
    }

    // Функция для разрешения перевода токенов с баланса отправителя на баланс получателя
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    // Функция для перевода токенов с баланса отправителя на баланс получателя при наличии разрешения
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), super.allowance(sender, _msgSender()) - amount);
        return true;
    }
}