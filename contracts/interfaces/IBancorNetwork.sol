pragma solidity ^0.4.23;
import {ERC20 as IERC20Token} from "./ERC20Interface.sol";

contract IBancorNetwork {
    function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
    function convertForPrioritized2(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _for,
        uint256 _block,
        uint8 _v,
        bytes32 _r,
        bytes32 _s)
        public payable returns (uint256);

    // deprecated, backward compatibility
    function convertForPrioritized(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _for,
        uint256 _block,
        uint256 _nonce,
        uint8 _v,
        bytes32 _r,
        bytes32 _s)
        public payable returns (uint256);
}

/*
   Bancor Contract Registry interface
*/
contract IContractRegistry {
    function getAddress(bytes32 _contractName) public view returns (address);
}
