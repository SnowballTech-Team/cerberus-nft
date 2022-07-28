//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interface/IMillionDogeClub.sol";
import "./interface/ILevel.sol";
import "./interface/IBerus.sol";
import "./owner/Manage.sol";
import "./LevelEnum.sol";

contract MillionDogeClubRepository is Manage, ReentrancyGuard {
    using SafeMath for uint256;

    IERC20 public cdogeToken;
    IBerus public berusToken;
    IMillionDogeClub public mdc;
    ILevel public levelInterface;

    uint256 public baseDoge;
    uint256 public baseBerus;
    mapping(uint256 => Property) private property;

    event SetProperty(address _manage, uint256 _tokenId);
    event DepositBerus(address _owner, uint256 _tokenId, uint256 _amount);

    constructor(
        address _cdoge,
        address _berus,
        address _mdc,
        address _level
    ) {
        cdogeToken = IERC20(_cdoge);
        berusToken = IBerus(_berus);
        mdc = IMillionDogeClub(_mdc);
        levelInterface = ILevel(_level);
    }

    function baseRepos() private view returns (Property memory) {
        Property memory pro = Property(baseDoge, baseBerus, Level.Soldier);
        return pro;
    }

    /**
     * set nft property
     */
    function setProperty(uint256 _tokenId) external onlyManage {
        emit SetProperty(msg.sender, _tokenId);
        property[_tokenId] = baseRepos();
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
        pro.level = levelInterface.checkLevel(pro.cdoge, pro.berus);
    }

    /**
     * deposit berus
     */
    function depositBerus(uint256 _tokenId, uint256 _amount) external {
        berusToken.transferFrom(msg.sender, address(this), _amount);
        Property storage pro = property[_tokenId];
        pro.berus += _amount;
        pro.level = levelInterface.checkLevel(pro.cdoge, pro.berus);
        emit DepositBerus(msg.sender, _tokenId, _amount);
    }

    /**
     * burn cnft get cdoge
     */
    function burn(uint256 _tokenId) external {
        Property memory pro = property[_tokenId];
        cdogeToken.transferFrom(address(this), msg.sender, pro.cdoge);
        berusToken.transferFrom(address(this), msg.sender, pro.berus);
        mdc.burn(_tokenId);
        berusToken.burn(pro.berus);
        delete property[_tokenId];
    }

    function tokenHashRate(uint256 _tokenId) external view returns (uint256) {
        Property memory pro = property[_tokenId];
        // get token level
        uint256 lv = levelInterface.checkBonus(pro.level);
        // calc current rate
        return pro.cdoge.mul(lv).div(1000).add(pro.cdoge);
    }

    function setBaseDoge(uint256 _base) external onlyOwner {
        baseDoge = _base;
    }

    function setBaseBerus(uint256 _base) external onlyOwner {
        baseBerus = _base;
    }
}
