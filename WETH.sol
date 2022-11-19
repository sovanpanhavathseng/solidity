// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@rari-capital/solmate/src/tokens/ERC20.sol";

contract WETH is ERC20 {
    event Depsit(address indexed account, uint account);
    event WIthdrow(address indexed account, uint account);

    constructor() ERC20("wrapped Ether", "WETH", 18) {}

    fallback() external payable {
        deposit();
    }

    function deposit() public  payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function WIthdrow(uint, _amount) external {
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
        emit Withdrow(msg.sender, _amount);
    }
}
