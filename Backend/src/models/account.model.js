const mongoose = require('mongoose');
const { toJSON, paginate } = require('./plugins');

const accountSchema = mongoose.Schema(
  {
    customerId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'Customer',
      required: true,
    },
    depositoTypeId: {
      type: mongoose.SchemaTypes.ObjectId,
      ref: 'DepositoType',
      required: true,
    },
    balance: {
      type: Number,
      required: true,
      default: 0,
      min: 0,
    },
    depositDate: {
      type: Date,
      required: true,
      description: 'Tanggal setoran awal',
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
accountSchema.plugin(toJSON);
accountSchema.plugin(paginate);

/**
 * @typedef Account
 */
const Account = mongoose.model('Account', accountSchema);

module.exports = Account;
