//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MillionDogeClub is Ownable, ERC721A, ReentrancyGuard {
    constructor() ERC721A("MillionDogeClub", "MDC") {}

    function mint(address recipient, uint256 quantity) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        _mint(recipient, quantity);
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, it can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
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
