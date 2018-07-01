pragma solidity ^0.4.23;
/*
 * @title Helper contracts to simulate a self destructing contract
 * @author Haresh G
 */

contract SelfDestructor{
    function () payable {

    }

    function killIt(address _to) public {
        selfdestruct(_to);
    }
}