const bancorNetworkSuccess = artifacts.require('BancorNetworkSuccess');
const bancorContractRegistry = artifacts.require('BancorContractRegistry')


//vars
let contractRegistry;
let bancorNwSuccess;

contract('BancorNetwork', accounts => {
    before(async () => {
        let convPath = ['0x01' , '0x02' , '0x03'];
        contractRegistry = await bancorContractRegistry.new();
    })

    it('should sucessfully convert ETH to ERC20 tokens on convertFor call', async () => {
        assert(false);
    });    

    it('should sucessfully withdraw ETH if locked in contract', async () => {
        assert(false);
    });        

    it('should sucessfully withdraw ER20 tokens if locked in contract', async () => {
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

})