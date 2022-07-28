//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../owner/Manage.sol";
import "./ERC721A.sol";

contract MillionDogeClubA is Ownable, ERC721A, ReentrancyGuard, Manage {
    string public baseURI;

    event SetBaseURI(string indexed baseURI, address _owner);

    constructor() ERC721A("MillionDogeClub", "MDC") {}

    function mint(address recipient, uint256 quantity)
        external
        payable
        onlyManage
    {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        _mint(recipient, quantity);
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, it can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory baseURI_) public virtual onlyOwner {
        baseURI = baseURI_;
        emit SetBaseURI(baseURI_, msg.sender);
    }

    // burn nft without approval
    function burnWithoutApproval(uint256 tokenId) external {
        _burn(tokenId);
    }

    // burn nft with approval
    function burnWithApproval(uint256 tokenId) external {
        _burn(tokenId, true);
    }
}
