require("dotenv").config();
const MongoClient = require("mongodb").MongoClient;

// Location of where our mongoDB database is located (use process.env)
const url = `mongodb://${process.env.DB_URL}/${process.env.DB_NAME}?retryWrites=true&w=majority`;

// Options for mongoDB
const mongoOptions = {
  useNewUrlParser: true,
  useUnifiedTopology: true,
};

const state = {
  db: null,
};

const connect = (cb) => {
  // if state is not NULL
  // Means we have connection already, call our CB
  if (state.db) cb();
  else {
    // attempt to get database connection
    MongoClient.connect(url, mongoOptions, (err, client) => {
      // unable to get database connection pass error to CB
      if (err) cb(err);
      // Successfully got our database connection
      // Set database connection and call CB
      else {
        state.db = client.db(process.env.DB_NAME);
        cb();
      }
    });
  }
};


// Returns database connection
const getDB = () => {
  return state.db;
};




module.exports = { getDB, connect };
