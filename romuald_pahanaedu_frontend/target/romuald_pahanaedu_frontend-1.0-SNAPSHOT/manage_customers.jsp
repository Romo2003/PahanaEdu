<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Customers</title>
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
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h2, h3 {
            color: #854836;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        label {
            color: #854836;
            font-weight: bold;
            min-width: 100px;
        }

        input[type="text"] {
            padding: 10px;
            border: 2px solid #FFB22C;
            border-radius: 5px;
            width: 200px;
            outline: none;
            transition: all 0.3s ease;
        }

        input[type="text"]:focus {
            border-color: #854836;
            box-shadow: 0 0 5px rgba(133, 72, 54, 0.3);
        }

        button {
            background-color: #FFB22C;
            color: #000000;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
            margin: 5px;
        }

        button:hover {
            background-color: #854836;
            color: white;
            transform: translateY(-2px);
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
            padding: 15px;
            text-align: left;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .edit-form {
            display: none;
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .success-message {
            color: #28a745;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }

        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
        }

        .delete-btn:hover {
            background-color: #c82333;
        }

        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #854836;
            color: white;
            text-decoration: none;
            z-index: 100;
        }

        .user-info {
            position: absolute;
            top: 10px;
            right: 10px;
            color: white;
            font-size: 0.9em;
            text-align: right;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .form-group {
                flex-direction: column;
                align-items: stretch;
            }

            input[type="text"] {
                width: 100%;
            }

            .back-button {
                position: static;
                display: inline-block;
                margin-bottom: 20px;
            }
        }
    </style>

    <!-- Keep your existing JavaScript -->
    <script>
        function addCustomer() {
            var name = document.getElementById("cname").value;
            var phone = document.getElementById("cphone").value;
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "http://localhost:8080/romuald_pahanaedu_backend/webresources/customers", true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "success") {
                        loadCustomers();
                        document.getElementById("cname").value = "";
                        document.getElementById("cphone").value = "";
                        document.getElementById("addResult").innerHTML = "<span style='color:green'>Customer added!</span>";
                    } else {
                        document.getElementById("addResult").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send(JSON.stringify({ name: name, phone: phone }));
        }

        function loadCustomers(search = "") {
            var url = "http://localhost:8080/romuald_pahanaedu_backend/webresources/customers";
            if (search) url += "?search=" + encodeURIComponent(search);
            var xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    var container = document.getElementById("customersList");
                    if (resp.status === "success") {
                        var arr = resp.customers;
                        var html = "<table border='1'><tr><th>ID</th><th>Name</th><th>Phone</th><th>Actions</th></tr>";
                        for (var i = 0; i < arr.length; i++) {
                            html += "<tr>";
                            html += "<td>" + arr[i].id + "</td>";
                            html += "<td id='name_" + arr[i].id + "'>" + arr[i].name + "</td>";
                            html += "<td id='phone_" + arr[i].id + "'>" + arr[i].phone + "</td>";
                            html += "<td>";
                            html += "<button onclick='showEditForm(" + arr[i].id + ")'>Edit</button> ";
                            html += "<button onclick='deleteCustomer(" + arr[i].id + ")'>Delete</button>";
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

        function searchCustomers() {
            var search = document.getElementById("searchTxt").value;
            loadCustomers(search);
        }

        function showEditForm(id) {
            var name = document.getElementById("name_" + id).innerText;
            var phone = document.getElementById("phone_" + id).innerText;
            document.getElementById("editId").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editPhone").value = phone;
            document.getElementById("editForm").style.display = "block";
        }

        function hideEditForm() {
            document.getElementById("editForm").style.display = "none";
        }

        function editCustomer() {
            var id = document.getElementById("editId").value;
            var name = document.getElementById("editName").value;
            var phone = document.getElementById("editPhone").value;
            var xhr = new XMLHttpRequest();
            xhr.open("PUT", "http://localhost:8080/romuald_pahanaedu_backend/webresources/customers/" + id, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "success") {
                        loadCustomers();
                        hideEditForm();
                        document.getElementById("editResult").innerHTML = "<span style='color:green'>Customer updated!</span>";
                    } else {
                        document.getElementById("editResult").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send(JSON.stringify({ name: name, phone: phone }));
        }

        function deleteCustomer(id) {
            if (!confirm("Are you sure you want to delete this customer?")) return;
            var xhr = new XMLHttpRequest();
            xhr.open("DELETE", "http://localhost:8080/romuald_pahanaedu_backend/webresources/customers/" + id, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "success") {
                        loadCustomers();
                        document.getElementById("addResult").innerHTML = "<span style='color:green'>Customer deleted!</span>";
                    } else {
                        document.getElementById("addResult").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send();
        }

        window.onload = function() {
            loadCustomers();
        }
    </script>
</head>
<body>
    <a href="main.jsp" class="back-button">← Back to Main</a>

    <div class="header">
        <h2>Manage Customers</h2>
       
    </div>

    <div class="container">
        <!-- Add Customer Form -->
        <div class="card">
            <h3>Add New Customer</h3>
            <form onsubmit="event.preventDefault();addCustomer();">
                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" id="cname" required placeholder="Enter customer name" />
                </div>
                <div class="form-group">
                    <label>Phone:</label>
                    <input type="text" id="cphone" required placeholder="Enter phone number" />
                </div>
                <button type="submit">Add Customer</button>
            </form>
            <div id="addResult"></div>
        </div>

        <!-- Edit Customer Form -->
        <div id="editForm" class="edit-form">
            <h3>Edit Customer</h3>
            <input type="hidden" id="editId" />
            <div class="form-group">
                <label>Name:</label>
                <input type="text" id="editName" required />
            </div>
            <div class="form-group">
                <label>Phone:</label>
                <input type="text" id="editPhone" required />
            </div>
            <button onclick="editCustomer()">Update</button>
            <button onclick="hideEditForm()">Cancel</button>
            <div id="editResult"></div>
        </div>

        <!-- Search Box -->
        <div class="search-box">
            <div class="form-group">
                <label>Search:</label>
                <input type="text" id="searchTxt" placeholder="Search by name or phone" />
                <button onclick="searchCustomers()">Search</button>
            </div>
        </div>

        <!-- Customers List -->
        <div class="card">
            <div id="customersList"></div>
        </div>
    </div>

    <script>
        // Add this to enhance the message display
        function showMessage(elementId, message, isError = false) {
            document.getElementById(elementId).innerHTML = 
                `<div class="${isError ? 'error-message' : 'success-message'}">${message}</div>`;
        }

        // Modify your existing loadCustomers function to use better styling
        const originalLoadCustomers = window.loadCustomers;
        window.loadCustomers = function(search = "") {
            var url = "http://localhost:8080/romuald_pahanaedu_backend/webresources/customers";
            if (search) url += "?search=" + encodeURIComponent(search);
            var xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    var container = document.getElementById("customersList");
                    if (resp.status === "success") {
                        var arr = resp.customers;
                        var html = "<table><tr><th>ID</th><th>Name</th><th>Phone</th><th>Actions</th></tr>";
                        for (var i = 0; i < arr.length; i++) {
                            html += "<tr>";
                            html += "<td>" + arr[i].id + "</td>";
                            html += "<td id='name_" + arr[i].id + "'>" + arr[i].name + "</td>";
                            html += "<td id='phone_" + arr[i].id + "'>" + arr[i].phone + "</td>";
                            html += "<td>";
                            html += "<button onclick='showEditForm(" + arr[i].id + ")'>Edit</button> ";
                            html += "<button class='delete-btn' onclick='deleteCustomer(" + arr[i].id + ")'>Delete</button>";
                            html += "</td>";
                            html += "</tr>";
                        }
                        html += "</table>";
                        container.innerHTML = html;
                    } else {
                        showMessage("customersList", resp.message, true);
                    }
                }
            };
            xhr.send();
        }
    </script>
</body>
</html>