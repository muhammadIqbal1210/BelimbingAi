const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { customerService } = require('../services');
const ApiError = require('../utils/ApiError');

const createCustomer = catchAsync(async (req, res) => {
  const customer = await customerService.createCustomer(req.body);
  res.status(httpStatus.CREATED).send(customer);
});

const getCustomers = catchAsync(async (req, res) => {
  const filter = {};
  const options = {
    limit: req.query.limit ? parseInt(req.query.limit, 10) : 10,
    page: req.query.page ? parseInt(req.query.page, 10) : 1,
  };
  const result = await customerService.queryCustomers(filter, options);
  res.send(result);
});

const getCustomer = catchAsync(async (req, res) => {
  const customer = await customerService.getCustomerById(req.params.customerId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Customer not found');
  }
  res.send(customer);
});

const updateCustomer = catchAsync(async (req, res) => {
  const customer = await customerService.updateCustomerById(req.params.customerId, req.body);
  res.send(customer);
});

const deleteCustomer = catchAsync(async (req, res) => {
  await customerService.deleteCustomerById(req.params.customerId);
  res.status(httpStatus.NO_CONTENT).send();
});

module.exports = {
  createCustomer,
  getCustomers,
  getCustomer,
  updateCustomer,
  deleteCustomer,
};
