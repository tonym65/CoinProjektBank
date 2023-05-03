// SPDX-License-Identifier: Payment Coin Vertrag
pragma solidity ^0.8.2;

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

contract PaymentCoinContract{
    mapping(address => uint) public transfer_balances;
    uint public payment_counter = 0;
    uint public payment_counter_check = 0;
    IERC20 token;    
    
    address public admin;    
    address public machine; 

    constructor(address _tokenContract, address _machine) {
        admin = msg.sender; 
        machine = _machine;     
        token = IERC20(_tokenContract);
    }

    receive() external payable {
    }

    function transfer_payment_counter() public returns(bool){
        payment_counter += 1;    
        return true;  
    }

    function transfer_save(address to, uint256 value) public returns(bool){
        transfer_balances[to] += value;    
        return true;  
    }

    function withdrawToken(address to) external {
        require(msg.sender==admin,'allow only admin');       
        require(transfer_balances[to]>0, 'balance too low');
        require(payment_counter_check!=payment_counter, 'no payment needed');
        
        uint value = transfer_balances[to]; 

        transfer_balances[to] = 0;
        token.transfer(to, value);
    }
}
