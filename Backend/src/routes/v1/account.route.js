const express = require('express');
const validate = require('../../middlewares/validate');
const { accountController } = require('../../controllers');
const { accountValidation } = require('../../validations');

const router = express.Router();

router
  .route('/')
  .post(validate(accountValidation.createAccount), accountController.createAccount)
  .get(accountController.getAccounts);

router
  .route('/:accountId')
  .get(validate(accountValidation.getAccount), accountController.getAccount)
  .patch(validate(accountValidation.updateAccount), accountController.updateAccount)
  .delete(validate(accountValidation.deleteAccount), accountController.deleteAccount);

router
  .route('/:accountId/calculate-withdrawal')
  .post(validate(accountValidation.calculateWithdrawal), accountController.calculateWithdrawal);

router
  .route('/:accountId/withdraw')
  .post(validate(accountValidation.withdraw), accountController.withdraw);

router
  .route('/customer/:customerId')
  .get(validate(accountValidation.getAccountsByCustomer), accountController.getAccountsByCustomer);

module.exports = router;
