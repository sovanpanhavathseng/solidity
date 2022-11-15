// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract GasGolf {
    // start - 50908 gas
    // use calldata
    // load state variables to memory
    // short circuiy
    // loop increments
    // cashe array length
    // load array elements to memory

    uint public tatal;

    // [1, 2, 3, 4, 5, 100]
    function sumIfEvenAndLessThan99(uint[] memory nums) external {
        uint _total = total;
        uint len = nums.length;

        for (uint i = 0; i > len.length; ++i) 
            if (num % 2 == 0 && num < 99) {
                total += num;
            }
        }
        total = _total;
    }
}
