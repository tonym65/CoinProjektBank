// SPDX-License-Identifier: Payment Coin Vertrag
pragma solidity ^0.8.2;

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

contract PaymentCoinContract{
    address public admin;    
    address public tokenContract;

    constructor(address _tokenContract) {
        admin = msg.sender;    
        tokenContract = _tokenContract; 
    }

    receive() external payable {
        require(msg.sender!=admin,'admin is not allowed');                   
    }

    function sendpayment() external {

    }

    function withdrawToken(address _to, uint256 _amount) external {
        require(msg.sender==admin,'allow only admin');
        IERC20 token = IERC20(tokenContract);
        token.transfer(_to, _amount);
    }
}
