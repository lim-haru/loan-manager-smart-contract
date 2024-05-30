// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoanManager {
  enum LoanStatus {created, active, paid, expired}

  struct Loan {
    address borrower;
    address lender;
    uint amount;
    uint16 interestRate;
    uint16 duration;
    uint startDate;
    uint endDate;
    LoanStatus status;
  }
  
  uint loanCount;
  mapping(uint => Loan) public loans;

  event LoanCreated(uint loanId, address indexed borrower, uint amount, uint16 interestRate, uint16 duration);
  event LoanFunded(uint loanId, address indexed lenders, uint startDate, uint endDate);
  
  function borrow(uint _amount, uint16 _interestRate, uint16 _duration) external {
    require(_amount > 0, "Loan amount must be greater than 0");
    require(_duration > 0, "Loan duration must be greater than 0");

    loanCount++;
    loans[loanCount] = Loan({
      borrower: msg.sender,
      lender: address(0),
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
    require(msg.value >= loan.amount, "Incorrect amount");

    loan.lender = msg.sender;
    loan.startDate = block.timestamp;
    loan.endDate = loan.startDate + (loan.duration * 1 days);

    payable(loan.borrower).transfer(loan.amount);
    loan.status = LoanStatus.active;
    
    emit LoanFunded(_loanId, msg.sender, loan.startDate, loan.endDate);
  }
}
