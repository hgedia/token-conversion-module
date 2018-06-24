const bancorNetworkSuccess = artifacts.require('BancorNetworkSuccess');
const bancorContractRegistry = artifacts.require('BancorContractRegistry')
const tokenConversionModule = artifacts.require('IndTokenPayment')

let bancorNetworkHash = 0x42616e636f724e6574776f726b00000000000000000000000000000000000000;

//vars
let contractRegistry;
let tokenConver


contract('BancorNetwork', accounts => {

    let convPath1 = ['0x8fba0c8740177d44b5a75d469b9a69562905cf13', '0x8fba0c8740177d44b5a75d469b9a69562905cf23'];
    let destWallet = '0xf20b9e713a33f61fa38792d2afaf1cd30339126a';
                     
    let minConvRate = 1;

    before(async () => {
        //let convPath = ['0x01' , '0x02' , '0x03'];
        contractRegistry = await bancorContractRegistry.new();
        console.log("Registry deployed at : " + contractRegistry.address);
    })

 
    it('should sucessfully convert ETH to ERC20 tokens on convertFor call', async () => {    

        let bancorNwSuccess = await bancorNetworkSuccess.new();
        console.log("Bancor contract deployed at : " + bancorNwSuccess.address );

        await contractRegistry.setAddress(bancorNetworkHash, bancorNwSuccess.address);                
        let regVal = await contractRegistry.getAddress(bancorNetworkHash);
        console.log("Bancor Contract address from registry " + regVal)

        let tokenConvertor = await tokenConversionModule.new(convPath1, destWallet, contractRegistry.address, minConvRate);
        
        let tokAddr = tokenConvertor.address;
        console.log("Token convertor deployed at : " + tokAddr);

        console.log("-----------------------------------------------------------")   
        let path0 = await tokenConvertor.getPath(0);
        let path1 = await tokenConvertor.getPath(1);
        console.log("Path is " + path0 + " , path1 " + path1);

        let banReg = await tokenConvertor.bancorRegistry();
        console.log("Registry token contract " + banReg);

        let dwall = await tokenConvertor.destinationWallet();
        console.log("DestWallet from contract " + dwall);

        let minRate = await tokenConvertor.minConversionRate();
        console.log("Min Rate from token contract " + minRate);     

        let bancorAdd = await tokenConvertor.getBancorContractAddress();
        console.log("Bancor address from token contract : " + bancorAdd);        

        let bancorHash = await tokenConvertor.BANCOR_NETWORK();
        console.log("Bancor Hash  : " + bancorHash);        


        let result = await web3.eth.sendTransaction({ from: web3.eth.accounts[0] , to: tokAddr, value: 10, gas: 900000 })
        console.log("Result " + JSON.stringify(result));
        let recpt = await web3.eth.getTransactionReceipt(result);
        console.log("Result " + JSON.stringify(recpt.status));

        //console.log("Token Convertor " + JSON.stringify(tokenConvertor.address));

        //let result = await web3.eth.sendTransaction({ from: web3.eth.accounts[0], to: tokenConvertor.address, value: 10, gas: 900000 })
        /*
        
        console.log("Result " + JSON.stringify(result));
        let recpt = await web3.eth.getTransactionReceipt(result);
        console.log("Result " + JSON.stringify(recpt.status));
        */
        
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