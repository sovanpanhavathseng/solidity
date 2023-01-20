// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract UncheckedMath {
    function add(uint x, uint y) external pure returns (uint) {
        // 22291
        // return x +y;

        // 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns (uint) {
        // 22307 gas
        return x - y;

        // 22125 gas
        // unchecked {
        //     return x - y;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns (uint) {
        unchecked {
            uint x3 = x * x * x;
            uint y3 = y * y * y;
            return x3 + y3;
        }
    }
}
