// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IRepository {
    function getProperty(uint256 _tokenId)
        external
        view
        returns (uint256[] memory);

    function updateCdoge(uint256 _tokenId, uint256 _amount) external;
}
