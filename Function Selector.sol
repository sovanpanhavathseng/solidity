// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunctionSelector {
    function getSalector(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

contract Receiver {
    event Log(bytes data);

    function transfer(address _to, uint _amount) external {
        emit Log(msg.data);
        // 0xa9059cbb
        // 0000000000000000000000000000000005b38da6a701c568545dcfb03fcb875f56beddc
        // 40000000000000000000000000000000000000000000000000000000000000000000000b
    }
}
