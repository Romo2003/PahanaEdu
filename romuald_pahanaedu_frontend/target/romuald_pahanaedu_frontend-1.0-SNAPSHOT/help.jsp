<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Help - Pahanaedu Bookshop</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        h2 { color: #2a5d84; }
        ul { margin-top: 10px; }
        .section { margin-bottom: 25px; }
        .contact { background: #f7f7f7; border: 1px solid #ccc; padding: 10px; }
    </style>
</head>
<body>
    <h2>Help &amp; Support</h2>

    <div class="section">
        <h3>How to Use the System</h3>
        <ul>
            <li><b>Login:</b> Enter your username and password to access the bookshop system.</li>
            <li><b>Manage Customers:</b> Add, edit, delete, and search for customers using their name or phone number.</li>
            <li><b>Manage Items:</b> Add, edit, delete, and search for bookshop items by name and price.</li>
            <li><b>Place Order:</b>
                <ul>
                    <li>Enter customer's phone number. If registered, their name will be shown; if not, you can add their name.</li>
                    <li>Search and add items to the cart, adjust quantities, and proceed to checkout.</li>
                </ul>
            </li>
            <li><b>Cart:</b> View all added items, change quantities, remove items, and checkout to see a bill summary.</li>
        </ul>
    </div>

    <div class="section">
        <h3>Frequently Asked Questions</h3>
        <ul>
            <li><b>How do I edit or delete a customer/item?</b>
                <br/>Go to Manage Customers/Items page, use the Edit or Delete buttons next to each entry.
            </li>
            <li><b>How do I reset my cart?</b>
                <br/>Remove all items from the cart to empty it before checkout.
            </li>
            <li><b>Why isn’t the subtotal updating?</b>
                <br/>If your subtotal doesn’t update, try refreshing the page or re-entering the quantity.
            </li>
            <li><b>Can I place an order for a new customer?</b>
                <br/>Yes, simply enter the phone number and name when prompted during Place Order.
            </li>
        </ul>
    </div>

    <div class="section contact">
        <h3>Contact Support</h3>
        <ul>
            <li>Email: <a href="mailto:support@pahanaedu.com">support@pahanaedu.com</a></li>
            <li>Phone: 011-1234567</li>
            <li>Visit us: Pahanaedu Bookshop, Main Street, Your City</li>
        </ul>
    </div>

    <div class="section">
        <h3>Tips</h3>
        <ul>
            <li>Use the search boxes to quickly find customers or items.</li>
            <li>Double-check quantities in the cart before checkout.</li>
            <li>If you encounter any technical issues, contact support.</li>
        </ul>
    </div>
</body>
</html>