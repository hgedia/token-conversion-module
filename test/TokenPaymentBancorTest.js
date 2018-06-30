const bancorNetworkSuccess = artifacts.require('BancorNetworkSuccess');
const bancorContractRegistry = artifacts.require('BancorContractRegistry')
const tokenConversionModule = artifacts.require('IndTokenPayment')
const SelfDestructor = artifacts.require('SelfDestructor')
const abiDecoder = require('abi-decoder'); 


//vars



contract('BancorNetwork', accounts => {

    let convPath1 = ['0x8fba0c8740177d44b5a75d469b9a69562905cf13', '0x8fba0c8740177d44b5a75d469b9a69562905cf23'];
    let destWallet = '0xf20b9e713a33f61fa38792d2afaf1cd30339126a';
    let bancorNetworkHash = '0x42616e636f724e6574776f726b00000000000000000000000000000000000000';
    let minConvRate = 1;
    let randomEthAddress = '0x8a3886bb62739408310d126bfa951a6dbf8647b8'
    let contractRegistry;
                   

    before(async () => {       
        contractRegistry = await bancorContractRegistry.new();        
    })

    function parseLogs(decodedLog){
        //Only one Event due to mocks, so using index 0
        let parsedEvent = {};
        let event = decodedLog[0];        
        for (elem of event.events){         
            if(elem.name == "from"){
                parsedEvent.from = elem.value;
            } else if (elem.name == "fromTokenVal"){
                parsedEvent.fromTokenVal = elem.value;
            } else if (elem.name =="dest"){
                parsedEvent.dest = elem.value;
            } else if (elem.name == "minReturn") {
                parsedEvent.minReturn = elem.value;
            } else if (elem.name == "destTokenVal") {
                parsedEvent.destTokenVal = elem.value;
            }
        }
        return parsedEvent;
    }

 
    it('should sucessfully convert ETH to ERC20 tokens on convertFor call', async () => {    
        let bancorNwSuccess = await bancorNetworkSuccess.new();      
        await contractRegistry.setAddress(bancorNetworkHash, bancorNwSuccess.address);
        let tokenConvertor = await tokenConversionModule.new(convPath1, destWallet, contractRegistry.address, minConvRate);        
        let tokAddr = tokenConvertor.address;
        let result = await web3.eth.sendTransaction({ from: web3.eth.accounts[0] , to: tokAddr, value: 10, gas: 900000 })        
        let recpt = await web3.eth.getTransactionReceipt(result);
        abiDecoder.addABI(tokenConvertor.abi);
        const parsedEvent = parseLogs(abiDecoder.decodeLogs(recpt.logs));
        assert.equal(parsedEvent.from, web3.eth.accounts[0]);
        assert.equal(parsedEvent.fromTokenVal, 10);
        assert.equal(parsedEvent.dest, destWallet);
        assert(parsedEvent.destTokenVal > minConvRate* 10,"Invalid conversion");       
    });

    it('should sucessfully withdraw ER20 tokens if locked in contract', async () => {
        let bancorNwSuccess = await bancorNetworkSuccess.new();      
        await contractRegistry.setAddress(bancorNetworkHash, bancorNwSuccess.address);
        let tokenConvertor = await tokenConversionModule.new(convPath1, destWallet, contractRegistry.address, minConvRate);        
        let selfDestruct = await SelfDestructor.new()
        await web3.eth.sendTransaction({ from: web3.eth.accounts[0] ,value:10 , to: selfDestruct.address});
        await selfDestruct.killIt(tokenConvertor.address);
        assert.equal(web3.eth.getBalance(tokenConvertor.address).toNumber(),10);
        assert.equal(web3.eth.getBalance(destWallet).toNumber(),0);
        await tokenConvertor.withdrawEther();
        assert.equal(web3.eth.getBalance(destWallet).toNumber(),10);
        assert.equal(web3.eth.getBalance(tokenConvertor.address).toNumber(),0);
    });

    /*
        
    
    

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