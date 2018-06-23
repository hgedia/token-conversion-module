pragma solidity ^0.4.23;
import {ERC20 as IERC20Token} from "./ERC20Interface.sol";

contract IBancorNetwork {
    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
}

/*
   Bancor Contract Registry interface
*/
contract IContractRegistry {
    function getAddress(bytes32 _contractName) public view returns (address);
}
