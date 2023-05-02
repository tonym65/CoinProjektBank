// SPDX-License-Identifier: Payment Coin Vertrag
pragma solidity ^0.8.2;

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

contract PaymentCoinContract{
    mapping(address => uint) public transfer_balances;
    IERC20 token;
    
    address public admin;    

    constructor(address _tokenContract) {
        admin = msg.sender;    
        token = IERC20(_tokenContract);
    }

    function transfer_save(address to, uint256 value) external payable {
        transfer_balances[to] += value;      
    }

    function withdrawToken(address to, uint256 value) external {
        require(msg.sender==admin,'allow only admin');       
        token.transfer(to, value);
    }
}
