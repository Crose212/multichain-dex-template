// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IRouter {
    function reserves(address token1, address token0, address pool) external view returns (uint256, uint256);

    function deploy(address token0, address token1, uint256 amount0, uint256 amount1) external;

    function swap(address poolAddress, uint256 amount0, uint256 amount1) external;

    function crossSwap(uint32 chainId, address reciever, address pool, uint256 amount0, uint256 amount1) external;

    function addLiquidity(address poolAddress, uint256 amount0, uint256 amount1) external;

    function addLiquiditySingle(address poolAddress, address token, uint256 amount) external;

    function removeLiquidity(address poolAddress, uint256 shares) external; 

    function removeLiquiditySingle(address poolAddress, address token, uint256 sshares) external;

    function claimRewards(address poolAddress, uint256 shares) external;

    function claimRewardsOnAnotherChain(address poolAddress, uint32 chainId) external;

    function removeLiquidityOnAnotherChain(address poolAddress, uint256 shares, uint32 chainId) external;

    function lockLiquidity(address poolAddress, uint256 amount0, uint256 amount1, bool burn) external;

    
}
