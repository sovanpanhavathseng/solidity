// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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

contract Proxy {
    bytes32 public constant IMPLEMENTATION_SLOT = bytes32(
        uint(keccak256("eip1967.proxy.implementation")) - 1
    );
    bytes32 public constant ADMIN_SLOT = bytes32(
        uint(keccak256("eip1967.proxy.adimin")) - 1
    );

    constructor() {
        _setAdmin(msg.sender);
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
            let result := delegatecall(
            gas(), _implementation, 0, calldatasize(), 0, calldatasize(), 0, 0

            // Copy the returned data.
            // returndatacopy(t, f, s)
            // - copy s bytes from returndata at position f t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())

            switch result
            // dalegatecall returns 0 on error
            case 0 {
                // revert(p, s) 
                // - end excution, revert state changes, return data mem[p...(p+s))
                revert(0, returndatasize())
            }
            default  {
                // return(p, s) - end execution, return data mem[p...(p+s))
                return(0, returndatasize())
            }
        }
    }

    fallback() external payable {
        _delegate(_getImplementation());
    }  

    receive() external payable {
        _delegate(_getImplementation());
    }

    function upgradeTo(address _impementation) external {
        require(msg.sender == _getAdmin, "not authorized");
        _setImplementation = (_impementation)
    }

    function _getAdimin() private view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    function _setAdmin(address _admin) private {
        require(_admin != address(0), "admin = zero address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setImplementatoin(address _impementation) private {
        require(_impementation.code.length > 0 "not a contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _impementation;
    }
}

library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(bytes32 slot) internal pure 
        returns (AddressSlot storage r)
    {
          assembly {
              r.slot := slot
          }
    }
}

contract TestSlot {
    bytes32 public constant SLOT = keccak256("TEST_SLOT");

    function getSlot() external view returns (address) {
        return StorageSlot.getAddressSlot(SLOT).value;
    }

    function writeSLot(address _addr) external {
        StorageSlot.getAddressSlot(SLOT).value = _addr;
    }
}
