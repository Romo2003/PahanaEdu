<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Place Order</title>
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

        .input-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        label {
            color: #854836;
            font-weight: bold;
            min-width: 120px;
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

        #cartBtn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #854836;
            color: white;
            padding: 15px 25px;
            border-radius: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 100;
        }

        #cartBtn:hover {
            transform: scale(1.05);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal-content {
            position: relative;
            background-color: #F7F7F7;
            margin: 5% auto;
            padding: 30px;
            width: 70%;
            max-width: 800px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .close-btn {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 24px;
            cursor: pointer;
            background: none;
            border: none;
            color: #854836;
        }

        .user-info {
            position: absolute;
            top: 10px;
            right: 10px;
            color: white;
            font-size: 0.9em;
            text-align: right;
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #854836;
            color: white;
            z-index: 100;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .input-group {
                flex-direction: column;
                align-items: stretch;
            }
            
            input[type="text"] {
                width: 100%;
            }
            
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
        }
    </style>

    <script>
        var cart = [];
        var customer = null;

        function lookupCustomer() {
            var phone = document.getElementById("cphone").value;
            if (!phone) return;
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "http://localhost:8080/romuald_pahanaedu_backend/webresources/customers/byphone?phone=" + encodeURIComponent(phone), true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.status === "found") {
                        customer = resp.customer;
                        document.getElementById("customerDisplay").innerHTML = "Customer: <b>" + customer.name + "</b>";
                        document.getElementById("customerNameDiv").style.display = "none";
                        document.getElementById("startOrderBtn").style.display = "block";
                    } else if (resp.status === "notfound") {
                        customer = null;
                        document.getElementById("customerDisplay").innerHTML = "Customer not found. Please enter name:";
                        document.getElementById("customerNameDiv").style.display = "block";
                        document.getElementById("startOrderBtn").style.display = "block";
                    } else {
                        document.getElementById("customerDisplay").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                        document.getElementById("customerNameDiv").style.display = "none";
                        document.getElementById("startOrderBtn").style.display = "none";
                    }
                }
            };
            xhr.send();
        }

        function startOrder() {
            var phone = document.getElementById("cphone").value;
            if (!customer) {
                var name = document.getElementById("cname").value;
                if (!name) {
                    alert("Please enter customer name.");
                    return;
                }
                customer = {name:name, phone:phone}; // not yet in DB
            }
            document.getElementById("orderSection").style.display = "block";
            loadItems();
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
                        var html = "<table border='1'><tr><th>Name</th><th>Price</th><th>Action</th></tr>";
                        for (var i = 0; i < arr.length; i++) {
                            html += "<tr>";
                            html += "<td>" + arr[i].name + "</td>";
                            html += "<td>" + arr[i].price.toFixed(2) + "</td>";
                            html += "<td><button onclick='addToCart(" + arr[i].id + ",\"" + arr[i].name + "\"," + arr[i].price + ")'>Add to Cart</button></td>";
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

        function saveCart() {
            sessionStorage.setItem("cart", JSON.stringify(cart));
            sessionStorage.setItem("customer", JSON.stringify(customer));
        }

        function showCart() {
            renderCart();
            document.getElementById("cartDiv").style.display = "block";
        }

        function hideCart() {
            document.getElementById("cartDiv").style.display = "none";
        }

        function updateQuantity(idx, newQty) {
            newQty = parseInt(newQty);
            if (isNaN(newQty) || newQty < 1) newQty = 1;
            cart[idx].qty = newQty;
            saveCart();
            renderCart();
        }

        function removeItem(idx) {
            cart.splice(idx, 1);
            saveCart();
            renderCart();
            displayCartBtn();
        }

        function addToCart(id, name, price) {
            cart.push({id:id, name:name, price:price});
            saveCart();
            displayCartBtn();
        }

        function displayCartBtn() {
            document.getElementById("cartBtn").style.display = "inline";
            document.getElementById("cartBtn").innerText = "Cart (" + cart.length + ")";
        }

        // Renders the cart without total or subtotal
        function renderCart() {
            var container = document.getElementById("cartContent");
            if (cart.length === 0) {
                container.innerHTML = "<p>No items in cart.</p>";
                document.getElementById("checkoutBtn").style.display = "none";
                return;
            }
            var html = "<table><tr><th>Item</th><th>Price</th><th>Action</th></tr>";
            for (var i = 0; i < cart.length; i++) {
                html += "<tr>";
                html += "<td>" + cart[i].name + "</td>";
                html += "<td>" + cart[i].price.toFixed(2) + "</td>";
                html += `<td><button onclick='removeItem(${i})'>Remove</button></td>`;
                html += "</tr>";
            }
            html += "</table>";
            container.innerHTML = html;
            document.getElementById("checkoutBtn").style.display = "block";
        }

        // Shows receipt without total, subtotal, only item list and customer details
        function checkout() {
            var billDiv = document.getElementById("billDiv");
            var html = "<div class='modal-content'>";
            html += "<h3>Order Receipt</h3>";
            if (customer) {
                html += "<div class='customer-info card'>";
                html += "<p><b>Customer Name:</b> " + customer.name + "<br/>";
                html += "<b>Phone:</b> " + customer.phone + "</p>";
                html += "</div>";
            }
            html += "<table><tr><th>Item</th><th>Price</th></tr>";
            for (var i = 0; i < cart.length; i++) {
                html += "<tr>";
                html += "<td>" + cart[i].name + "</td>";
                html += "<td>" + cart[i].price.toFixed(2) + "</td>";
                html += "</tr>";
            }
            html += "</table>";
            html += "<button onclick='window.print()' style='margin-top: 20px;'>Print Receipt</button>";
            html += "</div>";
            billDiv.innerHTML = html;
            billDiv.style.display = "block";
        }
    </script>
</head>
<body>
    <a href="main.jsp" class="back-button">← Back to Main</a>

    <div class="header">
        <h2>Place Order</h2>
    </div>

    <div class="container">
        <div class="card">
            <h3>Customer Information</h3>
            <div class="input-group">
                <label>Customer Phone:</label>
                <input type="text" id="cphone" required placeholder="Enter phone number" />
                <button onclick="lookupCustomer()">Check</button>
            </div>
            <div id="customerDisplay"></div>
            <div id="customerNameDiv" style="display:none;">
                <div class="input-group">
                    <label>Customer Name:</label>
                    <input type="text" id="cname" required placeholder="Enter customer name" />
                </div>
            </div>
            <button id="startOrderBtn" onclick="startOrder()" style="display:none;">Start Order</button>
        </div>

        <div id="orderSection">
            <div class="card">
                <div class="input-group">
                    <label>Search Items:</label>
                    <input type="text" id="searchTxt" placeholder="Search by item name" />
                    <button onclick="searchItems()">Search</button>
                </div>
                <div id="itemsList"></div>
            </div>
        </div>

        <button id="cartBtn" onclick="showCart()">Cart (0)</button>

        <div id="cartDiv" class="modal">
            <div class="modal-content">
                <button class="close-btn" onclick="hideCart()">&times;</button>
                <h3>Shopping Cart</h3>
                <div id="cartContent"></div>
                <div style="margin-top: 20px;">
                    <button onclick="hideCart()">Continue Shopping</button>
                    <button id="checkoutBtn" onclick="checkout()" style="display:none;">Proceed to Checkout</button>
                </div>
            </div>
        </div>

        <div id="billDiv" class="modal"></div>
    </div>
</body>
</html>


