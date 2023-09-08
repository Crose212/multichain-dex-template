// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./libraries/TransferHelper.sol";

import "./Router.sol";
import "./BridgeRouter.sol";

contract Pool is Ownable {
    using SafeMath for uint256;

    address constant NATIVE_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 public immutable fee;
    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public totalSupply;
    mapping(address => uint256) public rewards;
    mapping(uint256 => uint256) public claimable;
    mapping(address => uint256) public balanceOf;

    Router public immutable router;
    BridgeRouter public immutable bridgeRouter;

    modifier onlyRouter() {
        require(msg.sender == address(router), "This function is only callable for Router.");
        _;
    }

    modifier onlyBridgeRouter() {
        require(msg.sender == address(bridgeRouter), "This function is only callable for BridgeRouter.");
        _;
    }

    constructor(address _router, address _bridgeRouter, address _token0, address _token1, uint256 _fee) {
        require(_router != address(0) && _bridgeRouter != address(0), "Router address shoudn't be 0");
        router = Router(_router);
        bridgeRouter = BridgeRouter(_bridgeRouter);
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
        fee = _fee;
    }

    // -------- External functions ---------- //

    function totalReserves() public view returns (uint256, uint256) {
        return (reserve0, reserve1);
    }

    function addLiquidity(uint256 _amount0, uint256 _amount1) external onlyRouter returns (uint256 shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        if (reserve0 > 0 || reserve1 > 0) {
            require(reserve0 * _amount1 == reserve1 * _amount0, "x / y != dx / dy");
        }

        if (totalSupply == 0) {
            shares = Math.sqrt(_amount0 * _amount1);
        } else {
            shares = Math.min((_amount0 * totalSupply) / reserve0, (_amount1 * totalSupply) / reserve1);
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        _updateReserves(token0.balanceOf(address(this)), token1.balanceOf(address(this)));

        // TODO: Skeleton of a function, to remake
    }

    function removeLiquidity(uint256 _shares) external onlyRouter returns (uint256 amount0, uint256 amount1) {
        require(balanceOf[msg.sender] > 0, "No liquidity found for this address");
        uint256 bal0 = token0.balanceOf(address(this));
        uint256 bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _updateReserves(bal0 - amount0, bal1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
        // TODO: Skeleton of a function, to remake
    }

    function removeLiquiditySingleToken(uint256 _shares) external onlyRouter {
        // require(balanceOf[msg.sender] > 0, "No liquidity found for this address");
        // uint bal0 = token0.balanceOf(address(this));
        // uint bal1 = token1.balanceOf(address(this));
        // TODO: Skeleton of a function, to remake
    }

    function claimRewards(uint256 _shares) external onlyRouter {}

    function migrateLiquidity() external {
        // TODO
    }
    // -------- Internal functions ---------- //

    function _burn(address _from, uint256 _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _mint(address _to, uint256 _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _updateReserves(uint256 _newReserve0, uint256 _newReserve1) internal {
        reserve0 = _newReserve0;
        reserve1 = _newReserve1;
    }

    // -------- Critical functions ---------- //

    function saveStuckToken(address stuckToken) external onlyOwner {
        if (stuckToken == NATIVE_ADDR) {
            TransferHelper.safeTransferETH(msg.sender, address(this).balance);
        } else {
            uint256 amount = IERC20(stuckToken).balanceOf(address(this));
            TransferHelper.safeTransfer(stuckToken, msg.sender, amount);
        }
    }

    function migrateToNewPool(address pool, address token) external onlyOwner {
        //require(token != address(0) && pool != address(0), "New pool and token shouldn't be address 0");
        // TODO
    }
}
