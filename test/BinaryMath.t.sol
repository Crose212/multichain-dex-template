// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/libraries/BinaryMath.sol";

contract BinaryMathTest is Test {

    function testSqrt() public {
        uint128 x = BinaryMath.sqrt(232131231556612321514232);
        assertEq(x, 481799991237);
    }
}