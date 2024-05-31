// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LoanLibrary {
  function calculateInterest(uint amount, uint16 interestRate, uint16 duration) internal pure returns (uint) {
    uint interest = (amount * interestRate * duration) / (365 * 10000);
    return interest;
  }

  function calculatePenalty(uint amount, uint endDate, uint pagamentDate, uint dailyPenaltyRate) internal pure returns (uint) {
    require(pagamentDate > endDate, "Repayment is not late");
    uint daysLate = (pagamentDate - endDate) / 1 days;
    uint penalty = (amount * daysLate * dailyPenaltyRate) / 10000;
    return penalty;
  }
}