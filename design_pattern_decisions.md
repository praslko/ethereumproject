# Following patterns implemented in dAPP

1. Implemented "Access Restriction - Guard-Check" behavioral pattern to ensure following
   * Validation of user inputs
   * Checking of the contract state before executing logic
   * Checking invariants in your code.
   * Ruling out conditions that should not be possible
   
   Examples: Function createBounty checking that string carrying bounty data is not empty or not too long;
             Contract must not be in stopped state while executing the various functions of contract;
             Certain functions of contract authorized to be performed by only the contract owner

2. Implemented "Pull over Push" security pattern to avoid taking the risk associated with ether transfers and 
   because ther is incentive for users (job hunters) to handle ether withdrawal on their own
    
    Refer to function acceptBountyExecution and collectBountyReward
    First participant: Job Poster starts the process by executing function acceptBountyExecution
    Second participant: This is Contract itself. Inside function acceptBountyExecution, contract does necessary
                        aruthmetic/accounting to set the correct value of ether that a job hunter can collect  
    Third participant: Job Hunter executes function collectBountyReward to actually collect the ether than he/she is 
                      eligible for 
    
3. Implemented "Checks-Effects-Interactions" security pattern to guard functions against re-entrancy attacks
   Refer to function collectBountyReward. 

   First check is made: m_paymentAmount is checked to ensure that it is greater than 0.
   Then Effect is made: m_paymentAmount is set to 0 after storing amount in a local variable
   Then Interaction is done: msg.sender.transfer is called to transfer ether out of contract

Similarly, Refer to function withdrawContractBalance. 

   First check is made: m_withdrawable_contract_balance is checked to ensure that it is greater than 0.
   Then Effect is made: m_withdrawable_contract_balance is set to 0 after storing amount in a local variable
   Then Interaction is done: msg.sender.transfer is called to transfer ether out of contract

4. Implemented "Emergency Stop" security pattern to ensure following

   * Have the ability to pause BountyPortal contract
   * Guard critical functionality against the abuse of undiscovered bugs
   * Prepare BountyPortal contract for potential failures

   Refer to function stopContract and resumeContract. Only BountyPortal contract owner is authorized to execute these
   functions. Once stopContract is executed, contract goes into Stopped state and none of other functions (createBounty, 
   enableBounty, executeBounty, acceptBounty etc.) can be executed.  Only when the BountyPortal contract owner has
   resumed the contract by executing resumeContract function, the other functions are allowed to be executed.
   
   It is assumed that BountyPortal contract owner will not stop and resume contract maliciously


5. Implemented "Secure Ether Transfer" security pattern to safeguard against reentrancy attack while transferring ether
   out from contract in a secure manner. Used function transfer (instead of .call.value) as it considered safe 
   against re-entrancy and gas stipened for 2300 gas is good enough in this case.

6. Decided NOT TO IMPLEMENT "State Machine" behavioral pattern because BountyPortal contract is not going through 
   different stages.
   BountyPortal is always up (unless it is stopped under extreme circumstances) and allowing job  posters to 
   post bounties and job hunters to provide submissions (i.e. execute bounty) within the deadline indicated by
   job  poster. So usage of State Machine pattern does not make sense

7. Decided NOT TO IMPLEMENT "Proxy Delegate" upgradeability pattern because BountyPortal contract is not delegating
   function calls to other contracts.

8. Decided NOT TO IMPLEMENT "Oracle" upgradeability pattern because BountyPortal contract is not gaining access to data
   stored outside of the blockchain.


