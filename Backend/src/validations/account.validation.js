const Joi = require('joi');

const createAccount = {
  body: Joi.object().keys({
    customerId: Joi.string()
      .required()
      .custom((value, helpers) => {
        if (!value.match(/^[0-9a-fA-F]{24}$/)) {
          return helpers.error('any.invalid');
        }
        return value;
      }),
    depositoTypeId: Joi.string()
      .required()
      .custom((value, helpers) => {
        if (!value.match(/^[0-9a-fA-F]{24}$/)) {
          return helpers.error('any.invalid');
        }
        return value;
      }),
    balance: Joi.number().required().min(0),
    depositDate: Joi.date().required(),
  }),
};

const getAccount = {
  params: Joi.object().keys({
    accountId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
};

const getAccountsByCustomer = {
  params: Joi.object().keys({
    customerId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
};

const updateAccount = {
  params: Joi.object().keys({
    accountId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
  body: Joi.object().keys({
    customerId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
    depositoTypeId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
    balance: Joi.number().min(0),
    depositDate: Joi.date(),
  }),
};

const deleteAccount = {
  params: Joi.object().keys({
    accountId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
};

const calculateWithdrawal = {
  params: Joi.object().keys({
    accountId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
  body: Joi.object().keys({
    withdrawalDate: Joi.date().required(),
  }),
};

const withdraw = {
  params: Joi.object().keys({
    accountId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
  body: Joi.object().keys({
    withdrawalDate: Joi.date().required(),
  }),
};

module.exports = {
  createAccount,
  getAccount,
  getAccountsByCustomer,
  updateAccount,
  deleteAccount,
  calculateWithdrawal,
  withdraw,
};
