pragma solidity 0.4.23;
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
