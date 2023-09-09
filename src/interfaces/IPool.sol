// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IPool {
    function tokenBalance(address token) external view returns (uint256);

    function saveStuckToken(address stuckToken) external;

    function migrateToNewPool(address pool, address token) external;

    function addLiquidity(uint256 amount0, uint256 amount1) external;

    function addLiquiditySingle(address token, uint256 amount) external;

    function removeLiquiditySinge(address token0, uint256 amount) external;

    function removeLiquidity(uint256 amount) external;

    function getOutput(uint256 amount) external view returns (uint256);

    function claimRewards(uint256 amount) external;

    function claimOnAnotherChain(uint256 amount0, uint256 amount1) external;

    function claimOnAnotherChainSingle(uint256 amount) external;

    function getClaimableAmounts(uint256 shares) external view returns (uint256);

    function sendLiquidityToAnotherChain(uint256 shares) external;

    function sendLiquidityToAnotherChainSingle(address token, uint256 amount) external;

    function swap(address token, uint256 amount) external;
    
    function crossChainSwap(address tokenIn, address tokenOut, uint32 chainId, uint256 amount) external;
}
