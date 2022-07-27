//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interface/IERC2917N.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";

/*
    The Objective of ERC2917 Demo is to implement a decentralized staking mechanism, which calculates users' share
    by accumulating productiviy * time. And calculates users revenue from anytime t0 to t1 by the formula below:
        user_accumulated_productivity(time1) - user_accumulated_productivity(time0)
       _____________________________________________________________________________  * (gross_product(t1) - gross_product(t0))
       total_accumulated_productivity(time1) - total_accumulated_productivity(time0)
*/
contract CBerus is ERC20 {
    using SafeMath for uint256;

    ILevel public level;
    IRepository property;
    IERC721 mdc;

    uint256 public mintCumulation;
    uint256 private unlocked = 1;
    uint256 public cberusPerBlock;
    uint256 private lastRewardBlock;
    uint256 public totalHashRate;
    uint256 public rewardPerHashRateStored;

    mapping(uint256 => TokenInfo) public tokenInfo;

    struct TokenInfo {
        uint256 hashRate; // How many hashRate the user has provided.
        uint256 rewardDebt; // Reward debt.
        address tokenOwnerOf; // token of owner
    }

    // creation of the interests token.
    constructor(
        uint256 _interestsRate,
        address _pro,
        address _level,
        address _mdc
    ) ERC20("CBerus", "CBERUS") {
        property = IRepository(_pro);
        level = ILevel(_level);
        mdc = IERC721(_mdc);

        cberusPerBlock = _interestsRate;
    }

    // External function call
    // This function adjust how many token will be produced by each block, eg:
    // changeAmountPerBlock(100)
    // will set the produce rate to 100/block.
    function changeInterestRatePerBlock(uint256 value) external returns (bool) {
        uint256 old = cberusPerBlock;
        require(value != old, "AMOUNT_PER_BLOCK_NO_CHANGE");

        cberusPerBlock = value;

        emit InterestRatePerBlockChanged(old, value);
        return true;
    }

    // External function call
    // This function increase user's productivity and updates the global productivity.
    // the users' actual share percentage will calculated by:
    // Formula:     user_productivity / global_productivity
    function stake(uint256 tokenId) external update {
        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");
        // current holder
        address owner = mdc.ownerOf(tokenId);
        require(owner == msg.sender, "not owner");
        TokenInfo storage info = tokenInfo[tokenId];
        totalHashRate = totalHashRate.add(_rate);
        info.hashRate = _rate;
        info.rewardDebt = info.hashRate.mul(rewardPerHashRateStored);
        info.tokenOwnerOf = owner;
        emit Stake(tokenId, _rate);
    }

    // External function call
    // This function will decreases user's productivity by value, and updates the global productivity
    // it will record which block this is happenning and accumulates the area of (productivity * time)
    function unStake(uint256 tokenId) external update {
        TokenInfo storage info = tokenInfo[tokenId];

        // current holder
        address owner = mdc.ownerOf(tokenId);
        require(owner == msg.sender && info.tokenOwnerOf == owner, "not owner");
        uint256 reward = earned(tokenId);
        _transfer(address(this), owner, reward);

        delete tokenInfo[tokenId];

        emit UnStake(tokenId, reward);
    }

    function earned(uint256 tokenId) public view returns (uint256) {
        TokenInfo storage info = tokenInfo[tokenId];
        uint256 _rewardPerHashRateStored = rewardPerHashRateStored;
        // uint256 lpSupply = totalProductivity;
        if (block.number > lastRewardBlock && totalHashRate != 0) {
            uint256 multiplier = block.number.sub(lastRewardBlock);
            uint256 reward = multiplier.mul(cberusPerBlock);
            _rewardPerHashRateStored = _rewardPerHashRateStored.add(
                reward.mul(1e12).div(totalHashRate)
            );
        }
        return
            info.hashRate.mul(_rewardPerHashRateStored).div(1e12).sub(
                info.rewardDebt
            );
    }

    // External function call
    // When user calls this function, it will calculate how many token will mint to user from his productivity * time
    // Also it calculates global token supply from last time the user mint to this time.
    function mint() external lock returns (uint256) {
        return 0;
    }

    // Returns how many productivity a user has and global has.
    function getTotalHashRate(uint256 tokenId)
        external
        view
        returns (uint256, uint256)
    {
        return (tokenInfo[tokenId].hashRate, totalHashRate);
    }

    // Returns the current gorss product rate.
    function interestsPerBlock() external view returns (uint256) {
        return rewardPerHashRateStored;
    }

    modifier lock() {
        require(unlocked == 1, "Locked");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    // Update reward variables of the given pool to be up-to-date.
    modifier update() {
        if (block.number <= lastRewardBlock) {
            return;
        }

        if (totalHashRate == 0) {
            lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number.sub(lastRewardBlock);
        uint256 reward = multiplier.mul(cberusPerBlock);
        super._mint(address(this), reward);
        rewardPerHashRateStored = rewardPerHashRateStored.add(
            reward.div(totalHashRate)
        );
        lastRewardBlock = block.number;
        _;
    }

    /// @dev This emit when interests amount per block is changed by the owner of the contract.
    /// It emits with the old interests amount and the new interests amount.
    event InterestRatePerBlockChanged(uint256 oldValue, uint256 newValue);

    /// @dev This emit when a users' productivity has changed
    /// It emits with the user's address and the the value after the change.
    event Stake(uint256 indexed tokenId, uint256 value);

    /// @dev This emit when a users' productivity has changed
    /// It emits with the user's address and the the value after the change.
    event UnStake(uint256 indexed tokenId, uint256 value);
}
