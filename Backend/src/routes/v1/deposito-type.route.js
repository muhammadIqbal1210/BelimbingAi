const express = require('express');
const validate = require('../../middlewares/validate');
const { depositoTypeController } = require('../../controllers');
const { depositoTypeValidation } = require('../../validations');

const router = express.Router();

router
  .route('/')
  .post(validate(depositoTypeValidation.createDepositoType), depositoTypeController.createDepositoType)
  .get(depositoTypeController.getDepositoTypes);

router
  .route('/:depositoTypeId')
  .get(validate(depositoTypeValidation.getDepositoType), depositoTypeController.getDepositoType)
  .patch(validate(depositoTypeValidation.updateDepositoType), depositoTypeController.updateDepositoType)
  .delete(validate(depositoTypeValidation.deleteDepositoType), depositoTypeController.deleteDepositoType);

module.exports = router;
