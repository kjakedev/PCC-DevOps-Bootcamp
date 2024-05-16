var dataArray = [];

displayTodo();

const displayTodoItems = $("#displayTodoItems");
const displayCompleteItems = $("#displayCompleteItems");

function displayTodo() {
    fetch('/getTodo', { method: "get" }).then(function (response) {
        return response.json();
    }).then(function (data) {
        dataArray = data;
        displayItems(data);
    });
}


function displayItems(data) {
    let htmlContent = ''
    displayTodoItems.html('');
    displayCompleteItems.html('');
    data.forEach(function (item) {
        htmlContent = `<li><input type="checkbox" name="check" value=${item.id} /> ${item.task} </li>`
        if (item.status == 'pending'){
            displayTodoItems.append(htmlContent);
        } else {
            displayCompleteItems.append(htmlContent);
        }
    });
}

$('#addTask').on('click', function () {
    const newItem = $("#newItem").val()
    fetch('/addTask', {
        method: "POST", 
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({newItem}),
      });
      displayTodo()
    }
);

$('#completeItems').on('click', function () {
    const itemsToComplete = $('#displayTodoItems input[type="checkbox"]:checked').map(function() {
        return $(this).val();
      }).get();
     fetch('/completeTask', {
        method: "POST", 
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(itemsToComplete),
      });
      displayTodo()
    }
    
);