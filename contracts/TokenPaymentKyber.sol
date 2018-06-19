pragma solidity 0.4.23;

import "./common/Ownable.sol";
import "./common/ReentrancyGuard.sol";
import "./interfaces/ERC20Interface.sol";
import "./interfaces/IKyberNetwork.sol";

contract IndTokenPayment is Ownable, ReentrancyGuard {                   
    address constant ETH_TOKEN_ADDRESS = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
    
    IKyberNetwork private kyberNetwork;
    address public indToken;
    address public destinationWallet;   
    address public affiliateWallet;
    uint256 public minConversionRate;
    
    event conversionSucceded(address from,uint256 fromTokenVal,uint256 minConversionRate,address dest,uint256 destTokenVal);    
    
    constructor(address kyberNetworkAddr,
                address indTokenAddr,
                address destWalletAddr,
                address affiliateWalletAddr,
                uint256 minConvRate){
        kyberNetwork= IKyberNetwork(kyberNetworkAddr);
        indToken = indTokenAddr;
        destinationWallet = destWalletAddr;  
        affiliateWallet = affiliateWalletAddr;
        minConversionRate = minConvRate;
    }
    

    function setKyberNetwork(address kyberNetworkAddr) public onlyOwner {
            kyberNetwork= IKyberNetwork(kyberNetworkAddr);
    }

    function setIndToken(address indTokenAddr) public onlyOwner {
            indToken = indTokenAddr;
    }

    function setDestinationWallet(address destWalletAddr) public onlyOwner {
        destinationWallet = destWalletAddr;
    }
    
    function setAffiliateWallet(address affiliateWalletAddr) public onlyOwner {
        affiliateWallet = affiliateWalletAddr;
    }  
    
    function setMinConversionRate(uint256 minConvRate) public onlyOwner {
        minConversionRate = minConvRate;
    }
    
    function convertToInd() internal nonReentrant {
        uint256 convTokens =  kyberNetwork.trade.value(msg.value)(ETH_TOKEN_ADDRESS,
                                                                    msg.value,
                                                                    indToken,
                                                                    destinationWallet,
                                                                    2**255,
                                                                    minConversionRate,
                                                                    affiliateWallet);                                              
        
        assert(convTokens > 0);
        emit conversionSucceded(msg.sender,msg.value,minConversionRate,destinationWallet,convTokens);                                                                    
    }


    //If accidentally tokens are transferred to this
    //contract. They can be withdrawn by the followin interface.
    function withdrawToken(ERC20 anyToken) public onlyOwner nonReentrant returns(bool){
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
        //Kyber contract can send the transfer back in case of error, which goes back into this
        //function ,convertToInd is non-reentrant.
        convertToInd();
    }
}