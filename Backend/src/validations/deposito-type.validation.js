const Joi = require('joi');

const createDepositoType = {
  body: Joi.object().keys({
    name: Joi.string().required().trim(),
    yearlyReturn: Joi.number().required().min(0).max(100),
  }),
};

const getDepositoType = {
  params: Joi.object().keys({
    depositoTypeId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
};

const updateDepositoType = {
  params: Joi.object().keys({
    depositoTypeId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
  body: Joi.object().keys({
    name: Joi.string().trim(),
    yearlyReturn: Joi.number().min(0).max(100),
  }),
};

const deleteDepositoType = {
  params: Joi.object().keys({
    depositoTypeId: Joi.string().custom((value, helpers) => {
      if (!value.match(/^[0-9a-fA-F]{24}$/)) {
        return helpers.error('any.invalid');
      }
      return value;
    }),
  }),
};

module.exports = {
  createDepositoType,
  getDepositoType,
  updateDepositoType,
  deleteDepositoType,
};
