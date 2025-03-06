// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SimpleToken Contract (ERC-20 Standard)
contract SimpleToken {
    // Token details
    string public name = "SimpleToken"; // Name of the token
    string public symbol = "STK"; // Symbol of the token
    uint8 public decimals = 18; // Decimal precision
    uint256 public totalSupply; // Total supply of tokens

    // Mappings to store balances and allowances
    mapping(address => uint256) public balanceOf; // Tracks token balances
    mapping(address => mapping(address => uint256)) public allowance; // Tracks spending allowances

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value); // Triggered on token transfers
    event Approval(address indexed owner, address indexed spender, uint256 value); // Triggered on approvals

    // Constructor - Initializes the contract
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals); // Set total supply
        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the deployer
        emit Transfer(address(0), msg.sender, totalSupply); // Emit transfer event
    }

    // Transfer tokens from the sender to another address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance"); // Check if sender has enough tokens
        balanceOf[msg.sender] -= _value; // Deduct from sender's balance
        balanceOf[_to] += _value; // Add to recipient's balance
        emit Transfer(msg.sender, _to, _value); // Emit transfer event
        return true;
    }

    // Approve another address to spend tokens on behalf of the sender
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value; // Set allowance
        emit Approval(msg.sender, _spender, _value); // Emit approval event
        return true;
    }

    // Transfer tokens on behalf of an approved address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance"); // Check if sender has enough tokens
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded"); // Check if allowance is sufficient
        balanceOf[_from] -= _value; // Deduct from sender's balance
        balanceOf[_to] += _value; // Add to recipient's balance
        allowance[_from][msg.sender] -= _value; // Deduct from allowance
        emit Transfer(_from, _to, _value); // Emit transfer event
        return true;
    }
}
