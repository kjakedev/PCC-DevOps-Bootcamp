const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const db = require("./db/connection.js");
const {createTasksTable, getTasks, addTask, completeTask} = require("./db/db-logic.js");
const app = express();


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/client-side.js", (req, res) => {
  res.sendFile(path.join(__dirname, "./client/client-side.js"));
});

// Post route for adding a new task
app.post("/addtask", async function(req, res) {
  const newTask = req.body.newItem;
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
  const tasks = req.body;
  try {
    if (typeof tasks === "string") {
      await completeTask(tasks); // assuming task id is stored in the database
    } else if (Array.isArray(tasks)) {
      for (const taskId of tasks) {
        await completeTask(taskId); // assuming task id is stored in the database
      }
    }
    res.redirect("/");
  } catch (error) {
    console.error(error);
    res.status(500).send('Error completing task');
  }
});

// Get route for displaying tasks
app.get("/getTodo", async function(req, res) {
  try {
    const tasks = await getTasks();
    res.json(tasks)
  } catch (error) {
    console.error(error);
    res.status(500).send('Error retrieving tasks');
  }
});

// Set app to listen on port 3000
app.listen(3000, async function() {
  try {
    // await db.query('DROP TABLE tasks');
    // await createTasksTable();
    console.log("Server is running on port 3000");
  } catch (error) {
    console.error('Error starting server:', error);
  }
});