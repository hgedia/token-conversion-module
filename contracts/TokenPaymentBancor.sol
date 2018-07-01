pragma solidity ^0.4.23;

/*
 * @title Token Payment using Bancor API v0.2
 * @author Haresh G
 * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
 * @notice It does not support ERC20 to ERC20 transfer.
 */

import "./common/Ownable.sol";
import "./common/ReentrancyGuard.sol";
import "./common/SafeMath.sol";
import "./interfaces/IBancorNetwork.sol";
import {ERC20 as IERC20Token} from "./interfaces/ERC20Interface.sol";



contract IndTokenPayment is Ownable, ReentrancyGuard {  
    using SafeMath for uint256;
    IERC20Token[] public path;    
    address public destinationWallet;       
    //Minimum tokens per 1 ETH to convert
    uint256 public minConversionRate;
    IContractRegistry public bancorRegistry;
    bytes32 public constant BANCOR_NETWORK = "BancorNetwork";    
    IERC20Token destTokenContract; //Contract we are trying to convert to.

    event conversionSucceded(address from, //Address from where the transaction was received
                            uint256 fromTokenVal, //Amount to be converted
                            address dest, // Address where converted tokens are to be deposited
                            uint256 minReturn, // The minimum converion rate
                            uint256 destTokenVal, // The number of tokens which were converted
                            uint256 oldBalance, // Old balance of destination wallet
                            uint256 newBalance); // New balance of destination wallet
    
    constructor(IERC20Token[] _path,
                address destWalletAddr,
                address bancorRegistryAddr,
                uint256 minConvRate) public{
        path = _path;
        bancorRegistry = IContractRegistry(bancorRegistryAddr);
        destinationWallet = destWalletAddr;         
        minConversionRate = minConvRate;
        destTokenContract = IERC20Token(_path[path.length-1]);
    }

    function setConversionPath(IERC20Token[] _path) public onlyOwner {
        path = _path;
        destTokenContract = IERC20Token(_path[path.length-1]);
    }
    
    function setBancorRegistry(address bancorRegistryAddr) public onlyOwner {
        bancorRegistry = IContractRegistry(bancorRegistryAddr);
    }

    function setMinConversionRate(uint256 minConvRate) public onlyOwner {
        minConversionRate = minConvRate;
    }    

    function setDestinationWallet(address destWalletAddr) public onlyOwner {
        destinationWallet = destWalletAddr;
    }    
    
    function convertToInd() internal {
        assert(bancorRegistry.getAddress(BANCOR_NETWORK) != address(0));
        IBancorNetwork bancorNetwork = IBancorNetwork(bancorRegistry.getAddress(BANCOR_NETWORK));   
        uint256 minReturn = minConversionRate.mul(msg.value);
        uint256 oldBalance = destTokenContract.balanceOf(destinationWallet);
        uint256 minNewBalance = oldBalance.add(minReturn);
        uint256 convTokens = bancorNetwork.convertFor.value(msg.value)(path,msg.value,minReturn,destinationWallet);
        uint256 newBalance = destTokenContract.balanceOf(destinationWallet);
        assert(newBalance >= minNewBalance);
        emit conversionSucceded(msg.sender,msg.value,destinationWallet,minReturn,convTokens,oldBalance,newBalance);
    }

    //If accidentally tokens are transferred to this
    //contract. They can be withdrawn by the following interface.
    function withdrawERC20Token(IERC20Token anyToken) public onlyOwner nonReentrant returns(bool){
        if( anyToken != address(0x0) ) {
            assert(anyToken.transfer(destinationWallet, anyToken.balanceOf(this)));
        }
        return true;
    }

    //ETH cannot get locked in this contract. If it does, this can be used to withdraw
    //the locked ether.
    function withdrawEther() public onlyOwner nonReentrant returns(bool){
        if(address(this).balance > 0){
            destinationWallet.transfer(address(this).balance);
        }        
        return true;
    }
 
    function () nonReentrant public payable {
        //Bancor contract can send the transfer back in case of error, which goes back into this
        //function ,convertToInd is non-reentrant.
        convertToInd();
    }
    /*
    * Helper function
    *
    */
    function getBancorContractAddress() public view returns(address) {
        return bancorRegistry.getAddress(BANCOR_NETWORK);        
    }
}