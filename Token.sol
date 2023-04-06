// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Импортируем стандартные библиотеки
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Создаем контракт для нашего токена
contract MyToken is ERC20, Ownable {
    using SafeMath for uint256;

    // Создаем переменную для хранения стоимости курса в токенах
    uint256 public coursePrice;

    // Создаем событие для уведомления об изменении стоимости курса
    event CoursePriceChanged(uint256 newPrice);

    // Конструктор контракта
    constructor(uint256 initialSupply) ERC20("Eduverse", "EDV") {
        _mint(msg.sender, initialSupply);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value > 0, "Value must be greater than zero");
        require(_value <= allowance[_from][msg.sender], "Not enough allowance");
        require(balanceOf(_from) >= _value, "Not enough tokens");
        
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }

    // Функция для изменения стоимости курса
    function setCoursePrice(uint256 _newPrice) public onlyOwner {
        require(_newPrice > 0, "Price must be greater than zero");
        coursePrice = _newPrice;
        emit CoursePriceChanged(_newPrice);
    }

    // Функция для покупки курсов или учебников за токены
    function buyCourse() public onlyValidAddress {
        require(balanceOf(msg.sender) >= coursePrice, "Not enough tokens to buy the course");
        _transfer(msg.sender, owner(), coursePrice);
        // Здесь должен быть код для начисления курса пользователю
    }

    // Функция для безопасной передачи токена другому адресу
    function safeTransfer(address _to, uint256 _value) public onlyValidAddress {
        require(_to != address(0), "Invalid address");
        require(_value > 0, "Value must be greater than zero");
        require(balanceOf(msg.sender) >= _value, "Not enough tokens");
        require(transfer(_to, _value), "Transfer failed");
    }

    // Модификатор для ограничения доступа только владельцу контракта
    modifier onlyOwner() {
        require(msg.sender == owner(), "Only owner can call this function");
        _;
    }

    // Модификатор для проверки корректности ввода адреса
    modifier onlyValidAddress() {
        require(msg.sender != address(0), "Invalid address");
        _;
    }
}
