// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract PiggyBank {
    mapping(address => mapping(address => uint256)) private _balances;

    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdrawal(address indexed user, address indexed token, uint256 amount);

    constructor() {}

    function deposit(address token, uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than 0");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        _balances[msg.sender][token] += amount;
        
        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(address token, uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(_balances[msg.sender][token] >= amount, "Insufficient balance");
        
        _balances[msg.sender][token] -= amount;
        require(IERC20(token).transfer(msg.sender, amount), "Transfer failed");
        
        emit Withdrawal(msg.sender, token, amount);
    }

    function getBalance(address user, address token) external view returns (uint256) {
        return _balances[user][token];
    }
}