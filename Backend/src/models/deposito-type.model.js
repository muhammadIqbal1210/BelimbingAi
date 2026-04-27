const mongoose = require('mongoose');
const { toJSON, paginate } = require('./plugins');

const depositoTypeSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    yearlyReturn: {
      type: Number,
      required: true,
      min: 0,
      max: 100,
      description: 'Yearly return percentage',
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
depositoTypeSchema.plugin(toJSON);
depositoTypeSchema.plugin(paginate);

/**
 * @typedef DepositoType
 */
const DepositoType = mongoose.model('DepositoType', depositoTypeSchema);

module.exports = DepositoType;
