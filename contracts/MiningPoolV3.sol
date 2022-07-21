//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";

contract MiningPool is Ownable, ReentrancyGuard {
    uint256 public totalHash;
    using SafeMath for uint256;

    ILevel public level;
    IERC20 public cdoge;
    IRepository property;

    mapping(uint256 => uint256) public perTokenReward;

    constructor(
        address _pro,
        address _cdoge,
        address _level
    ) {
        property = IRepository(_pro);
        cdoge = IERC20(_cdoge);
        level = ILevel(_level);
    }

    //
    function earned(uint256 _tokenId) public view returns (uint256) {
        Property memory pro = property.getProperty(_tokenId);
        // get token level
        uint256 lv = level.checkBonus(pro.level);
        // calc current rate
        uint256 _rate = pro.cdoge.mul(lv).div(1000).add(pro.cdoge);

        return cdoge.balanceOf(address(this)).div(totalHash).mul(_rate);
    }

    function getReward(uint256 _tokenId) external nonReentrant {
        perTokenReward[_tokenId] = cdoge.balanceOf(address(this));
        cdoge.transferFrom(address(this), msg.sender, earned(_tokenId));
    }
}
