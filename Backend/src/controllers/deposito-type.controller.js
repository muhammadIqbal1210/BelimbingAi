const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { depositoTypeService } = require('../services');
const ApiError = require('../utils/ApiError');

const createDepositoType = catchAsync(async (req, res) => {
  const depositoType = await depositoTypeService.createDepositoType(req.body);
  res.status(httpStatus.CREATED).send(depositoType);
});

const getDepositoTypes = catchAsync(async (req, res) => {
  const filter = {};
  const options = {
    limit: req.query.limit ? parseInt(req.query.limit, 10) : 10,
    page: req.query.page ? parseInt(req.query.page, 10) : 1,
  };
  const result = await depositoTypeService.queryDepositoTypes(filter, options);
  res.send(result);
});

const getDepositoType = catchAsync(async (req, res) => {
  const depositoType = await depositoTypeService.getDepositoTypeById(req.params.depositoTypeId);
  if (!depositoType) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Deposito type not found');
  }
  res.send(depositoType);
});

const updateDepositoType = catchAsync(async (req, res) => {
  const depositoType = await depositoTypeService.updateDepositoTypeById(req.params.depositoTypeId, req.body);
  res.send(depositoType);
});

const deleteDepositoType = catchAsync(async (req, res) => {
  await depositoTypeService.deleteDepositoTypeById(req.params.depositoTypeId);
  res.status(httpStatus.NO_CONTENT).send();
});

module.exports = {
  createDepositoType,
  getDepositoTypes,
  getDepositoType,
  updateDepositoType,
  deleteDepositoType,
};
