// SPDX-License-Identifier: Payment Coin Vertrag
pragma solidity ^0.8.2;

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
    function balanceOf(address owner) external returns (uint);
}

contract PaymentCoinContract{
    mapping(address => uint) public transfer_balances;
    mapping(uint => address) public transfer_list;
    IERC20 public token;
    uint public transfer_balances_length = 0; 
    
    address public admin;    
    address public tokenContract;

    constructor(address _tokenContract) {
        admin = msg.sender;    
        tokenContract = _tokenContract; 
        token = IERC20(tokenContract);
    }

    receive() external payable {
        require(msg.sender!=admin,'admin is not allowed');                   
    }

    function sendpayment(address _to, uint256 _amount) external payable {
        require(token.balanceOf(msg.sender)>=_amount,'balance too low');
        if(transfer_balances[_to]==0){    
            transfer_list[transfer_balances_length] = _to;
            transfer_balances_length = transfer_balances_length + 1;
        }       

        transfer_balances[_to] += _amount;     
        token.transfer(address(this), _amount);    
    }

    function withdrawToken(address _to, uint256 _amount) external {
        require(msg.sender==admin,'allow only admin');       
        token.transfer(_to, _amount);
    }
}
