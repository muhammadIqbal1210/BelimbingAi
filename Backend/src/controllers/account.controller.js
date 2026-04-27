const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { accountService, withdrawService } = require('../services');
const ApiError = require('../utils/ApiError');

const createAccount = catchAsync(async (req, res) => {
  const account = await accountService.createAccount(req.body);
  res.status(httpStatus.CREATED).send(account);
});

const getAccounts = catchAsync(async (req, res) => {
  const filter = {};
  const options = {
    limit: req.query.limit ? parseInt(req.query.limit, 10) : 10,
    page: req.query.page ? parseInt(req.query.page, 10) : 1,
  };
  const result = await accountService.queryAccounts(filter, options);
  res.send(result);
});

const getAccount = catchAsync(async (req, res) => {
  const account = await accountService.getAccountById(req.params.accountId);
  if (!account) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Account not found');
  }
  res.send(account);
});

const getAccountsByCustomer = catchAsync(async (req, res) => {
  const accounts = await accountService.getAccountsByCustomerId(req.params.customerId);
  res.send(accounts);
});

const updateAccount = catchAsync(async (req, res) => {
  const account = await accountService.updateAccountById(req.params.accountId, req.body);
  res.send(account);
});

const deleteAccount = catchAsync(async (req, res) => {
  await accountService.deleteAccountById(req.params.accountId);
  res.status(httpStatus.NO_CONTENT).send();
});

const calculateWithdrawal = catchAsync(async (req, res) => {
  const { withdrawalDate } = req.body;

  if (!withdrawalDate) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Withdrawal date is required');
  }

  const result = await withdrawService.calculateWithdrawal(req.params.accountId, new Date(withdrawalDate));
  res.send(result);
});

const withdraw = catchAsync(async (req, res) => {
  const { withdrawalDate } = req.body;

  if (!withdrawalDate) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Withdrawal date is required');
  }

  const result = await withdrawService.withdraw(req.params.accountId, new Date(withdrawalDate));
  res.send(result);
});

module.exports = {
  createAccount,
  getAccounts,
  getAccount,
  getAccountsByCustomer,
  updateAccount,
  deleteAccount,
  calculateWithdrawal,
  withdraw,
};
