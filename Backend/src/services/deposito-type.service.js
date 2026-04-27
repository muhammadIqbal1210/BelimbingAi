const { DepositoType } = require('../models');

/**
 * Create a deposito type
 * @param {Object} depositoTypeBody
 * @returns {Promise<DepositoType>}
 */
const createDepositoType = async (depositoTypeBody) => {
  return DepositoType.create(depositoTypeBody);
};

/**
 * Query for deposito types
 * @param {Object} filter - Mongo filter
 * @param {Object} options - Query options
 * @param {string} [options.sortBy] - Sort option in the format: sortField:(desc|asc)
 * @param {number} [options.limit] - Maximum number of results per page
 * @param {number} [options.page] - Current page (default: 1)
 * @returns {Promise<QueryResult>}
 */
const queryDepositoTypes = async (filter, options) => {
  const depositoTypes = await DepositoType.paginate(filter, options);
  return depositoTypes;
};

/**
 * Get deposito type by id
 * @param {ObjectId} id
 * @returns {Promise<DepositoType>}
 */
const getDepositoTypeById = async (id) => {
  return DepositoType.findById(id);
};

/**
 * Get deposito type by name
 * @param {string} name
 * @returns {Promise<DepositoType>}
 */
const getDepositoTypeByName = async (name) => {
  return DepositoType.findOne({ name });
};

/**
 * Update deposito type by id
 * @param {ObjectId} depositoTypeId
 * @param {Object} updateBody
 * @returns {Promise<DepositoType>}
 */
const updateDepositoTypeById = async (depositoTypeId, updateBody) => {
  const depositoType = await getDepositoTypeById(depositoTypeId);
  if (!depositoType) {
    throw new Error('Deposito type not found');
  }
  Object.assign(depositoType, updateBody);
  await depositoType.save();
  return depositoType;
};

/**
 * Delete deposito type by id
 * @param {ObjectId} depositoTypeId
 * @returns {Promise<DepositoType>}
 */
const deleteDepositoTypeById = async (depositoTypeId) => {
  const depositoType = await getDepositoTypeById(depositoTypeId);
  if (!depositoType) {
    throw new Error('Deposito type not found');
  }
  await DepositoType.deleteOne({ _id: depositoTypeId });
  return depositoType;
};

module.exports = {
  createDepositoType,
  queryDepositoTypes,
  getDepositoTypeById,
  getDepositoTypeByName,
  updateDepositoTypeById,
  deleteDepositoTypeById,
};
