# Token converion

This module can be used when a payment needs to be accepted in one ERC20 currency , but the sender has a preference to use ETH. We can achieve this using the trade/conversion API's by various dApps. This repo demostrates the conversion of ETH to any of the ERC20 tokens (supported by the exchange used).

Note that , conversion from ETH to ERC20 differs from ERC20 to ERC20 in terms of flow. Hence any one attempting to use this as a base would also need to do an approve call on either of the called contracts to allow the conversion.


## Token conveter using KyberSwap 

This contract accepts ETH and converts it to any other token available in Kyber reserve. 

## Token conveter using Bancor

This contract accepts ETH and converts it to any other token available in Bancor Network.

Bancor uses a conversion path to convert from one token to another. This needs to be provided for all trade calls.
From bancor repo : https://github.com/bancorprotocol/contracts

/*    
    A note on conversion path -
    Conversion path is a data structure that's used when converting a token to another token in the bancor network
    when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
    The path defines which converters should be used and what kind of conversion should be done in each step.

    The path format doesn't include complex structure and instead, it is represented by a single array
    in which each 'hop' is represented by a 2-tuple - smart token & to token.
    In addition, the first element is always the source token.
    The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).

    Format:
    [source token, smart token, to token, smart token, to token...]
*/

Example with a more optimised path : https://etherscan.io/tx/0x219b5b1f97a24d95b6dec5f5728f7b69461f48344e6be302dcffeabef9ae34cf

ETHTOKEN : 0xc0829421c1d260bd3cb3e0f06cfe2d52db2ce315 
BNT      : 0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c
BNT      : 0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c
INDBNT   : 0x32423158e8fbd2839e085626f8a98d86b2766de8
IND      : 0xf8e386eda857484f5a12e4b5daa9984e06e73705

Path = ["0xc0829421c1d260bd3cb3e0f06cfe2d52db2ce315","0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c","0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c","0x32423158e8fbd2839e085626f8a98d86b2766de8","0xf8e386eda857484f5a12e4b5daa9984e06e73705"]
Destination Wallet = "0x46B8086916fec41eE2E46AAD91036e08eFc76c48"
Destination Wallet = "0x1111111111111111111111111111111111111111"
Bancor Registry    = "0xd1997064f0fef8748c1de9b5ba53468c548738b3"
Min Conversion Rate= 9000 

