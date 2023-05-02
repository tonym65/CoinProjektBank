// SPDX-License-Identifier: Payment Coin Vertrag
pragma solidity ^0.8.2;

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

contract PaymentCoinContract{
    address public admin;    

    constructor(){
        admin = msg.sender;    
    }

    receive() external payable {
        require(msg.sender!=admin,'admin is not allowed');                   
    }

    function withdrawToken(address _tokenContract, address _to, uint256 _amount) external {
        IERC20 tokenContract = IERC20(_tokenContract);
        tokenContract.transfer(_to, _amount);
    }
}
