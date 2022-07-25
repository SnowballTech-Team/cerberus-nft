//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";
import "./interface/IERC2917.sol";

contract MiningPool is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    ILevel public level;
    IRepository property;
    IERC2917 cberus;

    mapping(uint256 => uint256) public tokenRate;

    constructor(
        address _pro,
        address _cberus,
        address _level
    ) {
        property = IRepository(_pro);
        level = ILevel(_level);
        cberus = IERC2917(_cberus);
    }

    function stake(uint256 _tokenId) external {
        Property memory pro = property.getProperty(_tokenId);
        // get token level
        uint256 lv = level.checkBonus(pro.level);
        // calc current rate
        uint256 _rate = pro.cdoge.mul(lv).div(1000).add(pro.cdoge);

        tokenRate[_tokenId] = tokenRate[_tokenId].add(_rate);
        cberus.increaseProductivity(msg.sender, _rate);
    }

    function unstake(uint256 _tokenId) external {
        Property memory pro = property.getProperty(_tokenId);
        // get token level
        uint256 lv = level.checkBonus(pro.level);
        // calc current rate
        uint256 _rate = pro.cdoge.mul(lv).div(1000).add(pro.cdoge);

        cberus.decreaseProductivity(msg.sender, _rate);
        tokenRate[_tokenId] = tokenRate[_tokenId].sub(_rate);
    }
}
