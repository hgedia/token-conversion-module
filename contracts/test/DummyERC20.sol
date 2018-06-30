pragma solidity ^0.4.23;
/*
 * @title Helper contracts to simulate a dummy ERC20 contract
 * @author Haresh G
 * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
 */

pragma solidity ^0.4.23;


import {ERC20 } from "../interfaces/ERC20Interface.sol";



/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract DummyToken is ERC20{
   mapping(address => uint256) balances;

  uint256 totalSupply_;

    constructor(address init){
        balances[init] = 1000;
        totalSupply_ = 1000;
    }


  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender] - (_value);
    balances[_to] = balances[_to] + (_value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}