//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IRepository.sol";
import "./interface/ILevel.sol";
import "./owner/Manage.sol";

contract CBerusPool is Manage, ReentrancyGuard, ERC721Holder {
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using EnumerableSet for EnumerableSet.UintSet;
    using SafeMath for uint256;
    EnumerableMap.UintToAddressMap private tokenOwner;

    ILevel public level;
    IRepository property;
    IERC20 berus;
    IERC721 mdc;

    uint256 public cberusPerBlock;
    uint256 private lastRewardBlock;
    uint256 public totalHashRate;
    uint256 public rewardPerHashRateStored;

    mapping(address => bool) public deposit;
    mapping(address => bool) public _hashRate;
    mapping(address => StakeInfo) public stakeInfo;
    mapping(address => EnumerableSet.UintSet) private _ownedTokens;

    struct StakeInfo {
        uint256 hashRate; // How many hashRate the user has provided.
        uint256 rewardDebt; // Reward debt.
    }

    // creation of the interests token.
    constructor(
        uint256 _rate,
        address _pro,
        address _level,
        address _berus,
        address _mdc
    ) {
        property = IRepository(_pro);
        level = ILevel(_level);
        mdc = IERC721(_mdc);
        berus = IERC20(_berus);
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
        require(deposit[msg.sender], "has been deposited");

        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");

        mdc.transferFrom(msg.sender, address(this), tokenId);
        _ownedTokens[msg.sender].add(tokenId);
        tokenOwner.set(tokenId, msg.sender);
        StakeInfo storage info = stakeInfo[msg.sender];
        totalHashRate = totalHashRate.add(_rate);
        info.hashRate = info.hashRate.add(_rate);
        info.rewardDebt = info.rewardDebt.add(
            info.hashRate.mul(rewardPerHashRateStored)
        );

        deposit[msg.sender] = true;
        emit Stake(tokenId, _rate);
    }

    // External function call
    // This function will decreases user's productivity by value, and updates the global productivity
    // it will record which block this is happenning and accumulates the area of (productivity * time)
    function unStake(uint256 tokenId) external update nonReentrant {
        uint256 _rate = property.tokenHashRate(tokenId);
        require(_rate > 0, "rate is zero");
        // current holder
        address owner = ownerOf(tokenId);
        require(owner == msg.sender, "not owner");
        uint256 reward = earned();
        berus.transferFrom(address(this), owner, reward);
        _ownedTokens[msg.sender].remove(tokenId);
        tokenOwner.remove(tokenId);
        StakeInfo storage info = stakeInfo[msg.sender];
        totalHashRate = totalHashRate.sub(_rate);
        info.hashRate = info.hashRate.sub(_rate);
        info.rewardDebt = info.hashRate.mul(rewardPerHashRateStored);
        mdc.transferFrom(address(this), msg.sender, tokenId);
        deposit[msg.sender] = false;
        emit UnStake(tokenId, reward);
    }

    function earned() public view returns (uint256) {
        StakeInfo storage info = stakeInfo[msg.sender];
        uint256 _rewardPerHashRateStored = rewardPerHashRateStored;
        // uint256 lpSupply = totalProductivity;
        if (block.number > lastRewardBlock && totalHashRate != 0) {
            uint256 multiplier = block.number.sub(lastRewardBlock);
            uint256 reward = multiplier.mul(cberusPerBlock);
            _rewardPerHashRateStored = _rewardPerHashRateStored.add(
                reward.mul(1e18).div(totalHashRate)
            );
        }
        return
            info.hashRate.mul(_rewardPerHashRateStored).div(1e18).sub(
                info.rewardDebt
            );
    }

    // Returns how many productivity a user has and global has.
    function getTotalHashRate() external view returns (uint256, uint256) {
        return (stakeInfo[msg.sender].hashRate, totalHashRate);
    }

    // Returns the current gorss product rate.
    function interestsPerBlock() external view returns (uint256) {
        return rewardPerHashRateStored;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return tokenOwner.get(tokenId, "query for nonexistent token");
    }

    function balanceOfOwner(address owner) external view returns (uint256) {
        require(
            owner != address(0),
            "Staking: balance query for the zero address"
        );
        return _ownedTokens[owner].length();
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
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

        if (totalHashRate != 0) {
            uint256 multiplier = block.number.sub(lastRewardBlock);
            uint256 reward = multiplier.mul(cberusPerBlock);
            rewardPerHashRateStored = rewardPerHashRateStored.add(
                reward.mul(1e18).div(totalHashRate)
            );
        }

        lastRewardBlock = block.number;
        _;
    }

    function setBerus(address _token) external onlyManage {
        require(_token != address(0), "token address is zero");
        berus = IERC20(_token);
        emit SetBerus(msg.sender, _token);
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
    event SetBerus(address manage, address _berus);
    event SetLevel(address manage, address _level);
    event SetProperty(address manage, address _property);
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
