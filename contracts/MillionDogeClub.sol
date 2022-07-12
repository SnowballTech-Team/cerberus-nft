//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MillionDogeClub is Ownable, ERC721Pausable, ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    string public baseURI;

    constructor() ERC721("MillionDogeClub", "MDC") {
        setBaseURI("");
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory baseURI_) public virtual onlyOwner {
        baseURI = baseURI_;
        emit SetBaseURI(baseURI_, msg.sender);
    }

    function mint(address player) external returns (uint256) {
        _tokenIds.increment();
        uint256 id = _tokenIds.current();
        _mint(player, id);
        return id;
    }

    function burn(uint256 tokenId) external virtual {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    function pause() external onlyOwner {
        _pause();
        emit SetPause(msg.sender);
    }

    function unpause() external onlyOwner {
        _unpause();
        emit SetUnPause(msg.sender);
    }

    event SetBaseURI(string indexed baseURI, address _owner);
    event SetPause(address _owner);
    event SetUnPause(address _owner);
}
