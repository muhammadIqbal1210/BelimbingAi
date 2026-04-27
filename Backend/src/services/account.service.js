const { Account, Customer, DepositoType } = require('../models');

/**
 * Create an account
 * @param {Object} accountBody
 * @returns {Promise<Account>}
 */
const createAccount = async (accountBody) => {
  // Verify customer exists
  const customer = await Customer.findById(accountBody.customerId);
  if (!customer) {
    throw new Error('Customer not found');
  }

  // Verify deposito type exists
  const depositoType = await DepositoType.findById(accountBody.depositoTypeId);
  if (!depositoType) {
    throw new Error('Deposito type not found');
  }

  return Account.create(accountBody);
};

/**
 * Query for accounts
 * @param {Object} filter - Mongo filter
 * @param {Object} options - Query options
 * @param {string} [options.sortBy] - Sort option in the format: sortField:(desc|asc)
 * @param {number} [options.limit] - Maximum number of results per page
 * @param {number} [options.page] - Current page (default: 1)
 * @returns {Promise<QueryResult>}
 */
const queryAccounts = async (filter, options) => {
  const accounts = await Account.paginate(filter, options);
  return accounts;
};

/**
 * Get account by id
 * @param {ObjectId} id
 * @returns {Promise<Account>}
 */
const getAccountById = async (id) => {
  return Account.findById(id).populate('customerId').populate('depositoTypeId');
};

/**
 * Get accounts by customer id
 * @param {ObjectId} customerId
 * @returns {Promise<Array>}
 */
const getAccountsByCustomerId = async (customerId) => {
  return Account.find({ customerId }).populate('customerId').populate('depositoTypeId');
};

/**
 * Update account by id
 * @param {ObjectId} accountId
 * @param {Object} updateBody
 * @returns {Promise<Account>}
 */
const updateAccountById = async (accountId, updateBody) => {
  const account = await getAccountById(accountId);
  if (!account) {
    throw new Error('Account not found');
  }

  if (updateBody.depositoTypeId) {
    const depositoType = await DepositoType.findById(updateBody.depositoTypeId);
    if (!depositoType) {
      throw new Error('Deposito type not found');
    }
  }

  Object.assign(account, updateBody);
  await account.save();
  return account;
};

/**
 * Delete account by id
 * @param {ObjectId} accountId
 * @returns {Promise<Account>}
 */
const deleteAccountById = async (accountId) => {
  const account = await getAccountById(accountId);
  if (!account) {
    throw new Error('Account not found');
  }
  await Account.deleteOne({ _id: accountId });
  return account;
};

module.exports = {
  createAccount,
  queryAccounts,
  getAccountById,
  getAccountsByCustomerId,
  updateAccountById,
  deleteAccountById,
};
