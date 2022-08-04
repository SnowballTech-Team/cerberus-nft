//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "./interface/IMillionDogeClub.sol";
import "./interface/IRepository.sol";
import "./owner/Manage.sol";

contract Mint is Manage {
    IMillionDogeClub public mdc;
    IRepository public property;

    constructor(address _pro, address _mdc) {
        property = IRepository(_pro);
        mdc = IMillionDogeClub(_mdc);
    }

    function mdcMint(address _receiver) external {
        uint256 tokenId = mdc.mint(_receiver);
        property.setProperty(tokenId);
    }
}
