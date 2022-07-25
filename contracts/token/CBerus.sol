//SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interface/IERC2917.sol";

/*
    The Objective of ERC2917 Demo is to implement a decentralized staking mechanism, which calculates users' share
    by accumulating productiviy * time. And calculates users revenue from anytime t0 to t1 by the formula below:
        user_accumulated_productivity(time1) - user_accumulated_productivity(time0)
       _____________________________________________________________________________  * (gross_product(t1) - gross_product(t0))
       total_accumulated_productivity(time1) - total_accumulated_productivity(time0)
*/
contract CBerus is ERC20, IERC2917 {
    using SafeMath for uint256;

    uint256 public mintCumulation;
    uint256 private unlocked = 1;
    uint256 public cberusPerBlock;
    uint256 lastRewardBlock;
    uint256 totalProductivity;
    uint256 accAmountPerShare;

    mapping(address => UserInfo) public users;

    struct UserInfo {
        uint256 amount; // How many hashRate the user has provided.
        uint256 rewardDebt; // Reward debt.
    }

    // creation of the interests token.
    constructor(uint256 _interestsRate) ERC20("CBerus", "CBERUS") {
        cberusPerBlock = _interestsRate;
    }

    // External function call
    // This function adjust how many token will be produced by each block, eg:
    // changeAmountPerBlock(100)
    // will set the produce rate to 100/block.
    function changeInterestRatePerBlock(uint256 value)
        external
        override
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
    function increaseProductivity(address user, uint256 value)
        external
        override
        update
        returns (bool)
    {
        require(value > 0, "PRODUCTIVITY_VALUE_MUST_BE_GREATER_THAN_ZERO");

        UserInfo storage userInfo = users[user];
        if (userInfo.amount > 0) {
            uint256 pending = userInfo
                .amount
                .mul(accAmountPerShare)
                .div(1e12)
                .sub(userInfo.rewardDebt);
            _transfer(address(this), user, pending);
            mintCumulation = mintCumulation.add(pending);
        }

        totalProductivity = totalProductivity.add(value);

        userInfo.amount = userInfo.amount.add(value);
        userInfo.rewardDebt = userInfo.amount.mul(accAmountPerShare).div(1e12);
        emit ProductivityIncreased(user, value);
        return true;
    }

    // External function call
    // This function will decreases user's productivity by value, and updates the global productivity
    // it will record which block this is happenning and accumulates the area of (productivity * time)
    function decreaseProductivity(address user, uint256 value)
        external
        override
        update
        returns (bool)
    {
        require(value > 0, "INSUFFICIENT_PRODUCTIVITY");

        UserInfo storage userInfo = users[user];
        require(userInfo.amount >= value, "WASABI: FORBIDDEN");
        uint256 pending = userInfo.amount.mul(accAmountPerShare).div(1e12).sub(
            userInfo.rewardDebt
        );
        _transfer(address(this), user, pending);
        mintCumulation = mintCumulation.add(pending);
        userInfo.amount = userInfo.amount.sub(value);
        userInfo.rewardDebt = userInfo.amount.mul(accAmountPerShare).div(1e12);
        totalProductivity = totalProductivity.sub(value);

        emit ProductivityDecreased(user, value);
        return true;
    }

    function take() external view override returns (uint256) {
        UserInfo storage userInfo = users[msg.sender];
        uint256 _accAmountPerShare = accAmountPerShare;
        // uint256 lpSupply = totalProductivity;
        if (block.number > lastRewardBlock && totalProductivity != 0) {
            uint256 multiplier = block.number.sub(lastRewardBlock);
            uint256 reward = multiplier.mul(cberusPerBlock);
            _accAmountPerShare = _accAmountPerShare.add(
                reward.mul(1e12).div(totalProductivity)
            );
        }
        return
            userInfo.amount.mul(_accAmountPerShare).div(1e12).sub(
                userInfo.rewardDebt
            );
    }

    function takeWithAddress(address user) external view returns (uint256) {
        UserInfo storage userInfo = users[user];
        uint256 _accAmountPerShare = accAmountPerShare;
        // uint256 lpSupply = totalProductivity;
        if (block.number > lastRewardBlock && totalProductivity != 0) {
            uint256 multiplier = block.number.sub(lastRewardBlock);
            uint256 reward = multiplier.mul(cberusPerBlock);
            _accAmountPerShare = _accAmountPerShare.add(
                reward.mul(1e12).div(totalProductivity)
            );
        }
        return
            userInfo.amount.mul(_accAmountPerShare).div(1e12).sub(
                userInfo.rewardDebt
            );
    }

    // Returns how much a user could earn plus the giving block number.
    function takeWithBlock() external view override returns (uint256, uint256) {
        UserInfo storage userInfo = users[msg.sender];
        uint256 _accAmountPerShare = accAmountPerShare;
        // uint256 lpSupply = totalProductivity;
        if (block.number > lastRewardBlock && totalProductivity != 0) {
            uint256 multiplier = block.number.sub(lastRewardBlock);
            uint256 reward = multiplier.mul(cberusPerBlock);
            _accAmountPerShare = _accAmountPerShare.add(
                reward.mul(1e12).div(totalProductivity)
            );
        }
        return (
            userInfo.amount.mul(_accAmountPerShare).div(1e12).sub(
                userInfo.rewardDebt
            ),
            block.number
        );
    }

    // External function call
    // When user calls this function, it will calculate how many token will mint to user from his productivity * time
    // Also it calculates global token supply from last time the user mint to this time.
    function mint() external override lock returns (uint256) {
        return 0;
    }

    // Returns how many productivity a user has and global has.
    function getProductivity(address user)
        external
        view
        override
        returns (uint256, uint256)
    {
        return (users[user].amount, totalProductivity);
    }

    // Returns the current gorss product rate.
    function interestsPerBlock() external view override returns (uint256) {
        return accAmountPerShare;
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

        if (totalProductivity == 0) {
            lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number.sub(lastRewardBlock);
        uint256 reward = multiplier.mul(cberusPerBlock);
        super._mint(address(this), reward);
        accAmountPerShare = accAmountPerShare.add(
            reward.mul(1e12).div(totalProductivity)
        );
        lastRewardBlock = block.number;
        _;
    }
}
