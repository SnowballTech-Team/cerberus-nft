//SPDX-License-Identifier: MIT
pragma solidity 0.8.6;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC2917N is IERC20 {
    /// @dev This emit when interests amount per block is changed by the owner of the contract.
    /// It emits with the old interests amount and the new interests amount.
    event InterestRatePerBlockChanged(uint256 oldValue, uint256 newValue);

    /// @dev This emit when a users' productivity has changed
    /// It emits with the user's address and the the value after the change.
    event IncreasedHashRate(uint256 indexed tokenId, uint256 value);

    /// @dev This emit when a users' productivity has changed
    /// It emits with the user's address and the the value after the change.
    event DecreasedHashRate(uint256 indexed tokenId, uint256 value);

    /// @dev Return the current contract's interests rate per block.
    /// @return The amount of interests currently producing per each block.
    function interestsPerBlock() external view returns (uint256);

    /// @notice Change the current contract's interests rate.
    /// @dev Note the best practice will be restrict the gross product provider's contract address to call this.
    /// @return The true/fase to notice that the value has successfully changed or not, when it succeed, it will emite the InterestRatePerBlockChanged event.
    function changeInterestRatePerBlock(uint256 value) external returns (bool);

    /// @notice It will get the productivity of given user.
    /// @dev it will return 0 if user has no productivity proved in the contract.
    /// @return user's productivity and overall productivity.
    function getTotalHashRate(uint256 tokenId)
        external
        view
        returns (uint256, uint256);

    /// @notice increase a user's productivity.
    /// @dev Note the best practice will be restrict the callee to prove of productivity's contract address.
    function increaseHashRate(uint256 tokenId) external;

    /// @notice decrease a user's productivity.
    /// @dev Note the best practice will be restrict the callee to prove of productivity's contract address.
    function decreaseHashRate(uint256 tokenId) external;

    /// @notice mint the avaiable interests to callee.
    /// @dev once it mint, the amount of interests will transfer to callee's address.
    /// @return the amount of interests minted.
    function mint() external returns (uint256);
}
