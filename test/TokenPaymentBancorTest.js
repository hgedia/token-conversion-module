const bancorNetworkSuccess = artifacts.require('BancorNetworkSuccess');
const bancorContractRegistry = artifacts.require('BancorContractRegistry')
const tokenConversionModule = artifacts.require('IndTokenPayment')

let bancorNetworkHash = 0x42616e636f724e6574776f726b00000000000000000000000000000000000000;

//vars
let contractRegistry;
let tokenConver



function getStatusFromReceipt(receipt){

}


contract('BancorNetwork', accounts => {

    let convPath = ['0x01'];
    let destWallet = 0x04;
    let minConvRate = 00;

    before(async () => {
        let convPath = ['0x01' , '0x02' , '0x03'];
        contractRegistry = await bancorContractRegistry.new();
        console.log(contractRegistry.address);
    })

 
    it('should sucessfully convert ETH to ERC20 tokens on convertFor call', async () => {    
        let bancorNwSuccess = await bancorNetworkSuccess.new();
        await contractRegistry.setAddress(bancorNetworkHash, bancorNwSuccess.address);                
        let regVal = await contractRegistry.getAddress(bancorNetworkHash);
        let tokenConvertor = await tokenConversionModule.new(convPath, destWallet, contractRegistry.address, minConvRate);
        console.log("Token Convertor " + JSON.stringify(tokenConvertor.address));
        let result = await web3.eth.sendTransaction({ from: web3.eth.accounts[0], to: tokenConvertor.address, value: 1 , gas: 900000})
        console.log("Result " + JSON.stringify(result));
        let recpt = await web3.eth.getTransactionReceipt(result);
        console.log("Result " + JSON.stringify(recpt.status));
        
    });   

    /*
    it('should sucessfully withdraw ER20 tokens if locked in contract', async () => {
        //assert(false);
    });        
    
    

    it('should sucessfully withdraw ETH if locked in contract', async () => {
        assert(false);
    });        


    it('should fail to convert when bancor network is missing in registry', async () => {
        assert(false);
    });   

    it('should fail to convert when bancor network throws an exception', async () => {
        assert(false);
    });    
    
    it('should fail to execeute ownerOnly functions', async () => {
        assert(false);
    });    
        
    it('should fail to withdraw ETH if called by non owner', async () => {
        assert(false);
    });        

    it('should fail to withdraw ERC20 tokens if called by non owner', async () => {
        assert(false);
    });      

    it('should fail if reentrancy is encountered', async () => {
        assert(false);
    });

    it('should fail if any ETH is attempted to be sent back in any call', async () => {
        assert(false);
    });   
    */

})