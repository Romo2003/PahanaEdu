<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Pahanaedu Bookshop Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #854836 0%, #FFB22C 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
            position: relative;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        h2 {
            color: #854836;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2em;
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        label {
            display: block;
            color: #854836;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #FFB22C;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
            outline: none;
        }

        input:focus {
            border-color: #854836;
            box-shadow: 0 0 5px rgba(133, 72, 54, 0.3);
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #FFB22C;
            color: #000000;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }

        button:hover {
            background-color: #854836;
            color: white;
            transform: translateY(-2px);
        }

        #result {
            margin-top: 20px;
            text-align: center;
            min-height: 20px;
        }

        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            text-align: center;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        .store-info {
            text-align: center;
            color: white;
            position: fixed;
            bottom: 20px;
            width: 100%;
            left: 0;
        }

        .datetime {
            position: fixed;
            top: 20px;
            right: 20px;
            color: white;
            font-size: 0.9em;
            text-align: right;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 20px;
            }

            h2 {
                font-size: 1.5em;
            }

            .datetime {
                position: static;
                text-align: center;
                margin-bottom: 20px;
            }
        }
    </style>

    <script>
        function doLogin() {
            var username = document.getElementById("username").value;
            var password = document.getElementById("password").value;

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "http://localhost:8080/romuald_pahanaedu_backend/webresources/login", true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var resp = JSON.parse(xhr.responseText);
                    if (xhr.status === 200 && resp.status === "success") {
                        window.location.href = "main.jsp";
                    } else {
                        document.getElementById("result").innerHTML = "<div class='error-message'>" + resp.message + "</div>";
                    }
                }
            };
            xhr.send(JSON.stringify({ username: username, password: password }));
        }
    </script>
</head>
<body>
    

    <div class="login-container">
        <div class="logo">
            <!-- You can add your logo image here -->
            <h2>Pahanaedu Bookshop</h2>
        </div>
        
        <form onsubmit="event.preventDefault();doLogin();">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" required placeholder="Enter your username" />
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" required placeholder="Enter your password" />
            </div>
            
            <button type="submit">Login</button>
            <div id="result"></div>
        </form>
    </div>

    <div class="store-info">
        <p>© 2025 Pahanaedu Bookshop. All rights reserved.</p>
    </div>
</body>
</html>