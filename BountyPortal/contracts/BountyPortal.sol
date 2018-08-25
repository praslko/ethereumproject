pragma solidity ^0.4.23;

/// @title Contract for Bounty Portal
/// @author Prashant Saxena <pras.lko@gmail.com>
/// @notice Implements "Emergency Stop" pattern, Checks-Effects-Interaction pattern and "Pull over Push" pattern


contract BountyPortal { 
    bool m_isStopped;
    uint stringLengthLimit = 100;
    uint secondsIn30Days = 2592000;
    
    enum BountyStatus {
        Draft, // Created but not accepting bids
        Active, // Accepting bids
        Closed  // No more accepting bids
    }
    
    struct Bounty {
    	address m_issuer; // issuer of bounty
    	string m_desc; // SOW of bounty
    	uint256 m_reward; // Reward to be paid if bounty execution accepted by issuer
    	uint16 m_executionCount; // Total # of bids for bounty`
    	BountyStatus m_status; // Status of bounty [Draft|Active|Closed]
	    uint256  m_cutOff; // Cut off after which no bids accepted for this bounty
    }
    
    struct BountyExecution {
        bool m_accepted; // Flag to indicated if this execution accepted by issuer
        address m_executor; // address of executor
        string m_executionContent; // Executor's Respone to SOW 
        uint256 m_paymentAmount; // Amount (in wei) won by executor
    }  
    
    address private m_bountyPortalOwner;
    Bounty [] private m_bountyArr; // Holds ids for all bounties. 
    mapping(uint16=>BountyExecution[]) private m_bountyExecutionMap; // Holds execution details for each bounty
    mapping(address=>uint16[]) private m_bountyIdsCreatedMap; // Holds ids of bounties created by issuer
    mapping(address=>uint16[]) private m_bountyIdsExecutedMap; // Holds ids of bounties executed by executor
    uint256 m_withdrawable_balance;
    /////////////////////////////////////////////
    // Start of public function  definitions
    /////////////////////////////////////////////
    
    constructor (address _bountyPortalOwner) 
    public
    {
        require (_bountyPortalOwner != address(0x0));
        m_bountyPortalOwner = _bountyPortalOwner;
        m_isStopped = false;
        m_withdrawable_balance = 0;
    }

    /// @dev getContractBalance(): gets contract balance  
    /// @return contract balance (in wei)
    
    function getContractBalance() 
    public 
    constant 
    isValidBountyPortalOwner() // Only contract owner should be able to check contract balance
    returns (uint256 contract_balance, uint256 withdrawable_balance)  {
        contract_balance = address(this).balance;
        withdrawable_balance = m_withdrawable_balance;
    }
	
	/// @dev getContractOwner(): gets contract owner address  
    /// @return contract owner address
    
    function getContractOwner() 
    public 
    constant 
    returns (address)  {
        return m_bountyPortalOwner;
    }
	/// @dev transferContractBalanceToContractOwner(): transfers contract balance (in wei) to contract owner  
    
    function withdrawContractBalance() 
    public
    isNotStopped()
    isValidBountyPortalOwner() //Only contract owner can withdraw contract balance
    {
        //  Using Checks-Effects-Interaction Pattern
        // Check
        require(address(this).balance > 0 && m_withdrawable_balance > 0);
        uint256 balance_to_transfer = m_withdrawable_balance;
        // Effect
        m_withdrawable_balance = 0;
        // Transfer
        m_bountyPortalOwner.transfer(balance_to_transfer);
    }
	
	/// @dev incrementWithdrawableBalance(): increments withdrawable (by contract owner) balance
	
	function incrementWithdrawableBalance()
	private
	{
	    // increment withdrawable balance by 1 wei
        m_withdrawable_balance = m_withdrawable_balance + 1;   
	}
	
	/// @dev createBounty(): creates a new bounty. Bounty created is in Draft state. Expects gas (bounty reward plus 1 wei)from sender of txn.
  	/// @param _bountyData the statement of work of the bounty
  	/// @param _bountyReward the amount (in wei) to be paid by bounty issuer to the bounty executor
    /// @return number of bounties
    
    function createBounty(
        string _bountyData,
        uint256 _bountyReward
    )
    public
    payable
    isNotStopped()
    isNotBountyPortalOwner()
    isStringNotEmptyAndNotTooLong(_bountyData)
    isValidReward(_bountyReward)
    returns (uint16 _numBounties)
    {
         // Check that gas supplied is sufficient
        require (msg.value >= _bountyReward + 1);
	    m_bountyArr.push(Bounty(msg.sender, _bountyData, _bountyReward, 0, BountyStatus.Draft, 0));
        m_bountyIdsCreatedMap[msg.sender].push(uint16(m_bountyArr.length) - 1); 
        emit LogBountyCreated(uint16(m_bountyArr.length) - 1);
        incrementWithdrawableBalance();
        _numBounties = uint16(m_bountyArr.length);
        assert(m_bountyArr.length + 1 > m_bountyArr.length);
        assert(m_bountyIdsCreatedMap[msg.sender].length + 1 > m_bountyIdsCreatedMap[msg.sender].length);
    }
 
    /// @dev enableBounty(): set bounty status to Active. Expects gas (1 wei) from sender of txn.
  	/// @param _bountyId the id of the bounty which is to be made active
  	
  	function enableBounty(
        uint16 _bountyId
    )
    public
    payable
    isNotStopped()
    isValidBountyArrayIndex(_bountyId)
    isValidBountyIssuer(_bountyId)
    { 
        require(msg.value >= 1); // Min. 1 wei needed. Sender of txn. can send more
        require(m_bountyArr[_bountyId].m_status == BountyStatus.Draft);
        m_bountyArr[_bountyId].m_status = BountyStatus.Active;
        // Cutoff is exactly 30 days after the bounty is enabled
        m_bountyArr[_bountyId].m_cutOff = now + secondsIn30Days; 
        emit LogBountyStatusChanged(_bountyId, BountyStatus.Draft, BountyStatus.Active);
        incrementWithdrawableBalance();
    }
    
    /// @dev disableBounty(): set bounty status to Closed
  	/// @param _bountyId the id of the bounty which is to be Closed
  	
    function disableBounty(
        uint16 _bountyId
    )
    private
    isNotStopped()
    isValidBountyArrayIndex(_bountyId)
    isValidBountyIssuer(_bountyId)
    {
        BountyStatus oldStatus = m_bountyArr[_bountyId].m_status;
        require(oldStatus != BountyStatus.Closed);
        if (m_bountyArr[_bountyId].m_status == BountyStatus.Active) {
            require (m_bountyArr[_bountyId].m_cutOff > now);
        }
        m_bountyArr[_bountyId].m_status = BountyStatus.Closed;
        emit LogBountyStatusChanged(_bountyId, oldStatus, BountyStatus.Closed);
    }
  
    /// @dev getBountyExecution(): get execution details of specific bid for bounty
  	/// @param _bountyId the id of the bounty for which execution details of specific bid needed
  	/// @param _bountyExecutionId the id of the execution for which details needed
  	/// @return quadruple (acceptance status[true|false], address of executor, execution content, amount (in wei) due to executor)
  	
    function getBountyExecution(
	    uint16 _bountyId,
        uint16 _bountyExecutionId
    )
    public
    constant
    isNotStopped()
    isValidBountyArrayIndex(_bountyId)
    isValidBountyIssuerOrExecutor(_bountyId, _bountyExecutionId)
    isValidBountyExecutionArrayIndex(_bountyId, _bountyExecutionId)
    returns (bool, address, string, uint256)
    {
        return (m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_accepted,
            m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_executor,
            m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_executionContent, 
            m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_paymentAmount);
    }
    
    /// @dev acceptBountyExecution(): accept execution of specific bid for bounty. Expects gas (1 wei) fro sender of txn.
  	/// @param _bountyId the id of the bounty for which execution is to be accepted
  	/// @param _bountyExecutionId the id of the execution  which is to be accepted
  	
    function acceptBountyExecution(
      uint16 _bountyId,
      uint16 _bountyExecutionId
    )
    public
    payable
    isNotStopped()
    isValidBountyArrayIndex(_bountyId)
    isValidBountyIssuer(_bountyId)
    isValidBountyExecutionArrayIndex(_bountyId, _bountyExecutionId)
    {
        require (msg.value >= 1); // Min. 1 wei needed. Sender of txn. can send more 
        require (m_bountyArr[_bountyId].m_cutOff > now);
        require (m_bountyArr[_bountyId].m_status == BountyStatus.Active);
        m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_accepted = true;
        
        assignBountyReward(_bountyId, _bountyExecutionId);
        disableBounty(_bountyId);
        emit LogBountyExecutionAccepted(_bountyId, _bountyExecutionId);
        incrementWithdrawableBalance();
    }
    
    /// @dev assignBountyReward(): assigns the reward payable to bounty executor
  	/// @param _bountyId the id of the bounty for which reward is to be assigned
  	/// @param _bountyExecutionId the id of the execution to which reward is to be assigned
    
    function assignBountyReward(
      uint16 _bountyId,
      uint16 _bountyExecutionId
    )
    private
    {
        m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_paymentAmount
            = m_bountyArr[_bountyId].m_reward;
        
    }
    /// @dev getBountyDetails(): get details of bounty
  	/// @param _bountyId the id of the bounty for which details needed
  	/// @return quadruple (address of issuer, sow of bounty, reward (in wei) if accepted, # of executions, status, cut off after which no execution allowed)
  	
    function getBountyDetails(uint16 _bountyId)
      public
      constant
      isValidBountyArrayIndex(_bountyId)
      returns (uint16, address, string, uint256, uint16,  uint, uint256)
    {
      return (_bountyId, 
              m_bountyArr[_bountyId].m_issuer,
              m_bountyArr[_bountyId].m_desc,
              m_bountyArr[_bountyId].m_reward,
              m_bountyArr[_bountyId].m_executionCount,
              uint(m_bountyArr[_bountyId].m_status),
              uint(m_bountyArr[_bountyId].m_cutOff)
              );
    }

    
    /// @dev executeBounty(): execute bounty. Expects gas (1 wei) from sender of txn.
  	/// @param _bountyId the id of the bounty  which is to be executed
  	/// @param _bountyExecutionData the execution data of the bounty for this specific execution
  	
    function executeBounty(
      uint16 _bountyId,
      string _bountyExecutionData
    )
    public
    payable 
    isNotStopped()
    isValidBountyArrayIndex(_bountyId)
    isNotBountyIssuer(_bountyId)
    isNotBountyPortalOwner()
    isNotAlreadyExecuted(_bountyId)
    isStringNotEmptyAndNotTooLong(_bountyExecutionData)
    {
        require (msg.value >= 1); // Min. 1 wei needed. Sender of txn. can send more
        require (m_bountyArr[_bountyId].m_status == BountyStatus.Active);
        require (m_bountyArr[_bountyId].m_cutOff > now);
        m_bountyExecutionMap[_bountyId].push(
            BountyExecution(false, msg.sender, _bountyExecutionData, 0));
        m_bountyIdsExecutedMap[msg.sender].push(_bountyId);
        m_bountyArr[_bountyId].m_executionCount++;   
	    emit LogBountyExecuted(_bountyId, msg.sender);
	    incrementWithdrawableBalance();
	    assert(m_bountyExecutionMap[_bountyId].length + 1 > m_bountyExecutionMap[_bountyId].length);
	    assert(m_bountyIdsExecutedMap[msg.sender].length + 1 > m_bountyIdsExecutedMap[msg.sender].length);
    }
    
    /// @dev collectBountyReward(): collect bounty reward
  	/// @param _bountyId the id of the bounty  for which reward is to be collected
  	/// @param _bountyExecutionId the id of the execution for which reward is to be collected
  	
    function collectBountyReward(
      uint16 _bountyId, 
      uint16 _bountyExecutionId
    )
    public
    isNotStopped()
    isValidBountyArrayIndex(_bountyId)
    isValidBountyExecutionArrayIndex(_bountyId, _bountyExecutionId)
    isValidBountyExecutor(_bountyId, _bountyExecutionId)
    {
        // Using Checks-Effects-Interaction pattern
        uint256 reward = m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_paymentAmount;
        //  Check 
        require(m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_paymentAmount > 0);
        require(m_bountyArr[_bountyId].m_status == BountyStatus.Closed);
        require(m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_accepted == true);
        // Effect
        m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_paymentAmount = 0;
        emit LogRewardCollected(msg.sender, reward);
        // Transfer
        msg.sender.transfer(reward);
    }
    
    /// @dev getBountyCount(): get total number of bounties
  	/// @return number of bounties
    
    function getBountyCount()
      public
      constant
      returns (uint16 _numBounties)
    {
      require (msg.sender == m_bountyPortalOwner);
      _numBounties = uint16(m_bountyArr.length);
    }

    /// @dev getBountyExecutionCount(): get number of executions for bounty
  	/// @param _bountyId   id of bounty for which execution count needed
  	/// @return number of executions for the bounty
    
    function getBountyExecutionCount(
        uint16 _bountyId
    )
    public
    constant
    isNotStopped()
    isValidBountyIssuer(_bountyId)
    returns (uint16)
    {
        return uint16(m_bountyExecutionMap[_bountyId].length);
    }
    
    /// @dev stopContract(): Stops the Contract
  	
    function stopContract() public isValidBountyPortalOwner() {
        m_isStopped = true;
    }

    /// @dev resumeContract(): Resumes the Contract
  	
    function resumeContract() public isValidBountyPortalOwner() {
        m_isStopped = false;
    }
    
    /// @dev isContractStopped(): Returns boolean flag indicating if Contract is Stopped
  	/// @return contract state
    function isContractStopped() public constant returns (bool) {
        return m_isStopped;
    }
    /////////////////////////////////////////////
    // End of public function definitions
    /////////////////////////////////////////////
    
    
    /////////////////////////////////////////////
    // Start of modifier definitions
    /////////////////////////////////////////////
    
    modifier isStringNotEmptyAndNotTooLong(
    string  _str
    ) 
    {
        uint strLen = (bytes(_str)).length;
        require(strLen !=0 &&  strLen <= stringLengthLimit);
        _;
    }
    
    
    modifier isValidReward(
    uint256  _reward
    ) 
    {
        require(_reward > 0);
        _;
    }
    
    modifier isValidBountyIssuer(
    uint16 _bountyId
    ) 
    {
        require(msg.sender == m_bountyArr[_bountyId].m_issuer);
        _;
    }

    modifier isNotBountyIssuer(
    uint16 _bountyId
    ) 
    {
        require(msg.sender != m_bountyArr[_bountyId].m_issuer);
        _;
    }

    modifier isNotBountyPortalOwner()
    {
        require(msg.sender != m_bountyPortalOwner);
        _;
    }
    
    modifier isNotAlreadyExecuted(uint16 _bountyId)
    {
        uint16 count = uint16(m_bountyIdsExecutedMap[msg.sender].length);
        for (uint16 i = 0; i < count; i++)
        {
            require(m_bountyIdsExecutedMap[msg.sender][i] != _bountyId);
        }
        _;
    }
    
    modifier isValidBountyExecutor(
    uint16 _bountyId, 
    uint16 _bountyExecutionId 
    ) 
    {
        require(msg.sender == m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_executor);
         _;
    }

    modifier isValidBountyIssuerOrExecutor(
    uint16 _bountyId, 
    uint16 _bountyExecutionId 
    ) 
    {
		require((msg.sender == m_bountyArr[_bountyId].m_issuer) || (msg.sender == m_bountyExecutionMap[_bountyId][_bountyExecutionId].m_executor));
         _;
    }

    modifier isValidBountyArrayIndex(
    uint16 _bountyId
    )
    {
        require(_bountyId >=0 && _bountyId < m_bountyArr.length);
        _;
    }
    
    modifier isValidBountyExecutionArrayIndex(uint16 _bountyId, uint16 _bountyExecutionId) {
      require(_bountyExecutionId < m_bountyExecutionMap[_bountyId].length);
      _;
    }

    modifier isValidBountyPortalOwner() {
      require(msg.sender == m_bountyPortalOwner);
      _;
    }
    
    modifier isNotStopped() {
      require(m_isStopped == false);
      _;
    }
    /////////////////////////////////////////////
    // End of modifier definitions
    /////////////////////////////////////////////
    
    /////////////////////////////////////////////
    // Start of event list
    /////////////////////////////////////////////
    
    event LogBountyCreated(uint16 _bountyId);
    event LogBountyStatusChanged(uint16 _bountyId, BountyStatus _oldstatus, BountyStatus _newstatus);
    event LogBountyExecuted(uint16 _bountyId, address _executor);
    event LogBountyExecutionAccepted(uint16 _bountyId, uint16 _bountyExecutionId);
    event LogRewardCollected(address _executor, uint256 _reward);
    /////////////////////////////////////////////
    // End of event list
    /////////////////////////////////////////////
}