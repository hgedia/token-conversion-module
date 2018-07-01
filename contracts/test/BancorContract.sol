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
    event reEntry(bool r1Status,bool r2Status);
    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn,address _for) public payable returns (uint256){        
        address callingContract  = msg.sender;
        bool result1 = callingContract.call(bytes4(sha3("withdrawEther()")));//calling contract again
        bool result2 = callingContract.call(bytes4(sha3("sayHello()")));//fallback here
        emit reEntry(result1,result2);
        //Carry on
        IERC20Token tokenContract  = IERC20Token(_path[_path.length-1]);
        tokenContract.transfer(_for,1000);        
        return 1000;
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