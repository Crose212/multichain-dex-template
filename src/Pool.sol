// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

import "./libraries/TransferHelper.sol";
import "./libraries/BinaryMath.sol";

import "./Router.sol";
import "./BridgeRouter.sol";

contract Pool is Ownable {
    address constant NATIVE_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

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

    constructor(address _router, address _bridgeRouter, address _token0, address _token1) {
        require(_router != address(0) && _bridgeRouter != address(0), "Router address shoudn't be 0");
        router = Router(_router);
        bridgeRouter = BridgeRouter(_bridgeRouter);
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    // -------- External functions ---------- //

    function totalReserves() public view returns (uint256, uint256) {
        return(reserve0, reserve1);
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external onlyRouter returns (uint shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        if (reserve0 > 0 || reserve1 > 0) {
            require(
                reserve0 * _amount1 == reserve1 * _amount0,
                "x / y != dx / dy"
            );
        }

        if (totalSupply == 0) {
            shares = BinaryMath.sqrt(_amount0 * _amount1);
        } else {
            shares = Math.min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        updateReserves(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function removeLiquidity(
        uint _amount0,
        uint _amount1
    ) external onlyRouter {
        require(balanceOf[msg.sender] > 0, "No liquidity found for this address");
        uint256 a = 123;
    }


    function migrateLiquidity() external {}
    // -------- Internal functions ---------- //


    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }
    
    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }

    function updateReserves(uint _newReserve0, uint _newReserve1) internal {
        reserve0 = _newReserve0;
        reserve1 = _newReserve1;
    }

    function _sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
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
    }
}
