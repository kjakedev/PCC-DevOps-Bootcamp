var dataArray = [];
var oldRawData

displayTodo();

const displayTodoItems = $("#displayTodoItems");
const displayCompleteItems = $("#displayCompleteItems");

function displayTodo() {
    fetch('/', { method: "get" }).then((response) => {
        return response.json();
    }).then((data) => {
        dataArray = data;
        console.log(data);
        displayItems(data);
    });
}


function displayItems(data) {
    let htmlContent = ''
    data.forEach((item) => {
        console.log(item)
        htmlContent = `<li><input type="checkbox" name="check" value=${item.id} /> ${item.task} </li>`
        if (item.status == 'pending'){
            displayfromDB.append(htmlAppend(htmlContent));
        } else {
            displayCompleteItems.append(htmlAppend(htmlContent));
        }
    });
}

$('#addTask').addEventListener('click', function () {
    const newItem = $("#newItem").value
    const response = fetch('/addTask', {
        method: "POST", 
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(newItem),
      });
      return response.json();
    }
);

$('#completeItems').addEventListener('click', function () {
    const itemsToComplete = $('#displayCompleteItems input[type="checkbox"]:checked')
    const response = fetch('/completeTask', {
        method: "POST", 
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(itemsToComplete),
      });
      return response.json();
    }
);