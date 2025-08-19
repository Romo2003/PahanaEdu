<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Cart</title>
    <script>
        var cart = [];
        var customer = null;

        // Load cart and customer from sessionStorage for demo
        function loadCartFromStorage() {
            var cartData = sessionStorage.getItem("cart");
            var custData = sessionStorage.getItem("customer");
            cart = cartData ? JSON.parse(cartData) : [];
            customer = custData ? JSON.parse(custData) : null;
        }

        function saveCartToStorage() {
            sessionStorage.setItem("cart", JSON.stringify(cart));
        }

        function updateQuantity(idx, inputElem) {
            var newQty = parseInt(inputElem.value);
            if (isNaN(newQty) || newQty < 1) newQty = 1;
            cart[idx].qty = newQty;
            saveCartToStorage();
            renderCart();
        }

        function removeItem(idx) {
            cart.splice(idx, 1);
            saveCartToStorage();
            renderCart();
        }

        function renderCart() {
            var container = document.getElementById("cartList");
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
                html += `<td><input type='number' min='1' value='${cart[i].qty}' onchange='updateQuantity(${i}, this)' style='width:50px;' /></td>`;
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
            loadCartFromStorage();
            renderCart();
        }
    </script>
    <style>
        #billDiv { display:none; background: #f7f7f7; padding: 20px; border: 2px solid #333; margin-top: 20px; }
    </style>
</head>
<body>
    <h2>Cart</h2>
    <div id="cartList"></div>
    <button id="checkoutBtn" onclick="checkout()" style="display:none;">Checkout</button>
    <div id="billDiv"></div>
</body>
</html>