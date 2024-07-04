const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const db = require("./db/connection.js");
const fs = require("fs");
const os = require("os");
const {
  createTasksCollection,
  getTasks,
  addTask,
  completeTask,
} = require("./db/db-logic.js");
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  // Get the hostname
  const hostname = os.hostname();

  // Read the HTML file
  let html = fs.readFileSync(path.join(__dirname, "index.html"), "utf8");

  // Replace the placeholder with the actual hostname
  html = html.replace(/{{hostname}}/g, hostname);

  // Send the modified HTML file
  res.send(html);
});

app.get("/client-side.js", (req, res) => {
  res.sendFile(path.join(__dirname, "./client/client-side.js"));
});

// Post route for adding a new task
app.post("/addtask", async function (req, res, next) {
  try {
    addTask(req, res, next);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error adding task");
  }
});

// Post route for removing a task
app.post("/completeTask", async function (req, res, next) {
  try {
    completeTask(req, res, next);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error completing task");
  }
});

// Get route for displaying tasks
app.get("/getTodo", function (req, res) {
  try {
    getTasks(req, res);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error retrieving tasks");
  }
});

// Set app to listen on port 3000

app.listen(3000, async function () {
  try {
    console.log("Server is running on port 3000");
  } catch (error) {
    console.error("Error starting server:", error);
  }
});
