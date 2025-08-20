<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Help - Pahanaedu Bookshop</title>
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
            color: #333;
            line-height: 1.6;
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

        .section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .section:hover {
            transform: translateY(-2px);
        }

        h2 {
            color: white;
            font-size: 2em;
            margin-bottom: 10px;
        }

        h3 {
            color: #854836;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFB22C;
        }

        ul {
            list-style-type: none;
            padding-left: 0;
        }

        ul ul {
            padding-left: 20px;
            margin-top: 5px;
            margin-bottom: 10px;
        }

        li {
            margin-bottom: 12px;
            padding-left: 20px;
            position: relative;
        }

        li::before {
            content: "•";
            color: #FFB22C;
            font-size: 1.2em;
            position: absolute;
            left: 0;
        }

        b {
            color: #854836;
        }

        .contact {
            background: linear-gradient(135deg, #854836 0%, #FFB22C 100%);
            color: white;
            padding: 30px;
        }

        .contact h3 {
            color: white;
            border-bottom-color: white;
        }

        .contact a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .contact a:hover {
            text-decoration: underline;
        }

        .contact li::before {
            color: white;
        }

        .tips {
            background-color: #fff8e8;
            border-left: 4px solid #FFB22C;
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #854836;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background-color: #FFB22C;
            transform: translateY(-2px);
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

            .section {
                padding: 15px;
            }

            .header {
                margin-bottom: 20px;
            }

            .back-button {
                position: static;
                display: inline-block;
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <a href="main.jsp" class="back-button">← Back to Main</a>

    <div class="header">
        <h2>Help & Support</h2>
        
    </div>

    <div class="container">
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
                <li><b>Why isn't the subtotal updating?</b>
                    <br/>If your subtotal doesn't update, try refreshing the page or re-entering the quantity.
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

        <div class="section tips">
            <h3>Tips</h3>
            <ul>
                <li>Use the search boxes to quickly find customers or items.</li>
                <li>Double-check quantities in the cart before checkout.</li>
                <li>If you encounter any technical issues, contact support.</li>
            </ul>
        </div>
    </div>
</body>
</html>