package com.mycompany.romuald_pahanaedu_backend.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/romould";
    private static final String USER = "root"; // change if your DB user is not root
    private static final String PASS = ""; // change to your db password

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found.");
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}