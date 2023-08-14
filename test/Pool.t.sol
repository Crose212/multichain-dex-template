// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Pool.sol";

contract PoolTest is Test {
    Pool public pool;

    function setUp() public {
        pool = new Pool(address(1), address(1), address(1), address(1));
    }

    function testReserves() public {
        (uint reserve0, uint reserve1) = pool.totalReserves();
        assertEq(reserve0, 0);
        assertEq(reserve1, 0);
    }
}