<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Pahanaedu Bookshop Login</title>
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
                        // Redirect to main page on successful login
                        window.location.href = "main.jsp";
                    } else {
                        document.getElementById("result").innerHTML = "<span style='color:red'>" + resp.message + "</span>";
                    }
                }
            };
            xhr.send(JSON.stringify({ username: username, password: password }));
        }
    </script>
</head>
<body>
    <h2>Pahanaedu Bookshop Login</h2>
    <form onsubmit="event.preventDefault();doLogin();">
        <label>Username:</label><input type="text" id="username" required /><br/>
        <label>Password:</label><input type="password" id="password" required /><br/>
        <button type="submit">Login</button>
    </form>
    <div id="result"></div>
</body>
</html>