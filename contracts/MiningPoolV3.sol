//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";
import "./interface/IERC2917.sol";

contract MiningPoolV3 is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    ILevel public level;
    IRepository property;
    IERC2917 cberus;
    IERC721 mdc;

    mapping(uint256 => uint256) public hashRateOfToken;
    mapping(address => uint256) public hashRateOfAddress;
    mapping(uint256 => address) public tokenOwnerOf;

    constructor(
        address _pro,
        address _cberus,
        address _level,
        address _mdc
    ) {
        property = IRepository(_pro);
        level = ILevel(_level);
        cberus = IERC2917(_cberus);
        mdc = IERC721(_mdc);
    }

    function stake(uint256 _tokenId) external {
        uint256 _rate = property.tokenHashRate(_tokenId);
        require(_rate > 0, "rate is zero");
        // current holder
        address owner = mdc.ownerOf(_tokenId);
        require(owner == msg.sender, "not owner");

        hashRateOfToken[_tokenId] = _rate;
        //
        address holder = tokenOwnerOf[_tokenId];
        if (holder == address(0) || holder == owner) {
            cberus.increaseHashRate(msg.sender, _rate);
            hashRateOfAddress[owner] = hashRateOfAddress[owner].add(_rate);
        } else {
            cberus.decreaseHashRate(holder, _rate);
            hashRateOfAddress[holder] = hashRateOfAddress[holder].sub(_rate);
        }

        emit Stake(msg.sender, _tokenId);
    }

    function unStake(uint256 _tokenId) external {
        address owner = mdc.ownerOf(_tokenId);
        require(owner == msg.sender, "not owner");

        uint256 _rate = property.tokenHashRate(_tokenId);
        require(_rate > 0, "rate is zero");
        cberus.decreaseHashRate(msg.sender, _rate);
        hashRateOfToken[_tokenId] = hashRateOfToken[_tokenId].sub(_rate);
        emit UnStake(msg.sender, _tokenId);
    }

    event Stake(address owner, uint256 tokenId);
    event UnStake(address owner, uint256 tokenId);
}
