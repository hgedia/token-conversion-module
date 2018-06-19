pragma solidity 0.4.24;

import "./ERC20Interface.sol";
/**
 * 
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>
 * https://github.com/OpenZeppelin/zeppelin-solidity
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {

  /**
   * @dev We use a single lock for the whole contract.
   */
  bool private reentrancyLock = false;

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
    }

}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 * @author https://github.com/OpenZeppelin/zeppelin-solidity
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/*
    /// @notice use token address ETH_TOKEN_ADDRESS for ether
    /// @dev makes a trade between src and dest token and send dest token to destAddress
    /// @param source Src token
    /// @param srcAmount amount of src tokens
    /// @param dest   Destination token
    /// @param destAddress Address to send tokens to
    /// @param maxDestAmount A limit on the amount of dest tokens
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
    /// @param walletId is the wallet ID to send part of the fees
    /// @return amount of actual dest tokens

*/
contract IKyberNetwork{
    function trade(address source,
                  uint256 srcAmount, 
                  address dest, 
                  address destAddress,
                  uint256 maxDestAmount, 
                  uint256 minConversionRate, 
                  address walletId) payable returns (uint256) ;                   
}


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