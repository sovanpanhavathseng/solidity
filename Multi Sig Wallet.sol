// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txTd);
    event Approve(address indexed owner, uint indexed txTd);
    event Revoke(address indexed owner, uint indexed txTd);
    event Execute(uint indexed txTd);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool Executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    Transactin[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transaction.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[txId].executed, "tx already approved");
        _;    
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;    
    }
    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners require");
        require(
            _rquired > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not uniqu");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.sender);

        function submit(address _to, uint _value, bytes calldata _data); 
            external
            onlyOwner
        {
            transaction.push(Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false
            }));
            emit Submit(transaction.length - 1);
        }

        function approve(uint _txId) 
            external 
            onlyOwner
            txExists(_txId)
            notApproved(_txId)
            notExecuted(_txId)
        {
            approved[_txId][msg.sender] = true;
            emit Approve(msg.sender, txTd);
        }

        function _getApprovalCount(uint _txId) private view returns (uint count) {
            for (uint i; i < owners.length; i++) {
                if (approved[_txId][owners[i]]) {
                    count += 1;
                }
            }
        }
    }

    function execute(uint _txTd) external txExists(_txTd) notExecuted(_txTd) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        transaction storage transaction = transaction = Transaction[_txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: Transaction.value}(
            Transaction.data
        );
        require(success, "tx failed");

        emit Execute(_txId);
    }

    function Revoke(uint, _txTd)
        external 
        onlyOwner
        txExists(_txId)
        notExecuted(msg.sender, _txId)
    {
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txTd);
    }
}
