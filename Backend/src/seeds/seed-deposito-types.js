/**
 * Script untuk seed data deposito types ke database
 * Run: node src/seeds/seed-deposito-types.js
 */

const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');
const { DepositoType } = require('../models');
const config = require('../config/config');

// Load env variables
dotenv.config({ path: path.join(__dirname, '../../.env') });

const seedDepositoTypes = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(config.mongoose.url, config.mongoose.options);
    console.log('Connected to MongoDB');

    // Clear existing deposito types
    await DepositoType.deleteMany({});
    console.log('Cleared existing deposito types');

    // Create default deposito types
    const depositoTypes = [
      { name: 'Bronze', yearlyReturn: 3 },
      { name: 'Silver', yearlyReturn: 5 },
      { name: 'Gold', yearlyReturn: 7 },
    ];

    const createdTypes = await DepositoType.insertMany(depositoTypes);
    console.log('Deposito types seeded successfully:', createdTypes);

    await mongoose.disconnect();
    console.log('Disconnected from MongoDB');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding deposito types:', error);
    process.exit(1);
  }
};

seedDepositoTypes();
