# Token converion

This module can be used when a payment needs to be accepted in one ERC20 currency , but the sender has a preference to use ETH. We can achieve this using the trade/conversion API's by various dApps. This repo demostrates the conversion of ETH to any of the ERC20 tokens (supported by the exchange used).

Note that , conversion from ETH to ERC20 differs from ERC20 to ERC20 in terms of flow. Hence any one attempting to use this as a base would also need to do an approve call on either of the called contracts to allow the conversion.


## Token conveter using KyberSwap 

This contract accepts ETH and converts it to any other token available in Kyber reserve. 

## Token conveter using Bancor

This contract accepts ETH and converts it to any other token available in Bancor Network.
