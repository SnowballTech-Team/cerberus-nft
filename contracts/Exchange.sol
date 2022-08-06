// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./owner/Manage.sol";

contract Exchange is ReentrancyGuard, Manage {
    using SafeMath for uint256;

    IERC20 cBerus;
    IERC20 berus;

    address payable wallet;

    // how much erc20 to 1 zfuel
    uint256 public price = 1E18;

    uint256 constant _1Berus = 1E18;

    // how much ETH to 1 zfuel
    uint256 public ethprice;

    constructor(
        address _cBerus,
        address _berus,
        address _wallet
    ) {
        cBerus = IERC20(_cBerus);
        berus = IERC20(_berus);
        wallet = payable(_wallet);
    }

    event SetBerus(address manage, address token);
    event SetCBerus(address manage, address token);
    event SetPrice(address manage, uint256 _price);
    event Swap(
        address buyer,
        uint256 _price,
        uint256 cBerusAmount,
        uint256 berusAmount
    );
    event TacKBack(address recipient, uint256 amount, uint256 blocktime);

    receive() external payable {
        swapForETH();
    }

    /**
     * @dev swap erc20 token with zfuel
     *
     * uint256 _amount: zfuel amount,
     *
     * Notice
     * - need add decimal 0
     */
    function swap(uint256 cBerusAmount) external nonReentrant {
        cBerusAmount = cBerusAmount.mul(1E18);
        uint256 berusAmount = cBerusAmount.mul(price).div(_1Berus);
        cBerus.transferFrom(msg.sender, wallet, cBerusAmount);
        berus.transfer(msg.sender, berusAmount);
        emit Swap(msg.sender, price, cBerusAmount, berusAmount);
    }

    // @dev receive eth to swap Zfuel
    function swapForETH() public payable nonReentrant {
        uint256 payamount = msg.value;
        uint256 berusAmount = payamount.mul(ethprice).div(_1Berus);
        berus.transfer(msg.sender, berusAmount);
        wallet.transfer(payamount);
        emit Swap(msg.sender, ethprice, payamount, berusAmount);
    }

    function setBerus(address _token) external onlyManage {
        require(_token != address(0), "token is zero");
        berus = IERC20(_token);
        emit SetBerus(msg.sender, _token);
    }

    function setCBerusToken(address _token) external onlyManage {
        require(_token != address(0), "token is zero");
        cBerus = IERC20(_token);
        emit SetCBerus(msg.sender, _token);
    }

    function setPrice(uint256 _price) external onlyManage {
        require(_price > 0, "price is zero");
        price = _price;
        emit SetPrice(msg.sender, _price);
    }

    function setETHPrice(uint256 _price) external onlyManage {
        require(_price > 0, "price is zero");
        ethprice = _price;
        emit SetPrice(msg.sender, _price);
    }

    function leftBalance() public view returns (uint256) {
        return berus.balanceOf(address(this));
    }

    function takeBackBerus(address recipient) external onlyManage {
        uint256 amount = leftBalance();
        berus.transfer(recipient, amount);

        emit TacKBack(recipient, amount, block.timestamp);
    }
}
