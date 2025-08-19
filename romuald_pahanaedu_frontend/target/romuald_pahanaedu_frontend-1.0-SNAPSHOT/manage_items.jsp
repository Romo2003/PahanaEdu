<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Items</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background-color: #F7F7F7;
            min-height: 100vh;
            padding: 20px;
        }

        .header {
            background-color: #854836;
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: relative;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
            padding: 20px;
            background: white;
            border-radius: 10px;
        }

        .input-group {
            margin-bottom: 15px;
        }

        label {
            display: inline-block;
            width: 100px;
            margin-right: 10px;
            font-weight: bold;
            color: #854836;
        }

        input[type="text"],
        input[type="number"] {
            padding: 8px 12px;
            border: 2px solid #FFB22C;
            border-radius: 5px;
            width: 200px;
            margin-right: 10px;
            outline: none;
        }

        input[type="text"]:focus,
        input[type="number"]:focus {
            border-color: #854836;
            box-shadow: 0 0 5px rgba(133, 72, 54, 0.3);
        }

        button {
            background-color: #FFB22C;
            color: #000000;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        button:hover {
            background-color: #854836;
            color: white;
            transform: translateY(-2px);
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
        }

        .delete-btn:hover {
            background-color: #c82333;
        }

        #editForm {
            display: none;
            background: #F7F7F7;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border: 2px solid #FFB22C;
        }

        #itemsList {
            margin-top: 20px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
        }

        th {
            background-color: #854836;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .search-box {
            margin: 20px 0;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
        }

        .success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }

        .error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }

        .button-group {
            display: flex;
            gap: 10px;
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #854836;
            color: white;
        }

        .user-info {
            position: absolute;
            top: 10px;
            right: 10px;
            color: white;
            font-size: 0.9em;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            input[type="text"],
            input[type="number"] {
                width: 100%;
                margin-bottom: 10px;
            }

            label {
                display: block;
                margin-bottom: 5px;
            }
        }
    </style>
    <!-- Keep your existing script section here -->
  <script>
        function addItem() {
            var name = document.getElementById("iname").value;
            var price = document.getElementById("iprice").value;
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "http://localhost:8080/romuald_pahanaedu_backend/webresources/items", true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "success") {
                        loadItems();
                        document.getElementById("iname").value = "";
                        document.getElementById("iprice").value = "";
                        document.getElementById("addResult").innerHTML = "<span style='color:green'>Item added!</span>";
                    } else {
                        document.getElementById("addResult").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send(JSON.stringify({ name: name, price: parseFloat(price) }));
        }

        function loadItems(search = "") {
            var url = "http://localhost:8080/romuald_pahanaedu_backend/webresources/items";
            if (search) url += "?search=" + encodeURIComponent(search);
            var xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    var container = document.getElementById("itemsList");
                    if (resp.status === "success") {
                        var arr = resp.items;
                        var html = "<table border='1'><tr><th>ID</th><th>Name</th><th>Price</th><th>Actions</th></tr>";
                        for (var i = 0; i < arr.length; i++) {
                            html += "<tr>";
                            html += "<td>" + arr[i].id + "</td>";
                            html += "<td id='iname_" + arr[i].id + "'>" + arr[i].name + "</td>";
                            html += "<td id='iprice_" + arr[i].id + "'>" + arr[i].price.toFixed(2) + "</td>";
                            html += "<td>";
                            html += "<button onclick='showEditForm(" + arr[i].id + ")'>Edit</button> ";
                            html += "<button onclick='deleteItem(" + arr[i].id + ")'>Delete</button>";
                            html += "</td>";
                            html += "</tr>";
                        }
                        html += "</table>";
                        container.innerHTML = html;
                    } else {
                        container.innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send();
        }

        function searchItems() {
            var search = document.getElementById("searchTxt").value;
            loadItems(search);
        }

        function showEditForm(id) {
            var name = document.getElementById("iname_" + id).innerText;
            var price = document.getElementById("iprice_" + id).innerText;
            document.getElementById("editId").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editPrice").value = price;
            document.getElementById("editForm").style.display = "block";
        }

        function hideEditForm() {
            document.getElementById("editForm").style.display = "none";
        }

        function editItem() {
            var id = document.getElementById("editId").value;
            var name = document.getElementById("editName").value;
            var price = document.getElementById("editPrice").value;
            var xhr = new XMLHttpRequest();
            xhr.open("PUT", "http://localhost:8080/romuald_pahanaedu_backend/webresources/items/" + id, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "success") {
                        loadItems();
                        hideEditForm();
                        document.getElementById("editResult").innerHTML = "<span style='color:green'>Item updated!</span>";
                    } else {
                        document.getElementById("editResult").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send(JSON.stringify({ name: name, price: parseFloat(price) }));
        }

        function deleteItem(id) {
            if (!confirm("Are you sure you want to delete this item?")) return;
            var xhr = new XMLHttpRequest();
            xhr.open("DELETE", "http://localhost:8080/romuald_pahanaedu_backend/webresources/items/" + id, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "success") {
                        loadItems();
                        document.getElementById("addResult").innerHTML = "<span style='color:green'>Item deleted!</span>";
                    } else {
                        document.getElementById("addResult").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send();
        }

        window.onload = function() {
            loadItems();
        }
    </script>
</head>
<body>
    <a href="main.jsp" class="back-button button">← Back to Main</a>
    
    <div class="header">
        <h2>Manage Items</h2>
        
    </div>

    <div class="container">
        <!-- Add Item Form -->
        <div class="form-group">
            <h3>Add New Item</h3>
            <form onsubmit="event.preventDefault();addItem();">
                <div class="input-group">
                    <label>Name:</label>
                    <input type="text" id="iname" required placeholder="Enter item name" />
                </div>
                <div class="input-group">
                    <label>Price:</label>
                    <input type="number" id="iprice" step="0.01" min="0" required placeholder="Enter price" />
                </div>
                <button type="submit">Add Item</button>
            </form>
            <div id="addResult"></div>
        </div>

        <!-- Edit Item Form -->
        <div id="editForm">
            <h3>Edit Item</h3>
            <input type="hidden" id="editId" />
            <div class="input-group">
                <label>Name:</label>
                <input type="text" id="editName" required />
            </div>
            <div class="input-group">
                <label>Price:</label>
                <input type="number" id="editPrice" step="0.01" min="0" required />
            </div>
            <div class="button-group">
                <button onclick="editItem()">Update</button>
                <button onclick="hideEditForm()">Cancel</button>
            </div>
            <div id="editResult"></div>
        </div>

        <!-- Search Box -->
        <div class="search-box">
            <label>Search:</label>
            <input type="text" id="searchTxt" placeholder="Search by item name..." />
            <button onclick="searchItems()">Search</button>
        </div>

        <!-- Items List Table -->
        <div id="itemsList"></div>
    </div>

    <!-- Modify the loadItems function to add classes to buttons -->
    <script>
        const originalLoadItems = window.loadItems;
        window.loadItems = function(search = "") {
            var url = "http://localhost:8080/romuald_pahanaedu_backend/webresources/items";
            if (search) url += "?search=" + encodeURIComponent(search);
            var xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    var container = document.getElementById("itemsList");
                    if (resp.status === "success") {
                        var arr = resp.items;
                        var html = "<table><tr><th>ID</th><th>Name</th><th>Price</th><th>Actions</th></tr>";
                        for (var i = 0; i < arr.length; i++) {
                            html += "<tr>";
                            html += "<td>" + arr[i].id + "</td>";
                            html += "<td id='iname_" + arr[i].id + "'>" + arr[i].name + "</td>";
                            html += "<td id='iprice_" + arr[i].id + "'>" + arr[i].price.toFixed(2) + "</td>";
                            html += "<td class='button-group'>";
                            html += "<button onclick='showEditForm(" + arr[i].id + ")'>Edit</button> ";
                            html += "<button class='delete-btn' onclick='deleteItem(" + arr[i].id + ")'>Delete</button>";
                            html += "</td>";
                            html += "</tr>";
                        }
                        html += "</table>";
                        container.innerHTML = html;
                    } else {
                        container.innerHTML = "<div class='error'>" + resp.message + "</div>";
                    }
                }
            };
            xhr.send();
        };
    </script>
</body>
</html>