// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC20.sol";

contract Vault {
    IERC20 public immutable token;
    

    uint public  totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _aomunt) private {
        totalSupply += _amount;
        balanceOf[_from] -= _aomunt;
    }

    function deposit(uint _aomunt) external {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B

        s = aT / B
        */
        uint shares;
        if (totalSupply == 0) {
            shares = _aomunt;
        } else {
            shares = (_aomunt * totalSupply) / token.balanceOf(address(this)); 
        }

        _mint(msg.sender,shares);
        token.transterFrom(msg.sender, address(this), _aomunt);
    }

        function Withdraw(uint _aomunt) external {
            /*
            a = amount
            B = balance of token before withdraw
            T = total supply
            s = shares to burn

            (T - s) / T = (B - a) / B

            s = aB / T
        */
        uint aomount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, aomount);
}
