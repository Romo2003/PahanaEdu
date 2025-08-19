<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Customers</title>
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
    <h2>Manage Customers</h2>
    <!-- Add Customer Form -->
    <form onsubmit="event.preventDefault();addCustomer();">
        <label>Name:</label><input type="text" id="cname" required />
        <label>Phone:</label><input type="text" id="cphone" required />
        <button type="submit">Add Customer</button>
    </form>
    <div id="addResult"></div>
    <br />

    <!-- Edit Customer Form (hidden, shown only when editing) -->
    <div id="editForm">
        <h3>Edit Customer</h3>
        <input type="hidden" id="editId" />
        <label>Name:</label><input type="text" id="editName" required />
        <label>Phone:</label><input type="text" id="editPhone" required />
        <button onclick="editCustomer()">Update</button>
        <button onclick="hideEditForm()">Cancel</button>
        <div id="editResult"></div>
    </div>
    <br />

    <!-- Search Form -->
    <label>Search by Name or Phone:</label>
    <input type="text" id="searchTxt" />
    <button onclick="searchCustomers()">Search</button>
    <br /><br />

    <!-- Customers List Table -->
    <div id="customersList"></div>
</body>
</html>