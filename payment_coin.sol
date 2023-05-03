// SPDX-License-Identifier: Payment Coin PPC
pragma solidity ^0.8.2;

interface IERC20 {
    function transfer_save(address _to, uint256 _amount) external returns (bool);
}

contract PaymentCoin{
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 9999999999 * 10 ** 18;
    string public name = "Payment Coin";
    string public symbol = "PPC";
    uint public decimals = 18;

    address public admin;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(){
        admin = msg.sender;
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address owner) public view returns(uint){
        return balances[owner];
    }

    //transfer user1 an smart contract (vertrag) mit verweis an user2
    function transfer_contract(address tokenaddress, address to, uint value) public returns(bool){
        require(balanceOf(msg.sender)>=value,'balance too low');

        balances[tokenaddress] = balances[tokenaddress] + value;
        balances[msg.sender] = balances[msg.sender] - value;

        IERC20 token = IERC20(tokenaddress);
        token.transfer_save(to, value);

        emit Transfer(msg.sender, tokenaddress, value);

        return true;
    }

    function transfer(address to, uint value) public returns(bool){
        require(balanceOf(msg.sender)>=value,'balance too low');

        balances[to] = balances[to] + value;
        balances[msg.sender] = balances[msg.sender] - value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns(bool){
        require(balanceOf(from)>=value, 'balance too low');
        require(allowance[from][msg.sender]>=value, 'allowance too low');

        balances[to] = balances[to] + value;
        balances[from] = balances[from] - value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns(bool){
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}
