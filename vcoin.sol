/*
Corin Rose
email@corinrose.website

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
he Free Software Foundation, either version 3 of the License, or
at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

pragma solidity ^0.4.4;

contract ERC20Interface {
    
    function totalSupply() public constant returns (uint256 totalSupply);
    function balanceOf(address owner) public returns (uint256 balance);
    function allowance(address owner, address spender) public constant returns (uint256 remaining);
    function transfer(address to, uint256 amount) public returns (bool success);
    function approve(address spender, uint256 amount) public returns (bool success);
    function transferFrom(address from, address to, uint256 amount) public returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}

contract ERC20Token is ERC20Interface {
    
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;
    
    function transfer(address to, uint256 amount) public returns (bool success) {
        // First we need to check if the sender has enough
        if (balances[msg.sender] >= amount && amount > 0) {
            // if the sender has enough, subtract it from their balance and at it to the reciever's
            balances[msg.sender] -= amount;
            balances[to] += amount;
            // emit an event to inform the network of the transfer
            emit Transfer(msg.sender, to, amount);
            return true;
        } else { return false; }
    }
    
    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
        // First we need to check if the sender has enough
        if (balances[from] >= amount && amount > 0 && allowed[from][msg.sender] >= amount) {
            // if the sender has enough, subtract it from their balance and at it to the reciever's
            balances[from] -= amount;
            balances[to] += amount;
            // subtract the amount from senders allowed spending of from address
            allowed[from][msg.sender] -= amount;
            // emit an event to inform the network of the transfer
            emit Transfer(from, to, amount);
            return true;
        } else { return false; }
    }
 
    function balanceOf(address owner) public returns (uint256 balance) {
        return balances[owner];
    }
    
    function approve(address spender, uint256 amount) public returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public constant returns (uint256 remaining) {
        return allowed[owner][spender];
    }
    function totalSupply() public constant returns (uint256 totalSupply) {
        return totalSupply;
    }
}

contract Vcoin is ERC20Token {
    string public name;
    uint8 public decimals = 18;
    string public symbol;
    string public version = "1.0";
    uint public ETHRate;
    address public fundsWallet;
    
    // constructor
    constructor() public {
     balances[msg.sender] = 1000000000000000000000000;
     totalSupply = 1000000000000000000000000;
     name = "VCoin";
     symbol = "VCC";
     version = "1.0";
     ETHRate = 100000;
     fundsWallet = msg.sender;
    }
    
    function() public payable {
        uint256 amount = msg.value * ETHRate;
        require(balances[fundsWallet] >= amount);
        
        balances[fundsWallet] -= amount;
        balances[msg.sender] += amount;
        
        emit Transfer(fundsWallet, msg.sender, amount);
        
        fundsWallet.transfer(msg.value);
    }
}
