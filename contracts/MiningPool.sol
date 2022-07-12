//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interface/IRepository.sol";

contract MiningPool is Ownable, ReentrancyGuard {
    uint256 public reward;

    IRepository property;

    constructor(address _pro) {
        property = IRepository(_pro);
    }

    function earn(uint256 _tokenId) external view returns (uint256) {
        property.getProperty(_tokenId);
    }

    function getReward() public nonReentrant {}
}
