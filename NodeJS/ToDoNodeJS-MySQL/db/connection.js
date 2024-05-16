const mysql = require('mysql');
const util = require('util');
require('dotenv').config();


const db = mysql.createPool({
    connectionLimit: 10,
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

// Promisify the pool.query method for easier async/await usage
db.query = util.promisify(db.query).bind(db);

module.exports = db