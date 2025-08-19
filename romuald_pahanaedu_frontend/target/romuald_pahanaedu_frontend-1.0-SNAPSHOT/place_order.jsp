<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Place Order</title>
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

        function addToCart(id, name, price) {
            var item = cart.find(i => i.id === id);
            if (item) {
                item.qty += 1;
            } else {
                cart.push({id:id, name:name, price:price, qty:1});
            }
            saveCart();
            displayCartBtn();
        }

        function saveCart() {
            sessionStorage.setItem("cart", JSON.stringify(cart));
            sessionStorage.setItem("customer", JSON.stringify(customer));
        }

        function displayCartBtn() {
            var totalQty = cart.reduce((sum, item) => sum + item.qty, 0);
            document.getElementById("cartBtn").style.display = "inline";
            document.getElementById("cartBtn").innerText = "Cart (" + totalQty + ")";
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

        function renderCart() {
            var container = document.getElementById("cartContent");
            if (cart.length === 0) {
                container.innerHTML = "<p>No items in cart.</p>";
                document.getElementById("checkoutBtn").style.display = "none";
                return;
            }
            var html = "<table border='1'><tr><th>Name</th><th>Price</th><th>Qty</th><th>Subtotal</th><th>Remove</th></tr>";
            var grandTotal = 0;
            for (var i = 0; i < cart.length; i++) {
                var subtotal = cart[i].qty * cart[i].price;
                grandTotal += subtotal;
                html += "<tr>";
                html += "<td>" + cart[i].name + "</td>";
                html += "<td>" + cart[i].price.toFixed(2) + "</td>";
                html += `<td><input type='number' min='1' value='${cart[i].qty}' onchange='updateQuantity(${i}, this.value)' style='width:50px;' /></td>`;
                html += "<td>" + subtotal.toFixed(2) + "</td>";
                html += `<td><button onclick='removeItem(${i})'>Remove</button></td>`;
                html += "</tr>";
            }
            html += `<tr><td colspan='3'><b>Total</b></td><td colspan='2'><b>${grandTotal.toFixed(2)}</b></td></tr>`;
            html += "</table>";
            container.innerHTML = html;
            document.getElementById("checkoutBtn").style.display = "block";
        }

        function checkout() {
            // Show summary/bill
            var billDiv = document.getElementById("billDiv");
            var html = "<h3>Order Summary</h3>";
            if (customer) {
                html += "<p><b>Customer Name:</b> " + customer.name + "<br/>";
                html += "<b>Phone:</b> " + customer.phone + "</p>";
            } else {
                html += "<p>No customer info.</p>";
            }
            html += "<table border='1'><tr><th>Name</th><th>Price</th><th>Qty</th><th>Subtotal</th></tr>";
            var grandTotal = 0;
            for (var i = 0; i < cart.length; i++) {
                var subtotal = cart[i].qty * cart[i].price;
                grandTotal += subtotal;
                html += "<tr><td>" + cart[i].name + "</td><td>" + cart[i].price.toFixed(2) + "</td><td>" + cart[i].qty + "</td><td>" + subtotal.toFixed(2) + "</td></tr>";
            }
            html += `<tr><td colspan='3'><b>Total</b></td><td><b>${grandTotal.toFixed(2)}</b></td></tr>`;
            html += "</table>";
            billDiv.innerHTML = html;
            billDiv.style.display = "block";
        }

        window.onload = function() {
            // Restore cart/customer from sessionStorage if needed
            var cartData = sessionStorage.getItem("cart");
            var custData = sessionStorage.getItem("customer");
            cart = cartData ? JSON.parse(cartData) : [];
            customer = custData ? JSON.parse(custData) : null;
            displayCartBtn();
        }
    </script>
    <style>
        #orderSection, #cartBtn, #cartDiv, #billDiv { display:none; }
        #cartDiv {
            position: fixed; top: 10%; left: 25%; width: 50%; background: #fff; padding: 20px; border: 2px solid #333; z-index:999;
        }
        #billDiv {
            position: fixed; top: 15%; left: 30%; width: 40%; background: #f7f7f7; padding: 20px; border: 2px solid #333; z-index:999;
        }
    </style>
</head>
<body>
    <h2>Place Order</h2>
    <div>
        <label>Customer Phone:</label>
        <input type="text" id="cphone" required />
        <button onclick="lookupCustomer()">Check</button>
        <div id="customerDisplay"></div>
        <div id="customerNameDiv" style="display:none;">
            <label>Customer Name:</label>
            <input type="text" id="cname" required />
        </div>
        <button id="startOrderBtn" onclick="startOrder()" style="display:none;">Start Order</button>
    </div>
    <br/>

    <!-- Items and Cart -->
    <div id="orderSection">
        <label>Search Item by Name:</label>
        <input type="text" id="searchTxt" />
        <button onclick="searchItems()">Search</button>
        <br/><br/>
        <div id="itemsList"></div>
        <button id="cartBtn" onclick="showCart()">Cart (0)</button>
    </div>

    <!-- Cart Modal -->
    <div id="cartDiv">
        <h3>Cart</h3>
        <div id="cartContent"></div>
        <button onclick="hideCart()">Close</button>
        <button id="checkoutBtn" onclick="checkout()" style="display:none;">Checkout</button>
    </div>

    <!-- Bill Modal -->
    <div id="billDiv"></div>
</body>
</html>