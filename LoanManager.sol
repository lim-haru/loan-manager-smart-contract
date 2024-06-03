// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LoanLibrary.sol";

contract LoanManager {
  address public owner;
  uint256 public dailyPenaltyRate; // Daily penalty rate in basis points (0.01% per point)
  
  constructor(uint _dailyPenaltyRate) {
    owner = msg.sender;
    dailyPenaltyRate = _dailyPenaltyRate;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }
  
  enum LoanStatus { created, active, paid, canceled }

  struct Loan {
    address payable borrower;
    address payable lender;
    uint amount;
    uint16 interestRate; // Interest rate in basis points (0.01% per point)
    uint16 duration; // In days
    uint startDate;
    uint endDate;
    LoanStatus status;
  }
  
  uint loanCount;
  mapping(uint => Loan) public loans;

  event LoanCreated(uint loanId, address indexed borrower, uint amount, uint16 interestRate, uint16 duration);
  event LoanFunded(uint loanId, address indexed lenders, uint startDate, uint endDate);
  event LoanRepaid(uint loanId, uint amountPaid);
  event PenaltyRateChanged(uint newRate);
  event LoanCanceled(uint loanId);
  
  function borrow(uint _amount, uint16 _interestRate, uint16 _duration) external {
    require(_amount > 0, "Loan amount must be greater than 0");
    require(_duration > 0, "Loan duration must be greater than 0");

    loanCount++;
    loans[loanCount] = Loan({
      borrower: payable(msg.sender),
      lender: payable(address(0)),
      amount: _amount,
      interestRate: _interestRate,
      duration: _duration,
      startDate: 0,
      endDate: 0,
      status: LoanStatus.created
    });
    
    emit LoanCreated(loanCount, msg.sender,_amount, _interestRate, _duration);
  }

  function lend(uint _loanId) external payable {
    Loan storage loan = loans[_loanId];

    require(loan.status == LoanStatus.created, "Loan is not in Created state");
    require(msg.value == loan.amount, "Incorrect amount");

    loan.lender = payable(msg.sender);
    loan.startDate = block.timestamp;
    loan.endDate = loan.startDate + (loan.duration * 1 days);

    loan.borrower.transfer(loan.amount);
    loan.status = LoanStatus.active;
    
    emit LoanFunded(_loanId, msg.sender, loan.startDate, loan.endDate);
  }

  function repayLoan(uint _loanId) external payable {
    Loan storage loan = loans[_loanId];
    
    require(loan.status == LoanStatus.active, "Loan is not active");
    require(msg.sender == loan.borrower, "Only borrower can repay the loan");

    uint interest = LoanLibrary.calculateInterest(loan.amount, loan.interestRate, loan.duration);
    uint totalAmountDue = loan.amount + interest;
    
    if (block.timestamp > loan.endDate) {
      uint penalty = LoanLibrary.calculatePenalty(loan.amount, loan.endDate, block.timestamp, dailyPenaltyRate);
      totalAmountDue += penalty;
    }
    
    require(msg.value >= totalAmountDue, "Incorrect repayment amount");
    loan.lender.transfer(totalAmountDue);
    loan.status = LoanStatus.paid;
    emit LoanRepaid(_loanId, totalAmountDue);
  }

  function cancelLoan(uint _loanId) public {
    Loan storage loan = loans[_loanId];

    require(msg.sender == loan.borrower, "Only borrower can cancel the loan");
    require(loan.status == LoanStatus.created, "Loan can only be canceled if it is in the created state");

    loan.status = LoanStatus.canceled;
    emit LoanCanceled(_loanId);
  }

  function setDailyPenaltyRate(uint _newRate) external onlyOwner {
    dailyPenaltyRate = _newRate;
    emit PenaltyRateChanged(_newRate);
  }

  function getLoanDetails(uint _loanId) external view returns (Loan memory) {
    return loans[_loanId];
  }
}
