const express = require("express");
const bodyParser = require("body-parser");
const mysql = require('mysql');
const app = express();
const util = require('util');
require('dotenv').config();

app.use(bodyParser.urlencoded({ extended: true }));
app.set("view engine", "ejs");
app.use(express.static("public"));

// MySQL connection pool configuration
const pool = mysql.createPool({
  connectionLimit: 10,
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

// Promisify the pool.query method for easier async/await usage
pool.query = util.promisify(pool.query).bind(pool);

// Function to create the tasks table (if not exists)
async function createTasksTable() {
  try {
    const sql = `CREATE TABLE IF NOT EXISTS tasks (
      id INT AUTO_INCREMENT PRIMARY KEY,
      task VARCHAR(255) NOT NULL,
      status VARCHAR(255) NOT NULL
    )`;
    await pool.query(sql);
    console.log('Tasks table created (if not exists)');

    // Insert dummy data (optional)
    await insertDummyData();
  } catch (error) {
    console.error('Error creating tasks table:', error);
  }
}

// Function to insert dummy data (optional)
async function insertDummyData() {
  const tasks = [
    'Learn Node.js basics',
    'Build a simple web application',
    'Connect to a database'
  ];

  for (const task of tasks) {
    await pool.query('INSERT INTO tasks (task, status) VALUES (?, ?)', [task, 'pending']);
    console.log(`Task "${task}" inserted`);
  }
}

// Function to retrieve tasks from database
async function getTasks() {
  try {
    const rows = await pool.query('SELECT * FROM tasks');
    return rows;
  } catch (error) {
    console.error('Error retrieving tasks:', error);
    throw error;
  }
}

// Function to add a task to the database
async function addTask(newTask) {
  try {
    await pool.query('INSERT INTO tasks (task, status) VALUES (?, ?)', [newTask, 'pending']);
  } catch (error) {
    console.error('Error adding task:', error);
    throw error;
  }
}

// Function to remove a task from the database
async function completeTask(taskId) {
  try {
    await pool.query('UPDATE tasks SET status = "complete" WHERE id = ?', [taskId]);
  } catch (error) {
    console.error('Error removing task:', error);
    throw error;
  }
}

// Post route for adding a new task
app.post("/addtask", async function(req, res) {
  const newTask = req.body.newtask;
  try {
    await addTask(newTask);
    res.redirect("/");
  } catch (error) {
    console.error(error);
    res.status(500).send('Error adding task');
  }
});

// Post route for removing a task
app.post("/completeTask", async function(req, res) {
  const tasks = req.body.check;
  console.log(req.body.check)
  try {
    if (typeof tasks === "string") {
      await completeTask(tasks); // assuming task id is stored in the database
    } else if (Array.isArray(tasks)) {
      for (const taskId of completeTask) {
        await completeTask(taskId); // assuming task id is stored in the database
      }
    }
    res.redirect("/");
  } catch (error) {
    console.error(error);
    res.status(500).send('Error removing task');
  }
});

// Get route for displaying tasks
app.get("/", async function(req, res) {
  try {
    const tasks = await getTasks();
    console.log(tasks)
    res.render("index", { task: tasks});
  } catch (error) {
    console.error(error);
    res.status(500).send('Error retrieving tasks');
  }
});

// Set app to listen on port 3000
app.listen(3000, async function() {
  try {
    await pool.query('DROP TABLE tasks');
    await createTasksTable();
    console.log("Server is running on port 3000");
  } catch (error) {
    console.error('Error starting server:', error);
  }
});
