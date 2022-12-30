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
        assembly {
            // Copy msg.data. We toke full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memery position 0.

            // calldatacopy(t, f, s) - copy s bytes from calldata at position f to memery
            // calldatasize() - size of call data in byte
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know  the size yet.

            // delegatecall(g, a, in, insize , out, outsize) 
            // - call contract at address a
            // - with input mem[in...(out+outsize))
            // - providing g gas
            // - and output area mem[in...(out+outsize))
            // - returning 0 on error (eg. out of gas) and 1 on success
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, calldatasize(), 0,)

            // Copy the returned data.
            // returndatacopy(t, f, s) - copy s bytes from returndata at position f t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())

            swith result
            // dalegatecall returns 0 on error
            case 0 {
                // revert(p, s) 
                // - end excution, revert state changes, return data mem[p...(p+s))
                revert(0, returndatasize)
            }
            fefault {
                // return(p, s) - end execution, return data mem[p...(p+s))
                return(0, returndatasize())
            }
        }
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
