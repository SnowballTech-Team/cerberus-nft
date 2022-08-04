//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
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
contract CBerusPool is ERC20, Manage, ReentrancyGuard, ERC721Holder {
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using EnumerableSet for EnumerableSet.UintSet;
    using SafeMath for uint256;
    EnumerableMap.UintToAddressMap private tokenOwner;

    ILevel public level;
    IRepository property;
    IERC721 mdc;

    uint256 public mintCumulation;
    uint256 public cberusPerBlock;
    uint256 private lastRewardBlock;
    uint256 public totalHashRate;
    uint256 public rewardPerHashRateStored;

    mapping(address => TokenInfo) public tokenInfo;
    mapping(address => EnumerableSet.UintSet) private _ownedTokens;

    struct TokenInfo {
        uint256 hashRate; // How many hashRate the user has provided.
        uint256 rewardDebt; // Reward debt.
    }

    // creation of the interests token.
    constructor(
        uint256 _rate,
        address _pro,
        address _level,
        address _mdc
    ) ERC20("CBerus", "CBERUS") {
        property = IRepository(_pro);
        level = ILevel(_level);
        mdc = IERC721(_mdc);

        cberusPerBlock = _rate;
    }

    // External function call
    // This function adjust how many token will be produced by each block, eg:
    // changeAmountPerBlock(100)
    // will set the produce rate to 100/block.
    function changeInterestRatePerBlock(uint256 value)
        external
        onlyManage
        returns (bool)
    {
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
    function stake(uint256 tokenId) external update nonReentrant {
        // current holder
        address owner = mdc.ownerOf(tokenId);
        require(owner == msg.sender, "not owner");

        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");

        mdc.transferFrom(msg.sender, address(this), tokenId);
        _ownedTokens[msg.sender].add(tokenId);
        tokenOwner.set(tokenId, msg.sender);
        TokenInfo storage info = tokenInfo[msg.sender];
        if (info.hashRate > 0) {
            uint256 pending = earned();
            _transfer(address(this), msg.sender, pending);
            mintCumulation = mintCumulation.add(pending);
        }
        totalHashRate = totalHashRate.add(_rate);
        info.hashRate = info.hashRate.add(_rate);
        info.rewardDebt = info.rewardDebt.add(
            info.hashRate.mul(rewardPerHashRateStored)
        );
        emit Stake(tokenId, _rate);
    }

    // External function call
    // This function will decreases user's productivity by value, and updates the global productivity
    // it will record which block this is happenning and accumulates the area of (productivity * time)
    function unStake(uint256 tokenId) external update nonReentrant {
        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");
        // current holder
        address owner = mdc.ownerOf(tokenId);
        require(owner == msg.sender, "not owner");
        uint256 reward = earned();
        _transfer(address(this), owner, reward);
        _ownedTokens[msg.sender].remove(tokenId);
        tokenOwner.remove(tokenId);
        TokenInfo storage info = tokenInfo[msg.sender];
        totalHashRate = totalHashRate.sub(_rate);
        info.hashRate = info.hashRate.sub(_rate);
        info.rewardDebt = info.hashRate.mul(rewardPerHashRateStored);
        mdc.transferFrom(address(this), msg.sender, tokenId);
        emit UnStake(tokenId, reward);
    }

    function earned() public view returns (uint256) {
        TokenInfo storage info = tokenInfo[msg.sender];
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

    // Returns how many productivity a user has and global has.
    function getTotalHashRate() external view returns (uint256, uint256) {
        return (tokenInfo[msg.sender].hashRate, totalHashRate);
    }

    // Returns the current gorss product rate.
    function interestsPerBlock() external view returns (uint256) {
        return rewardPerHashRateStored;
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
