# Following measures taken to ensure that BountyPortal contract is not susceptible to common attacks 

1. Used msg.sender instead of tx.origin while transferring ether
2. Explicitly marked visibility in functions and state variables
3. Refer to file design_pattern_decisions.md to know the behavioral and security patterns I have used to guard against
   various attacks	
