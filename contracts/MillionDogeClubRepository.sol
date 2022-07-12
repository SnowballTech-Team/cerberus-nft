//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IMillionDogeClub.sol";
import "./lib/LevelUtil.sol";
import "./owner/Manage.sol";

contract MillionDogeClubRepository is Manage, ReentrancyGuard {
    IERC20 public cdegeToken;
    IERC20 public berusToken;
    IMillionDogeClub public mdc;

    uint256 public totalHashRate;

    mapping(uint256 => Property) private property;
    mapping(address => uint256) public ownerHashRate;

    struct Property {
        uint256 cdoge;
        uint256 berus;
        LevelUtil.Level level;
    }

    constructor(
        address _cdoge,
        address _berus,
        address _mdc
    ) {
        cdegeToken = IERC20(_cdoge);
        berusToken = IERC20(_berus);
        mdc = IMillionDogeClub(_mdc);
    }

    /**
     * set nft property
     */
    function setProperty(uint256 _tokenId, Property calldata _property)
        external
        onlyManage
    {
        property[_tokenId] = _property;
    }

    /**
     * return nft property
     */
    function getProperty(uint256 _tokenId)
        external
        view
        returns (Property memory)
    {
        return property[_tokenId];
    }

    /**
     * update cdoge
     */
    function updateCdoge(uint256 _tokenId, uint256 _amount)
        external
        onlyManage
    {
        Property storage pro = property[_tokenId];
        pro.cdoge += _amount;
        pro.level = LevelUtil.checkLevel(pro.cdoge, pro.berus);
        totalHashRate += LevelUtil.checkBonus(pro.level);
    }

    /**
     * deposit berus
     */
    function depositBerus(uint256 _tokenId, uint256 _amount) external {
        berusToken.transferFrom(msg.sender, address(this), _amount);
        Property storage pro = property[_tokenId];
        pro.berus += _amount;
        pro.level = LevelUtil.checkLevel(pro.cdoge, pro.berus);
    }

    /**
     * burn cnft get cdoge
     */
    function burn(uint256 _tokenId) external {
        Property memory pro = property[_tokenId];
        cdegeToken.transferFrom(address(this), msg.sender, pro.cdoge);
        mdc.burn(_tokenId);
        delete property[_tokenId];
    }
}
