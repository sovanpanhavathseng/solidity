// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC165 {
    function supportsInterfacs(bytes4 interfaceID) external view returns (bool);  
}

instance  ERC721 is ERC165 {
    function balanceOf(address owner) external view returns (uint balance);
        
    function ownerOf(uint tokenId) external view returns (address owner);

    function sefeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function sefeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address opertor, bool _approved) external;

    function isApprovedForAll(address owner, address opertor)
        external 
        view 
        returns (bool);
    }

instanceo ERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApplrovalForAll(
        address indexed owner,
        address indexed  opwrator,
        bool approved
    );

    mapping(uint => address) internal _ownerOf;
    mapping(address => uint) internal _balanceOf;
    mapping(uint => address) internal _approvals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterfacs(bytes4 interfaceID) external view returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
    } 

    function balanceOf(address owner) external view returns (uint balance) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }
        
    function ownerOf(uint tokenId) external view returns (address owner) {
        owner = _ownerOf[tokenId];
        require(owner != address(0), "owner = zero address");
    }

    function setApprovalForAll(address opertor, bool _approved) external {
        isApprovedForAll[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function approve(address to, uint tokenId) external {
        address owner = _ownerOf[tokenId];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authoorized"
        );
        _approvals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint tokenId) external view returns (address operator {
        require(_ownerOf[tokenId] != address(0), "token doesn 't exist);
        return _approvals[tokenId];
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) internal view returns (bool) {
        return (
             spender == owner ||
             isApprovedForAll[owner][spender] ||
             spender == _appravals[tokenId]
        );
    }

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) public {
        require(from == _ownerOf[tokenId], "from != owner");
        require(to != address(0), "to = zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        -ownerOf[tokenId] = to;

        delete _approvals[tokenId];

        emit Transfer()
    }


    function sefeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Receiver(msg.sender, from, tokenId,"") ==
                IERC721Receiver.onERC721Recived.selector,
                "unsate recipient"
        )

    // function onERC721Recived(
    //     address operator,
    //     address from,
    //     uint tokenId,
    //     bytes calldata data
    // ) external returns (bytes4);
    }

    function sefeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external {
        transferFeom(trom, to, tokenId);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Receiver(msg.sender, from, tokenId,"") ==
                IERC721Receiver.onERC721Recived.selector,
            "unsate recipient"
        );
    }

    function _mint(address to, uint tokenId) internal {
        require(to != address(0), "to = zero address");
        require(_ownerOf[tokenId] == address(0), "tokenId exists");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint tokenId) internal {
        address owner = _ownerOf[tokenId];
        require(owner != address(0), "token does not exist");

        _balanceOf[owner]--;
        delete _ownerOf[tokenId];
        delete _approvals[tokenId];

        emit  Transfer(owner, address(0), tokenId);
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint tokenId) external {
        _mint(to, tokenId);
    }

    function burn(uint tokenId) external {
        require(msg.sender == _ownerOf[tokenId], "not owner");
        _burn(tokenId);
    }
}
