const Joi = require('joi');
const { objectId } = require('./custom.validation');

const createCustomer = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    address: Joi.string().allow(''),
    phone: Joi.string().allow(''),
    email: Joi.string().email().allow(''),
  }),
};

const getCustomers = {
  query: Joi.object().keys({
    name: Joi.string(),
    sortBy: Joi.string(),
    limit: Joi.number().integer(),
    page: Joi.number().integer(),
  }),
};

const updateCustomer = {
  params: Joi.object().keys({
    customerId: Joi.string().custom(objectId),
  }),
  body: Joi.object()
    .keys({
      name: Joi.string(),
      address: Joi.string(),
      phone: Joi.string(),
      email: Joi.string().email(),
    })
    .min(1),
};

module.exports = {
  createCustomer,
  getCustomers,
  updateCustomer,
};
