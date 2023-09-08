// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IPool {
    function tokenBalance(address token) external view returns (uint256);

    function saveStuckToken(address stuckToken) external;

    function migrateToNewPool(address pool, address token) external;

    function addLiquidity(uint256 amount0, uint256 amount1) external;

    function removeLiquiditySinge(address token0, uint256 amount) external;

    function removeLiquidity(uint256 amount) external;

    function getSingleOutput(uint256 amount) external view returns (uint256);

    function claimRewards(uint256 amount) external;

    function claimOnAnotherChain(uint256 amount0, uint256 amount1) external;

    function claimOnAnotherChainSingle(uint256 amount) external;

    function getClaimableAmounts(uint256 shares) external view returns (uint256);
}
