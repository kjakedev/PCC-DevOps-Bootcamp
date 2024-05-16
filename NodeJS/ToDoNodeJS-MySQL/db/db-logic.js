const db = require("./connection.js");

// Function to create the tasks table (if not exists)
async function createTasksTable() {
    try {
      const sql = `CREATE TABLE IF NOT EXISTS tasks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        task VARCHAR(255) NOT NULL,
        status VARCHAR(255) NOT NULL
      )`;
      await db.query(sql);
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
      await db.query('INSERT INTO tasks (task, status) VALUES (?, ?)', [task, 'pending']);
      console.log(`Task "${task}" inserted`);
    }
  }
  
  // Function to retrieve tasks from database
  async function getTasks() {
    try {
      const rows = await db.query('SELECT * FROM tasks');
      return rows;
    } catch (error) {
      console.error('Error retrieving tasks:', error);
      throw error;
    }
  }
  
  // Function to add a task to the database
  async function addTask(newTask) {
    try {
      await db.query('INSERT INTO tasks (task, status) VALUES (?, ?)', [newTask, 'pending']);
    } catch (error) {
      console.error('Error adding task:', error);
      throw error;
    }
  }
  
  // Function to remove a task from the database
  async function completeTask(taskId) {
    try {
      await db.query('UPDATE tasks SET status = "complete" WHERE id = ?', [taskId]);
    } catch (error) {
      console.error('Error removing task:', error);
      throw error;
    }
  }

  module.exports = { createTasksTable, getTasks, addTask, completeTask  };