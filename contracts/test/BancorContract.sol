pragma solidity ^0.4.23;
/*
 * @title Helper contracts to simulate Bancor Network contract
 * @author Haresh G
 * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
 */

import {ERC20 as IERC20Token} from "../interfaces/ERC20Interface.sol";


contract BancorNetworkSuccess {
    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn,address _for) public payable returns (uint256){
        IERC20Token tokenContract  = IERC20Token(_path[_path.length-1]);
        tokenContract.transfer(_for,100);
        return 100;
    }
}


contract BancorNetworkFailed {
    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn,address _for) public payable returns (uint256){
        assert(false);
        return 10;
    }
}

contract BancorNetworkReEntrant {
    address reentrantCall;
    function setReEntrantContract(address reentryConract)public {
        reentrantCall = reentryConract;
    }

    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn,address _for) public payable returns (uint256){
        //TODO : Re-entrant call here
        return 0;
    }
}

contract BancorContractRegistry {
    mapping(bytes32=>address) registry;
    function getAddress(bytes32 _contractName) public view returns (address){
        return registry[_contractName];
    }

    function setAddress(bytes32 _contractName,address _contractAddress) public {
        registry[_contractName] = _contractAddress;
    }
}