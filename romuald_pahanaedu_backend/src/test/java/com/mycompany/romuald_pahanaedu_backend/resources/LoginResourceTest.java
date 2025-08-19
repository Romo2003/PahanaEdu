package com.mycompany.romuald_pahanaedu_backend.resources;

import jakarta.ws.rs.core.Response;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Dell
 */
public class LoginResourceTest {
    
    public LoginResourceTest() {
    }
    
    @BeforeAll
    public static void setUpClass() {
    }
    
    @AfterAll
    public static void tearDownClass() {
    }
    
    @BeforeEach
    public void setUp() {
    }
    
    @AfterEach
    public void tearDown() {
    }

    /**
     * Test of login method, of class LoginResource.
     */
    @Test
    public void testLoginSuccess() {
        System.out.println("loginSuccess");
        // Valid credentials
        String jsonData = "{\"username\":\"romuald\",\"password\":\"romuald123\"}";
        LoginResource instance = new LoginResource();
        Response result = instance.login(jsonData);
        assertEquals(200, result.getStatus());
        String respStr = (String) result.getEntity();
        assertTrue(respStr.contains("\"status\":\"success\""));
        assertTrue(respStr.contains("\"Login successful\""));
    }
    
    @Test
    public void testLoginFailure() {
        System.out.println("loginFailure");
        // Invalid credentials
        String jsonData = "{\"username\":\"romuald\",\"password\":\"wrongpass\"}";
        LoginResource instance = new LoginResource();
        Response result = instance.login(jsonData);
        assertEquals(401, result.getStatus());
        String respStr = (String) result.getEntity();
        assertTrue(respStr.contains("\"status\":\"error\""));
        assertTrue(respStr.contains("\"Invalid credentials\""));
    }

    @Test
    public void testLoginWithEmptyJson() {
        System.out.println("loginEmptyJson");
        // Empty JSON
        String jsonData = "{}";
        LoginResource instance = new LoginResource();
        Response result = instance.login(jsonData);
        assertEquals(401, result.getStatus());
        String respStr = (String) result.getEntity();
        assertTrue(respStr.contains("\"status\":\"error\""));
        assertTrue(respStr.contains("\"Invalid credentials\""));
    }
}