// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IRouter {
    function reserves(
        address token1, 
        address token0, 
        uint256 _poolId
    ) external view returns (uint256, uint256);
}