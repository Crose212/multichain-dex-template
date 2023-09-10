// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IFactory {
    function getPool(address token0, address token1) external view returns (address);
}
