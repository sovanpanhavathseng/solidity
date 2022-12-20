// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Transparent upgradeable proxy pattern
// Topice
// - Intro (wrong way)
// - Renturn data from fallback
// - Storage for implementation and admin
// - Separte user / admin interfaces
// - Proxy admin
// - Demo

contract CounterV1 {
    address public implementation;
    address public admin;
    uint public count;

    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
    address public implementation;
    address public admin;
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}

contract BuggyProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _impementation) external {
        require(msg.sender == admin, "not authorized");
        implementation = _impementation;
    }
}
