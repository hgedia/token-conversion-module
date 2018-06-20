pragma solidity ^0.4.23;

/*
 * @title Token Payment using Bancor API v0.1
 * @author Haresh G
 * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
 * @notice It does not support ERC20 to ERC20 transfer.
 */

import "./common/Ownable.sol";
import "./common/ReentrancyGuard.sol";
import {ERC20 as IERC20Token} from "./interfaces/ERC20Interface.sol";
import "./interfaces/IBancorNetwork.sol";



contract IndTokenPayment is Ownable, ReentrancyGuard {  
    IERC20Token[] public path;    
    address public destinationWallet;       
    uint256 public minConversionRate;
    IContractRegistry public bancorRegistry;
    bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
    
    event conversionSucceded(address from,uint256 fromTokenVal,address dest,uint256 destTokenVal);    
    
    constructor(IERC20Token[] _path,
                address destWalletAddr,
                address bancorRegistryAddr,
                uint256 minConvRate){
        path = _path;
        bancorRegistry = IContractRegistry(bancorRegistryAddr);
        destinationWallet = destWalletAddr;         
        minConversionRate = minConvRate;
    }

    function setConversionPath(IERC20Token[] _path) public onlyOwner {
        path = _path;
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
    
    function convertToInd() internal nonReentrant {
        assert(bancorRegistry.getAddress(BANCOR_NETWORK) != address(0));
        IBancorNetwork bancorNetwork = IBancorNetwork(bancorRegistry.getAddress(BANCOR_NETWORK));   
        //TODO : Compute minReturn
        uint256 minReturn =0;
        uint256 convTokens =  bancorNetwork.convertFor.value(msg.value)(path,msg.value,minReturn,destinationWallet);        
        assert(convTokens > 0);
        emit conversionSucceded(msg.sender,msg.value,destinationWallet,convTokens);                                                                    
    }

    //If accidentally tokens are transferred to this
    //contract. They can be withdrawn by the followin interface.
    function withdrawToken(IERC20Token anyToken) public onlyOwner nonReentrant returns(bool){
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

 
    function () public payable {
        //Bancor contract can send the transfer back in case of error, which goes back into this
        //function ,convertToInd is non-reentrant.
        convertToInd();
    }
}