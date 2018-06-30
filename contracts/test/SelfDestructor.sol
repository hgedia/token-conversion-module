pragma solidity ^0.4.23;
/*
 * @title Helper contracts to simulate a self destructing contract
 * @author Haresh G
 * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
 */

contract SelfDestructor{
    function () payable {

    }

    function killIt(address _to) public {
        selfdestruct(_to);
    }
}