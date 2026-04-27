const { Account, DepositoType } = require('../models');

/**
 * Calculate total months between two dates
 * @param {Date} startDate
 * @param {Date} endDate
 * @returns {number} Total months
 */
const calculateMonths = (startDate, endDate) => {
  let months = (endDate.getFullYear() - startDate.getFullYear()) * 12;
  months += endDate.getMonth() - startDate.getMonth();
  return Math.max(0, months);
};

/**
 * Perform withdrawal from account
 * Ending Balance = Starting Balance * Total Months * (Yearly Return / 12) / 100
 * @param {ObjectId} accountId
 * @param {Date} withdrawalDate - Tanggal penarikan
 * @returns {Promise<Object>} Withdrawal result with ending balance
 */
const withdraw = async (accountId, withdrawalDate) => {
  const account = await Account.findById(accountId).populate('depositoTypeId');

  if (!account) {
    throw new Error('Account not found');
  }

  // Validate withdrawal date
  if (!withdrawalDate || typeof withdrawalDate !== 'object' || !(withdrawalDate instanceof Date)) {
    throw new Error('Invalid withdrawal date');
  }

  if (withdrawalDate < account.depositDate) {
    throw new Error('Withdrawal date cannot be before deposit date');
  }

  // Calculate total months
  const totalMonths = calculateMonths(account.depositDate, withdrawalDate);

  // Get deposito type for yearly return rate
  const depositoType = await DepositoType.findById(account.depositoTypeId);
  if (!depositoType) {
    throw new Error('Deposito type not found');
  }

  // Calculate ending balance
  // Ending Balance = Starting Balance * (1 + (Total Months * (Yearly Return / 12 / 100)))
  const monthlyRate = depositoType.yearlyReturn / 12 / 100;
  const interest = account.balance * totalMonths * monthlyRate;
  const endingBalance = account.balance + interest;

  // Check if balance is sufficient
  if (endingBalance < 0) {
    throw new Error('Insufficient balance');
  }

  // Update account balance
  account.balance = 0;
  await account.save();

  return {
    accountId: account._id,
    customerId: account.customerId,
    depositoTypeId: account.depositoTypeId,
    depositoTypeName: depositoType.name,
    yearlyReturn: depositoType.yearlyReturn,
    depositDate: account.depositDate,
    withdrawalDate,
    totalMonths,
    startingBalance: account.balance + interest, // Original balance before withdrawal
    interest,
    endingBalance,
    message: `Penarikan berhasil. Saldo akhir: ${endingBalance}`,
  };
};

/**
 * Calculate potential withdrawal amount without actually withdrawing
 * @param {ObjectId} accountId
 * @param {Date} withdrawalDate - Tanggal penarikan
 * @returns {Promise<Object>} Calculation result
 */
const calculateWithdrawal = async (accountId, withdrawalDate) => {
  const account = await Account.findById(accountId).populate('depositoTypeId');

  if (!account) {
    throw new Error('Account not found');
  }

  // Validate withdrawal date
  if (!withdrawalDate || typeof withdrawalDate !== 'object' || !(withdrawalDate instanceof Date)) {
    throw new Error('Invalid withdrawal date');
  }

  if (withdrawalDate < account.depositDate) {
    throw new Error('Withdrawal date cannot be before deposit date');
  }

  // Calculate total months
  const totalMonths = calculateMonths(account.depositDate, withdrawalDate);

  // Get deposito type for yearly return rate
  const depositoType = await DepositoType.findById(account.depositoTypeId);
  if (!depositoType) {
    throw new Error('Deposito type not found');
  }

  // Calculate ending balance
  const monthlyRate = depositoType.yearlyReturn / 12 / 100;
  const interest = account.balance * totalMonths * monthlyRate;
  const endingBalance = account.balance + interest;

  return {
    accountId: account._id,
    customerId: account.customerId,
    depositoTypeId: account.depositoTypeId,
    depositoTypeName: depositoType.name,
    yearlyReturn: depositoType.yearlyReturn,
    depositDate: account.depositDate,
    withdrawalDate,
    totalMonths,
    startingBalance: account.balance,
    interest,
    endingBalance,
  };
};

module.exports = {
  withdraw,
  calculateWithdrawal,
  calculateMonths,
};
