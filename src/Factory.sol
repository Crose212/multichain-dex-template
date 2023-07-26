// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./Router.sol";

contract Factory is Ownable {
    Router public immutable router;

    constructor(address _router) {
        require(_router != address(0), "Router address shoudn't be 0");
        router = Router(_router);
    }
}
