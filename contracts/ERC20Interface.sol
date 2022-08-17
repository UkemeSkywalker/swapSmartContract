// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Interface{

    mapping(address => uint) balances;
     function mint() external {
        balances[msg.sender] ++;
    }
}
