<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Items</title>
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
    <style>
        #editForm {
            display: none;
            background: #eee;
            padding: 10px;
            border: 1px solid #aaa;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h2>Manage Items</h2>
    <!-- Add Item Form -->
    <form onsubmit="event.preventDefault();addItem();">
        <label>Name:</label><input type="text" id="iname" required />
        <label>Price:</label><input type="number" id="iprice" step="0.01" min="0" required />
        <button type="submit">Add Item</button>
    </form>
    <div id="addResult"></div>
    <br />

    <!-- Edit Item Form -->
    <div id="editForm">
        <h3>Edit Item</h3>
        <input type="hidden" id="editId" />
        <label>Name:</label><input type="text" id="editName" required />
        <label>Price:</label><input type="number" id="editPrice" step="0.01" min="0" required />
        <button onclick="editItem()">Update</button>
        <button onclick="hideEditForm()">Cancel</button>
        <div id="editResult"></div>
    </div>
    <br />

    <!-- Search Form -->
    <label>Search by Name:</label>
    <input type="text" id="searchTxt" />
    <button onclick="searchItems()">Search</button>
    <br /><br />

    <!-- Items List Table -->
    <div id="itemsList"></div>
</body>
</html>