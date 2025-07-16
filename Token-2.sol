// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";


contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name; // Ether
    string private _symbol; // ETH

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = 1000000 * (10 ** decimals());
        _balance[_msgSender()] += _totalSupply;
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    function name() public view returns(string memory) {
        return _name;
    }
    function symbol() public view returns(string memory) {
        return _symbol;
    }
    function decimals() public pure returns(uint8) {
        return 18;
    }
    function totalSupply() public view returns(uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view returns(uint256) {
        return _balance[account];
    }
    function transfer(address to, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }
    function allowance(address owner, address spender) public view returns(uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
    function transferFrom(address from, address to,uint256 amount  ) public returns(bool) {
        _transfer(from, to, amount);
        return true;
    }
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Erc20 transfer from zero address not acceptable");
        require(to != address(0), "Erc20 transfer to zero address not acceptable");

        uint256 fromBalance = _balance[from];
        require(fromBalance >= amount,"Not enough tokens");
        _balance[from] = fromBalance - amount;
        _balance[to] += amount;

        emit Transfer(from, to, amount);
    }

    function mint(address account, uint256 amount) public {
        require(account != address(0),"mint to the zero address is not acceptable");

        _totalSupply += amount;

        emit Transfer(address(0), account, amount);
    }
    function burn(address account, uint256 amount) public {
        require(account != address(0),"burn from the zero address is not acceptable");

        uint256 accountBalance = _balance[account];
        require(accountBalance >= amount,"Not enough tokens");

        _balance[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0));
        require(spender != address(0));

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }


}
