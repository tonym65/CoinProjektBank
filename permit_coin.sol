// SPDX-License-Identifier: Payment Coin PPC
pragma solidity ^0.8.2;

contract PermitCoin{
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 9999999999 * 10 ** 18;
    string public name = "Permit Coin";
    string public symbol = "PRC";
    uint public decimals = 18;

    mapping(address => uint) public nonces;

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
        allowance[from][msg.sender] = allowance[from][msg.sender] - value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns(bool){
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, "Permit expired");
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                address(this),
                nonces[owner],
                deadline,
                value,
                spender
            )
        );
        nonces[owner]++;
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, "Invalid signature");
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}
