//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";
import "./owner/Manage.sol";

/*
    The Objective of ERC2917 Demo is to implement a decentralized staking mechanism, which calculates users' share
    by accumulating productiviy * time. And calculates users revenue from anytime t0 to t1 by the formula below:
        user_accumulated_productivity(time1) - user_accumulated_productivity(time0)
       _____________________________________________________________________________  * (gross_product(t1) - gross_product(t0))
       total_accumulated_productivity(time1) - total_accumulated_productivity(time0)
*/
contract CBerusPool is Manage, ReentrancyGuard, ERC721Holder {
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using EnumerableSet for EnumerableSet.UintSet;
    using SafeMath for uint256;
    EnumerableMap.UintToAddressMap private tokenOwner;

    ILevel public level;
    IRepository property;
    IERC721 mdc;

    mapping(address => EnumerableSet.UintSet) private _ownedTokens;

    // creation of the interests token.
    constructor(
        uint256 _rate,
        address _pro,
        address _level,
        address _mdc
    ) {
        property = IRepository(_pro);
        level = ILevel(_level);
        mdc = IERC721(_mdc);
    }

    // External function call
    // This function increase user's productivity and updates the global productivity.
    // the users' actual share percentage will calculated by:
    // Formula:     user_productivity / global_productivity
    function stake(uint256 tokenId) external nonReentrant {
        // current holder
        address owner = mdc.ownerOf(tokenId);
        require(owner == msg.sender, "not owner");

        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");

        mdc.transferFrom(msg.sender, address(this), tokenId);
        _ownedTokens[msg.sender].add(tokenId);
        tokenOwner.set(tokenId, msg.sender);
        emit Stake(tokenId, _rate);
    }

    // External function call
    // This function will decreases user's productivity by value, and updates the global productivity
    // it will record which block this is happenning and accumulates the area of (productivity * time)
    function unStake(uint256 tokenId) external nonReentrant {
        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");
        // current holder
        address owner = mdc.ownerOf(tokenId);
        require(owner == msg.sender, "not owner");
        _ownedTokens[msg.sender].remove(tokenId);
        tokenOwner.remove(tokenId);
        mdc.transferFrom(address(this), msg.sender, tokenId);
        emit UnStake(tokenId, 0);
    }

    function ownerOf(uint256 tokenId) private view returns (address) {
        return tokenOwner.get(tokenId, "query for nonexistent token");
    }

    function balanceOfOwner(address owner) public view returns (uint256) {
        require(
            owner != address(0),
            "Staking: balance query for the zero address"
        );
        return _ownedTokens[owner].length();
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        returns (uint256)
    {
        return _ownedTokens[owner].at(index);
    }

    function setMdc(address _token) external onlyManage {
        require(_token != address(0), "token address is zero");
        mdc = IERC721(_token);
        emit SetMdc(msg.sender, _token);
    }

    function setLevel(address _level) external onlyManage {
        require(_level != address(0), "level address is zero");
        level = ILevel(_level);
        emit SetLevel(msg.sender, _level);
    }

    function setProperty(address _property) external onlyManage {
        require(_property != address(0), "level address is zero");
        property = IRepository(_property);
        emit SetProperty(msg.sender, _property);
    }

    event SetMdc(address manage, address _mdc);
    event SetLevel(address manage, address _level);
    event SetProperty(address manage, address _property);
    /// @dev This emit when a users' productivity has changed
    /// It emits with the user's address and the the value after the change.
    event Stake(uint256 indexed tokenId, uint256 value);

    /// @dev This emit when a users' productivity has changed
    /// It emits with the user's address and the the value after the change.
    event UnStake(uint256 indexed tokenId, uint256 value);
}
