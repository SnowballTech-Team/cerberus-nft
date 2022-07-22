//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";

contract MiningPool is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    ILevel public level;
    IERC20 public cdoge;
    IRepository property;

    uint256 public rewardRate = 0;

    mapping(uint256 => uint256) public rewards;
    mapping(uint256 => uint256) public token;

    constructor(
        address _pro,
        address _cdoge,
        address _level
    ) {
        property = IRepository(_pro);
        cdoge = IERC20(_cdoge);
        level = ILevel(_level);
        rewardRate = 1e15;
    }

    function earned(uint256 _tokenId) public view returns (uint256) {
        return rewardRate.mul(property.tokenHashRate(_tokenId));
    }

    function getReward(uint256 _tokenId) external nonReentrant {
        uint256 reward_ = earned(_tokenId);
        require(reward_ > 0, "");
        cdoge.transferFrom(address(this), msg.sender, reward_);
        emit GetReward(msg.sender, _tokenId, reward_);
    }

    function setRewardRate(uint256 _rate) external onlyOwner {
        require(_rate > 0, "rate is zero");
        rewardRate = _rate;
        emit SetRewardRate(msg.sender);
    }

    event SetRewardRate(address _owner);
    event GetReward(address _owner, uint256 _tokenId, uint256 _reward);
}
