## Project Objective

Implement Bounty dAPP. Also implement LibraryDemo.sol (to demonstrate use of ethPM)

## What does Bounty Project do
Implements smart contract (written in solidity) and a Javascript UI to provide following features. 

* Allows job posters to create new bounty
* Allows job hunters to submit work for a bounty 
* Allows job posters to review  submitted work and accept work. Acceptance of a work automatically implies rejection of other works for same bounty
* Allows job hunters to collect Bounty reward if their work is accepted

* Bounty Issuer refers to job poster
* Bounty Executor refers to job hunter

* A job hunter has upto 30 days (from the date & time bounty is enabled by the job poster to submit work

* It costs 1 wei for a job  poster to create a bounty
* It costs 1 wei for a job  poster to enable a bounty so that   
  job hunters can submit work 
* It costs 1 wei for a job  hunter to submit work for a
  bounty
* It costs 0 wei for a job poster to review the work submitted    
  by a job  hunter
* It costs 1 wei for a job poster to accept work for a
  bounty
* It costs 0 wei for a job hunter to collect bounty reward

* It costs 0 wei for a contract owner to stop contract/resume contract/know contract balance/withdraw contract balance


Refer to User Stories for details

## State Diagram for a Bounty [<Operation>] --> <State>

   [Create Bounty]->Draft [Enable Bounty] --> Active 
   [Accept Bounty Work] --> Closed
   
## State Diagram for Contract

   Stopped --> Not Stopped --> Stopped
   When contract is in stopped state, only master list of bounties can  be viewed and contract balance can be viewed  but no other (readonly/read write) operation is allowed except that if logged in user is contract owner then Resume Contract and Know Contract Balance Operations are allowed


## How to set it up in development environment

Step 1: Ensure following pre-requisite software is installed on your machine
* truffle
* ganache
* metamask (chrome extension)
* npm
* node.js
* lite-server
 
  My development environment details listed below 
 
  ### Operating System: Windows 10 (64-bit Operating System, x64-based processor)
  ### truffle version: Truffle v4.1.13 (core: 4.1.13) Solidity v0.4.24 (solc-js)
  ### ganache version: v1.2.1
  ### metamask (chrome extension) version: 4.9.3
  ### npm version: 6.2.0
  ### node.js version: 10.4.1
  ### lite-server version: 2.4.0	

Step 2.1: cd to BountyPortal Directory

Step 2.2: If you are on windows operating system then delete file truffle.js. If you are on unix operating system then delete file truffle-config.js
          Refer to for https://ethereum.stackexchange.com/questions/38117/truffle-configuration-file-name-is-it-truffle-js-or-truffle-config-js details

Step 2.3: Ensure that either directory BountyPortal\\build\\contracts does not exist or if it exists is empty

Step 2.4: Run command "truffle compile"

Step 2.5: Launch ganache UI (or start ganache from command line)

Step 2.6: Open file BountyPortal/migrations/2_deploy_contracts.js in any text editor and replace the contract address in following line the first address shown in ganache UI
 
		This step is only needed if address  0x0678636e25DaCf509872F7226A9Bf66b3261E2D2 is not the first addresse generated by ganache. 
 		deployer.deploy(BountyPortal, "0x0678636e25DaCf509872F7226A9Bf66b3261E2D2");

Step 2.7: Run command "truffle compile" while ensuring that your current directory is BountyPortal
                 Your command output will look similar to below
                  Compiling .\\contracts\\BountyPortal.sol...
 		Compiling .\\contracts\\Migrations.sol...
 		Writing artifacts to .\\build\\contracts

Step 2.8: : Run command "truffle migrate" while ensuring that your current directory is BountyPortal
 		Your command output will look similar to below
 		Using network 'development'.
 		Running migration: 1_initial_migration.js
   		Deploying Migrations...
   		... 0xc33377d5e9c36577969aa7a5304976bdc783cdb98dd4c46907d276e56428e244
   		Migrations: 0x942b1964f5968ac0a8a57bbed6fa452bcc49246e
 		Saving successful migration to network...
   		... 0x2fb5fb977b801f507c470ad54e0f96e0249a59f856db8d0eed8e6dc598811e9f
 		Saving artifacts...
 		Running migration: 2_deploy_contracts.js
   		Deploying BountyPortal...
   		... 0x905b997a4bf641d424e642b41b4d2061d44fd7ce7e370fa39b6f89200648787a
   		BountyPortal: 0x18b97e6bcb28f177a1ebf57b356c191db8b34ce0
 		Saving successful migration to network...
   		... 0x177c5c8795f7a7ec9a720e419960c24c164555d0b07e46b2f06e985b18913a78
 		Saving artifacts...

Step 2.9: In the output generated at Step 2.8, take note of the address at which  BountyPortal  contract is deployed (e.g. in above output address at which  		BountyPortal contract is  deployed is  0x18b97e6bcb28f177a1ebf57b356c191db8b34ce0)

Step 2.10: Open file BountyPortal\src\index.html in any text editor and edit line 500 to  ensure that it has same address that was taken note of at Step 2.9. Save the file.
 	  This step is only needed if BountyPortal contract is deployed at an address  that  is  different from 0x18b97e6bcb28f177a1ebf57b356c191db8b34ce0

Step 2.11: Run  command "npm run dev" while ensuring you are in BountyPortal directory

Step 2.12: Launch metamask GUI from chrome browser and set 			network to http://127.0.0.1:7545. Metamask GUI  
           should show that it is connected to Private Network

Step 2.13: Launch chrome browser and type in following URL in address bar to access dAPP GUI
http://localhost:3000 

Step 2.14: Start interacting with the dApp. Refer to user stories for details on interaction


## Actors in BountyPortal
There are following 3 actors

	* Contract Owner: There can be only 1 contract owner. Contract owner is decided at the time contract is deployed. It is not allowed to issue bounty or submit solution work  to bounty. It can only stop contract/resume contract/check & withdraw contract balance

	* Bounty Issuer: This is the job poster. There can be multiple job posters. A job poster can act as job hunter for bounties issued by other job posters. Job poster cannot submit work to its own bounty.

	* Bounty Executor: This is the job hunter. There can be multiple job hunters. Job hunter submits work the bounties issued by other bounty issuers. A job hunter can issue its own bounty and act as job poster as well for other job hunters. 


## Note

### You will need to uninstall and reinstall metamask chrome    
    extension OR reset metamask if javacript console in    
    BountyPortal dAPP GUI shows following message/error   
    "Error: the tx doesn't have
    the correct nonce. account has nonce of: 0 tx has nonce    
    of: 1". Refer to https://github.com/MetaMask/metamask-   
    extension/issues/1999
    for details 

### All Bounty ID & Bounty Work ID values in input fields referred to in stories (listed below) and GUI follow 0-based indexing

## User Stories

### Story 01

##### Title: Contract Owner - Stop Contract
##### Description: 
	 Login as Contract Owner. Click Stop Contract button and bring contract to stopped state to prevent issuance of/ submission of work to bounties, prevent withdrawal of contract balance. Click Refresh this page button

##### Acceptance Criteria: 
	 When contract owner is logged in, clicking Stop Contract Button & refreshing the page displays message that contract is stopped. The only control in GUI that remain enabled are Resume Contract, Know Contract Balance and Refresh this page buttons. Remaining other controls beccome disabled as no other operation allowed in stopped state

### Story 02

#### Title: Contract Owner - Resume Contract
#### Description: 
	Login as Contract Owner. Click Resume Contract button and bring contract to resumed state to allow issuance, execution of bounties and to allow contract owner to withdraw contract balance

#### Acceptance Criteria: 
	When contract owner is logged in, clicking Resume Contract Button & refreshing  the page displays message that contract is Not Stopped. Thereafter attempts by other users to issue bounty,execute bounty are successful and attempt by contract owner to withdraw contract balance succeeds. Button Resume Contract in GUI becomes disabled. Remaining other controls beccome enabled as all other operations allowed in Not Stopped state

### Story 03

#### Title: Contract Owner - Know Contract Balance

#### Description: 
     Login as Contract Owner. Click Know Contract Balance button to know contract balance (in wei)

#### Acceptance Criteria: 
	When contract owner is logged in, clicking Know Contract Balance Button displays contract balance (in wei).  


### Story 04

#### Title: Contract Owner - Withdraw Contract Balance

#### Description: 
	Login as Contract Owner. Click Know Contract Balance and note the balance displayed. Then Click Withdraw Contract Balance button to withdraw contract balance.  Then again click Know Contract Balance and note the balance displayed. Notice that overall contract balance has dropped to a lesser value and contract balance withdrawable by contract owner has dropped to 0 wei.

#### Acceptance Criteria: 
	When contract owner is logged in, overall contract balance reduces and contract balance withdrawable by contract owner dropps to 0 wei after balance is withdrawn by contract owner.  Also balance of contract owner increases by an equivalent amount. Another immediate attempt by contract owner to withdraw contract balance should fail
	
### Story 05

#### Title: Not a Contract Owner - Stop Contract/Resume Contract should not be allowed

#### Description: 
	Login as someone other than contract owner and notice that buttons Stop Contract/Resume Contract are disabled 

#### Acceptance Criteria: 
	When a non-contract owner is logged in, buttons Stop Contract/Resume get disabled


### Story 06

#### Title: Not a Contract Owner - Know Contract Balance/Withdraw contract balance should not be allowed

#### Description: 
	Login as someone other than contract owner and and notice that buttons Know Contract Balance/Withdraw contract balance are disabled

#### Acceptance Criteria: 
	When a non-contract owner is logged in, buttons Know Contract Balance/Withdraw remain disabled

### Story 07

#### Title: Issue Bounty (i.e. create/post a job)

#### Description: 
	Login as someone other than contract owner. Enter text value in "Bounty Description" & numeric value in "Bounty Reward" fields. Click Create Bounty button. Bounty should get created. Click Refresh this page button and see master list shows that a bounty has been created and has correct details

#### Acceptance Criteria: 
     Bounty Id of newly created Bounty should be unique. Bounty details should show a correct reward value. Bounty status should be draft. Bounty cutoff should show  not applicable (because bounty is in draft state). Total count of bounties should go up by 1

Refer to Story #3 - Overall Contract Balance should increase by an amount (bounty reward + 1) wei
Refer to Story #3 - Contract Balance withdrawable by contract owner should increase by 1 wei

### Story 08

#### Title: Enable Bounty (i.e. allow bounty to accept job submissions)

#### Description: 
	Login as someone other than contract owner. Enter a numeric value in "Bounty Reward" field. Bounty id should be the id of bounty that logged in user had created.
Click Enable Bounty button. Bounty should get enabled. Click Refresh this page button and see that master list shows that the bounty has been updated.

  Refer to Story #3 - Overall Contract Balance should increase by 1 wei
Refer to Story #3 - Contract Balance withdrawable by contract owner should increase by 1 wei

#### Acceptance Criteria: Total count of bounties should remain unchanged. Bounty Status should change to Active. Bounty reward value should remain unchanged Bounty Id of enabled Bounty should remain unchanged. Bounty Cutoff should be 30 days ahead of the time when bounty was enabled. Trying to enable a bounty issued by some user other than logged in user should result in an error

### Story 09

#### Title: Bounty Executor - Submit Work for Bounty (i.e. submit work to a bounty as job hunter)

#### Description: 
	Login as someone other than contract owner. Enter a numeric value in "Bounty ID" field. Enter a text value in Bounty Work field. Bounty id should NOT BE the id of bounty that logged in user had created. Bounty id should NOT BE the id of bounty that is in Draft state. Click Execute Bounty button. Bounty execution  should get recorded with bounty. Click Refresh this page button and see that master list shows that the bounty has been updated.

#### Acceptance Criteria: 
     Total count of bounties should remain unchanged. Status of bounty which was executed should remain as Active.
Reward value of bounty which was executed should remain unchanged Id of bounty which was executed should remain unchanged Cutoff of bounty which was executed should remain unchanged Execution Count of bounty which was executed should go up by 1
      
Refer to Story #3 - Overall Contract Balance should increase by 1 wei
Refer to Story #3 - Contract Balance withdrawable by contract owner should increase by 1 wei
     
Execution of same bounty again by same user or a different user should increase execution count again. Repeat executions are allowed. Each execution is treated distinct
	

### Story 10

#### Title: Bounty Issuer - Review Proposed Work Submission(i.e. review submissions obtained for a bounty)

#### Description: 
	Login as someone other than contract owner. Enter numeric value in "Bounty ID" & "Bounty Execution ID" fields. Click Get Bounty Execution Details button. A pop message box should appear with work details.

#### Acceptance Criteria: 
	Pop up message box should show which bounty executor (i.e. job-hunter) submitted the work to bounty, the submission content that was submitted by job hunter, the status of work (whether accepted or not accepted by bounty issuer), the reward (in wei) that job hunter is eligible for. Reward shown will be 0 if bounty issuer has not accepted this work. Reward shown will be non-zero if bounty issuer has accepted this work. 
	
Keying in invalid indices in input fields should result in an error. Indices are 0-based. If logged in user is neither the issuer (i.e. job poster) nor the executor (i.e.job hunter) of the bounty for which execution details needed, then logged  in user should not be able to see the execution details

### Story 11

#### Title: Bounty Issuer - Accept Bounty Work Details(i.e. accepted one of the work submissions obtained for a bounty)

#### Description: 
	Login as someone other than contract owner. Enter numeric value in "Bounty ID" & "Bounty Work ID" fields. Click Accept Bounty Work button. Bounty Work should get accepted. Click Refresh this page button.

#### Acceptance Criteria: 
	
Total count of bounties should remain unchanged.
Status of bounty for which work was accepted should change to Closed. Reward value of bounty for which work was accepted should remain unchanged.

Checking Bounty Work  details (refer to story #10) should show that reward amount due to job-hunter has changed from 0 to a non-zero value (equal to reward of the bounty) 

Refer to Story #3 - Overall Contract Balance should increase by 1 wei
Refer to Story #3 - Contract Balance withdrawable by contract owner should increase by 1 wei
     
Trying to accept work for same bounty again by same user should result in error because bounty is in closed state now

Keying in invalid indices in input fields should result in an error. Indices are 0-based. 


### Story 12

#### Title: Bounty Executor (Job Hunter) - Collect Bounty Reward (i.e. a job hunter whose work for a bounty has been accepted by bounty issuer, should be able to collect reward)

#### Description: 
	Login as someone other than contract owner. Enter numeric value in "Bounty ID" & "Bounty Execution ID" fields. 	Click Collect Bounty Reward button. Ether should get 	transferred from contract to the bounty executor (i.e. to the job hunter). Click Refresh this page button. 
	
#### Acceptance Criteria: 
	
Total count of bounties should remain unchanged.
Status of bounty for which was accepted should remain as Closed. Reward value of bounty for which was work was accepted should remain unchanged
     
Checking Bounty Work details (refer to story #10) should show that reward eligibility of job hunter has changed from a non-zero value to 0 (because ether has been transferred already and no more ether pertaining to this execution remains to be transferred to job hunter)

Trying to collect reward for a work that logged in user has not submitted should result in error 

Keying in invalid indices in input fields should result in an error. Indices are 0-based. 


### Story 12

#### Title: Contract Owner - Should not be able to Create Bounty, Enable Bounty, Review Proposed Work Submission, Accept Bounty Work

#### Description: 
	Login as contract owner. Note that buttons and text boxes for Create Bounty, Enable Bounty, Review Proposed Work Submission, Accept Bounty Work get disabled
	
#### Acceptance Criteria: 
	When logged in as contract owner, buttons and text boxes for Create Bounty, Enable Bounty, Review Proposed Work Submission, Accept Bounty Work get disabled
	Further, if contract is in  NOT Stopped State then buttons Stop Contract, Resume Contract, Know Contract Balance, Withdraw Contract Balance remain enabled.
	if contract is Stopped State then buttons Resume Contract, Know Contract Balance remain enabled but buttons Stop Contract, Withdraw Contract Balance get disabled.

Total count of bounties should remain unchanged.
Status of bounty for which was accepted should remain as Closed. Reward value of bounty for which was work was accepted should remain unchanged
     
Checking Bounty Work details (refer to story #10) should show that reward eligibility of job hunter has changed from a non-zero value to 0 (because ether has been transferred already and no more ether pertaining to this work submission remains to be transferred to job hunter)

Trying to collect reward for a work that logged in user has not submitted should result in error 

Keying in invalid indices in input fields should result in an error. Indices are 0-based. 

