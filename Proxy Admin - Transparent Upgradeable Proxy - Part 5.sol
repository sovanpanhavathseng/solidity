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
    uint public count;

    function inc() external {
        count += 1;
    }

    function admin() external view returns (address) {
        return address(1);
    }

    function implementation() external view returns (address) {
        return address(2);
    }
}

contract CounterV2 {
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

            // calldatacopy(t, f, s)
            // - copy s bytes from calldata at position f to mem at pasition t
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
                gas(), _implementation, 0, calldatasize(), 0, 0
            )

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

    function _fallback() private {
        _fallback();
    }

    fallback() external payable {
        _fallback();
    }  

    receive() external payable {
        _delegate(_getImplementation());
    }

    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    function changeAdmin(address _admin) external ifAdmin {
        _setAdmin(_admin);
    }

    function upgradeTo(address _impementation) external ifAdmin {
        _setImplementation(_impementation);
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

    function admin() external ifAdmin returns (address) {
        return _getAdimin();
    }

    function implementation() external ifAdmin returns (address) {
        return _getImplementation();
    } 
}

contract ProxyAdmin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    function getProxyAdmin(address proxy) external view returns (address) {
        (bool ok, bttes mamery res) = proxy.staticcall(
            abi.enCode(Proxy.admin, ()
        );

        require(ok, "call failed");
        return  abi.decode(res, (address));
    }

    function changeProxyAdmin(address payable proxy, address _admin )
        external onlyOwner
    {
        Proxy(proxy).changeAdmin(_admin);
    }

    function upgrade(address payable proxy, address implementatoin) 
        external onlyOwner
    {
        Proxy(proxy).upradeTo(implementatoin);
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
