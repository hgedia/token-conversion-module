pragma solidity ^0.4.23;
/*
 * @title Helper contracts to simulate a dummy ERC20 contract
 * @author Haresh G
 * @dev This contract is used to represent a dummy ERC20 token
 */

pragma solidity ^0.4.23;


contract DummyToken {
   mapping(address => uint256) balances;

  uint256 totalSupply_;

    constructor(address init){
        balances[init] = 1000;
        totalSupply_ = 1000;
    }


  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender] - (_value);
    balances[_to] = balances[_to] + (_value);
    return true;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}