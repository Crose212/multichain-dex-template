// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
<<<<<<< HEAD

interface IPool {
    

    function tokenBalance(address token) external view returns (uint256);

    function saveStuckToken(address stuckToken) external;

    function migrateToNewPool(
        address pool, 
        address token
    ) external;

}
=======
>>>>>>> a0e2063 (1)
