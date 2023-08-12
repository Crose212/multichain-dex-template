// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./libraries/TransferHelper.sol";

import "./Router.sol";
import "./BridgeRouter.sol";

contract Pool is Ownable {
    address constant NATIVE_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;
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
    // -------- Internal functions ---------- //

    function updateReserves(uint _newReserve0, uint _newReserve1) internal {
        reserve0 = _newReserve0;
        reserve1 = _newReserve1;
    }

    // -------- Owner functions ---------- //

    function saveStuckToken(address stuckToken) external onlyOwner {
        if (stuckToken == NATIVE_ADDR) {
            TransferHelper.safeTransferETH(msg.sender, address(this).balance);
        } else {
            uint256 amount = IERC20(stuckToken).balanceOf(address(this));
            TransferHelper.safeTransfer(stuckToken, msg.sender, amount);
        }
    }

    function migrateToNewPool(address pool, address token) external onlyOwner {
        require(token != address(0) && pool != address(0), "New pool and token shouldn't be address 0");
    }
}
