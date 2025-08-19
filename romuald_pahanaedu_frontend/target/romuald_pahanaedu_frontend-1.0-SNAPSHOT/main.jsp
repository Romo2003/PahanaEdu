<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Pahanaedu Bookshop Main Page</title>
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
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .header {
            background-color: #854836;
            color: white;
            width: 100%;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h2 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .container {
            width: 80%;
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-top: 30px;
        }

        .menu-item {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .menu-item a {
            text-decoration: none;
            color: #000000;
            font-size: 1.2em;
            font-weight: bold;
            display: block;
            padding: 10px;
        }

        .menu-item:hover a {
            color: #FFB22C;
        }

        .logout-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #FFB22C;
            color: #000000;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .logout-btn:hover {
            background-color: #854836;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>Welcome to Pahanaedu Bookshop!</h2>
    </div>

    <form action="login.jsp" method="post">
        <button type="submit" class="logout-btn">Logout</button>
    </form>

    <div class="container">
        <div class="menu-grid">
            <div class="menu-item">
                <a href="manage_customers.jsp">
                    <i class="fas fa-users"></i>
                    Manage Customers
                </a>
            </div>
            <div class="menu-item">
                <a href="manage_items.jsp">
                    <i class="fas fa-box"></i>
                    Manage Items
                </a>
            </div>
            <div class="menu-item">
                <a href="place_order.jsp">
                    <i class="fas fa-shopping-cart"></i>
                    Place Order
                </a>
            </div>
            <div class="menu-item">
                <a href="help.jsp">
                    <i class="fas fa-question-circle"></i>
                    Help
                </a>
            </div>
        </div>
    </div>

    <!-- Add Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>