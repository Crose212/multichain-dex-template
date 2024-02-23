// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "../lib/forge-std/src/Test.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract MathTest is Test {
    function testSqrt() public {
        uint256 x = Math.sqrt(232131231556612321514232);
        assertEq(x, 481799991237);
    }
}
