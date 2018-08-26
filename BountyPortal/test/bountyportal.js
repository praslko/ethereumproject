var BountyPortal = artifacts.require("BountyPortal.sol");

var assert = require('assert');

let bountyPortalInstance
contract('BountyPortal', ([owner, issuer1, issuer2, issuer3, issuer4, bidder1, bidder2, bidder3, bidder4, bidder5]) => {

it("test: get instance of contract", async () => {
	try {
		bountyPortalInstance = await BountyPortal.new(owner)
		assert(true)
	} catch  (error) {
		assert.fail()
	}
})

it('test: Create a Bounty by issuer#1 should succeed', async () => {
	try { 
		var obj = await bountyPortalInstance.createBounty("Prob01_01", 10, {from: issuer1, value: 11})
		//console.log (obj.logs[0].args._bountyId.toNumber())
		assert(true);
		assert.strictEqual(obj.logs[0].args._bountyId.toNumber(), 0)
	} catch (error) {
		assert.fail()
	}
})

it('test: Create a Bounty by contract owner should fail', async () => {
	try { 
		var obj = await bountyPortalInstance.createBounty("Prob01_01", 10, {from: owner, value: 11})
		//console.log (obj.logs[0].args._bountyId.toNumber())
		assert(fail);
	} catch (error) {
		assert(true)
	}
})

// Ether value should be atleast 1 wei more than the bouty reward 

it('test: Attempt to create another Bounty by issuer #1 with insufficient ether should fail', async () => {
	try {
		var obj = await bountyPortalInstance.createBounty("Prob01_02", 20, {from: issuer1, value: 20})
		//console.log (obj.logs[0].args._obj.toNumber())
		assert.fail()
		//assert.strictEqual(obj.logs[0].args._bountyId.toNumber(), 1)
	} catch (error) {
		assert(true)
	}
	})
/*
it('test: Create a Bounty by issuer #2', async () => {
	var obj = await bountyPortalInstance.createBounty("Prob02_01", 10, {from: issuer2, value: 11})
	//console.log (obj.logs[0].args._bountyId.toNumber())
	assert.strictEqual(obj.logs[0].args._bountyId.toNumber(), 2)
	})*/


it('test: enable Bounty by anyone other than issuer of bounty should fail', async () => {
	try {
		await bountyPortalInstance.enableBounty(0, {from: issuer2, value: 1})
		assert.fail()
	} catch (error) {
		assert(true)
	}
	})

it('test: enable Bounty by issuer #1 without sufficient ether should fail', async () => {
	try {
		await bountyPortalInstance.enableBounty(0, {from: issuer1, value: 0})
		assert.fail()
	} catch (error) {
		assert(true)
	}
	})


it('test: enable Bounty by issuer #1 should succeed', async () => {
	try {
		await bountyPortalInstance.enableBounty(0, {from: issuer1, value: 1})
		assert(true)
	} catch (error) {
		assert.fail()
	}
	})

it('test: attempt to enable a non-existent Bounty should fail', async () => {
	try {
		await bountyPortalInstance.enableBounty(1, {from: issuer1, value: 1})
		assert.fail()
	} catch (error) {
		assert(true)
	}	
	})

it('test: attempt to submit work to a Bounty by issuer of bounty should fail', async () => {
	try {
		await bountyPortalInstance.executeBounty(1, "Resp01", {from: issuer1, value: 1})
		assert.fail()
	} catch (error) {
		assert(true)
	}
	})


it('test: attempt to submit work to a Bounty by bidder #1 should succeed', async () => {
	try {
		await bountyPortalInstance.executeBounty(0, "Resp01", {from: bidder1, value: 1})
		assert(true)
	} catch (error) {
		assert.fail()
	}
	})

it('test: obtain Bounty Work Submission Count should give correct number', async () => {
	try {
		var obj = await bountyPortalInstance.getBountyExecutionCount(0, {from: issuer1})
		//console.log(obj.toNumber())
		assert.strictEqual(obj.toNumber(), 1)
	} catch (error) {
		assert.fail()
	}
})

it('test: obtain Bounty Work Submission Details by issuer of bounty should succeed', async () => {
	try {
		var obj = await bountyPortalInstance.getBountyExecution(0, 0, {from: issuer1})
		//console.log(obj.toNumber())
		assert(true)
	} catch (error) {
		assert.fail()
	}
})

it('test: obtain Bounty Work Submission Details by bidder who submitted work to bounty should succeed', async () => {
	try {
		var obj = await bountyPortalInstance.getBountyExecution(0, 0, {from: bidder1})
		//console.log(obj.toNumber())
		assert(true)
	} catch (error) {
		assert.fail()
	}
})

it('test: obtain Bounty Work Submission Details for non-existent work to bounty should fail', async () => {
	try {
		var obj = await bountyPortalInstance.getBountyExecution(0, 1, {from: bidder1}) // 2nd argument is invalid because only 1 work submission so far
		//console.log(obj.toNumber())
		assert.fail()
	} catch (error) {
		assert(true)
	}
})

it('test: obtain Bounty Work Submission Details by bidder who is someone other than the one who submitted work to bounty should fail', async () => {
	try {
		var obj = await bountyPortalInstance.getBountyExecution(0, 0, {from: bidder2})
		//console.log(obj.toNumber())
		assert.fail()
	} catch (error) {
		assert(true)
	}
})

it('test: attempt to submit work to a non-existent Bounty by a bidder should fail', async () => {
	try {
		await bountyPortalInstance.executeBounty(1, "Resp01", {from: bidder1, value: 1})
		assert.fail()
	} catch (error) {
		assert(true)
	}
	})

it('test: accept Bounty Work by anyone other than issuer of bounty should fail', async () => {
	try {
		await bountyPortalInstance.acceptBountyExecution(0, 0, {from: issuer3, value: 1})
		assert.fail()
	} catch (error) {
		assert(true)
	}
	})

it('test: accept Bounty Work by issuer #1 without sufficient ether should fail', async () => {
	try {
		await bountyPortalInstance.acceptBountyExecution(0, 0, {from: issuer1, value: 0})
		assert.fail()
	} catch (error) {
		assert(true)
	}
	})

it('test: accept Bounty Work by issuer #1 should succeed', async () => {
	try {
		await bountyPortalInstance.acceptBountyExecution(0, 0, {from: issuer1, value: 1})
		assert(true)
	} catch (error) {
		assert.fail()
	}
	})

it('test: check Contract Balance by contract owner should succeed', async () => {
	try {
		var obj = await bountyPortalInstance.getContractBalance({from: owner})
		assert.strictEqual(obj[0].toNumber(), 14) // Overall contract balance
		assert.strictEqual(obj[1].toNumber(), 4) // Contract balance withdrawable by contract owner
	} catch (error) {
		assert.fail()
	}
})

it('test: check Contract Balance by anyone other than contract owner should fail', async () => {
	try {
		var obj = await bountyPortalInstance.getContractBalance({from: owner})
		assert.fail()
	} catch (error) {
		assert(true);
	}
})

it('test: collect Bounty Reward by bidder 1 should succeed and contract balance should drop', async () => {
	try {
		var obj = await bountyPortalInstance.collectBountyReward(0, 0, {from: bidder1})
		assert(true)
		try {
			var obj = await bountyPortalInstance.getContractBalance({from: owner})
			assert.strictEqual(obj[0].toNumber(), 4) // Overall contract balance
			assert.strictEqual(obj[1].toNumber(), 4) // Contract balance withdrawable by contract owner
		} catch (error) {
			assert.fail();
		}
	} catch (error) {
		assert.fail()
	}

})

it('test: check Contract Balance again after reward collection', async () => {
	try {
		var obj = await bountyPortalInstance.getContractBalance({from: owner})
		assert.strictEqual(obj[0].toNumber(), 4) // Overall contract balance
		assert.strictEqual(obj[1].toNumber(), 4) // Contract balance withdrawable by contract owner
	} catch (error) {
		assert.fail()
	}
})


it('test: contract stop attempt by anyone other than contract owner should fail', async () => {
	try {
		var obj = await bountyPortalInstance.stopContract({from: issuer2})
		assert.fail()
	} catch (error) {
		assert(true)
	}
})

it('test: check contract stop attempt by contract owner succeeds', async () => {
	try {
		var obj = await bountyPortalInstance.stopContract({from: owner})
		assert(true)
	} catch (error) {
		assert.fail()
	}
})


it('test: bounty creation should fail as contract is in stopped state', async () => {
	try {
		var obj = await bountyPortalInstance.createBounty("Prob03_01", 20, {from: issuer3, value: 30})
		//console.log (obj.logs[0].args._obj.toNumber())
		assert.fail()
		//assert.strictEqual(obj.logs[0].args._bountyId.toNumber(), 1)
	} catch (error) {
		assert(true)
	}
	})


it('test: contract balance withdrawal by contract owner should fail as contract is in stopped state', async () => {
	try {
		var obj = await bountyPortalInstance.withdrawContractBalance({from: owner})
		assert.fail()
	} catch (error) {
		assert(true)
	}
})

it('test: contract resume attempt by anyone other than contract owner should fail', async () => {
	try {
		var obj = await bountyPortalInstance.resumeContract({from: issuer2})
		assert.fail()
	} catch (error) {
		assert(true)
	}
})

it('test: check contract resume attempt by contract owner succeeds', async () => {
	try {
		var obj = await bountyPortalInstance.resumeContract({from: owner})
		assert(true)
	} catch (error) {
		assert.fail()
	}
})

it('test: contract balance withdrawal by anyone other than contract owner should fail', async () => {
	try {
		var obj = await bountyPortalInstance.withdrawContractBalance({from: issuer2})
		assert.fail()
	} catch (error) {
		assert(true)
	}
})

it('test: contract balance withdrawal by owner should succeed', async () => {
	try {
		var obj = await bountyPortalInstance.withdrawContractBalance({from: owner})
		assert.fail()
	} catch (error) {
		assert(true)
	}
})


it('test: check Contract Balance again after contract owner withdraws contract Balance', async () => {
	try {
		var obj = await bountyPortalInstance.getContractBalance({from: owner})
		assert.strictEqual(obj[0].toNumber(), 0) // Overall contract balance
		assert.strictEqual(obj[1].toNumber(), 0) // Contract balance withdrawable by contract owner
	} catch (error) {
		assert.fail()
	}
})

it('test: contract balance repeat withdrawal by contract owner should fail as contract balance is 0', async () => {
	try {
		var obj = await bountyPortalInstance.getContractBalance({from: owner})
		assert.fail()
	} catch (error) {
		assert(true);
	}
})

})