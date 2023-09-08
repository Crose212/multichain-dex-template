// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract BridgeRouter is Ownable, ReentrancyGuard {
    mapping(uint16 => mapping(uint256 => uint256)) public poolIndex;
}
