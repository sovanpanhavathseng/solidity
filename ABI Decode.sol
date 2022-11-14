// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ABIDecode {
    struct MyStruct {
        string name;
        uint[2] nums;
    }

    function encode(
        uint x,
        address addr,
        uint[] calldata arr,
        My calldata mysSruct
    ) external pure returns (bytes memory) {
        return abi.encode((x, addr, arr, myStruct));
    }

    function decode(bytes calldata data)
        external pure
        returns (
            uint x,
            address addr,
            uint[] memory arr,
            MyStruct memory myStruct
        )
    {
        (x, addr, myStruct) = abi.decode(data, (uint, address, uint[], MyStruct))
    }
}
