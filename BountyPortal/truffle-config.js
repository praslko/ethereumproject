/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

var HDWalletProvider = require("truffle-hdwallet-provider");
// 12 word mnemonic
var mnemonic = "";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
	networks: {
   		development: {
   		host: "localhost",
   		port: 7545,
   		network_id: "*" // Match any network id
  		}, 
		rinkeby: {
     		provider: function() {
        	return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/f8f01076be284619980fea1cfeacf58d");
  		},
		network_id: 4,
      		gas: 4612388 // Gas limit used for deploys	
    		}
 	}
};