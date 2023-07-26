// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./Router.sol";
import "./BridgeRouter.sol";

import "./interfaces/ILayerZeroReceiver.sol";
import "./interfaces/ILayerZeroEndpoint.sol";
import "./interfaces/ILayerZeroUserApplicationConfig.sol";

contract Pair is Ownable {
    ILayerZeroEndpoint public immutable layerZeroEndpoint;
    Router public immutable router;
    BridgeRouter public immutable bridgeRouter;

    bool public useZROToken;

    constructor(address _layerZeroEndpoint, address _router, address _bridgeRouter) {
        require(
            _layerZeroEndpoint != address(0) && _router != address(0) && _bridgeRouter != address(0),
            "Endpoint and routers can't be address 0"
        );
        layerZeroEndpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
        router = Router(_router);
        bridgeRouter = BridgeRouter(_bridgeRouter);
    }
}
