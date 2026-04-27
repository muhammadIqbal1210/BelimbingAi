const express = require('express');
const validate = require('../../middlewares/validate');
const { customerController } = require('../../controllers');
const { customerValidation } = require('../../validations');

const router = express.Router();

router
  .route('/')
  .post(validate(customerValidation.createCustomer), customerController.createCustomer)
  .get(customerController.getCustomers);

router
  .route('/:customerId')
  .get(validate(customerValidation.getCustomer), customerController.getCustomer)
  .patch(validate(customerValidation.updateCustomer), customerController.updateCustomer)
  .delete(validate(customerValidation.deleteCustomer), customerController.deleteCustomer);

module.exports = router;
