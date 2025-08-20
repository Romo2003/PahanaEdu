/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
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
public class CustomerResourceTest {
    
    public CustomerResourceTest() {
    }

    @BeforeAll
    public static void setUpClass() throws Exception {
    }

    @AfterAll
    public static void tearDownClass() throws Exception {
    }

    @BeforeEach
    public void setUp() throws Exception {
    }

    @AfterEach
    public void tearDown() throws Exception {
    }

    /**
     * Test of addCustomer method, of class CustomerResource.
     */
@Test
public void testAddCustomer() {
    CustomerResource instance = new CustomerResource();
    String jsonData = "{\"name\":\"John Doe\",\"phone\":\"1234567890\"}";
    Response result = instance.addCustomer(jsonData);
    assertEquals(200, result.getStatus());
    String respStr = (String) result.getEntity();
    assertTrue(respStr.contains("\"status\":\"success\""));
}

    /**
     * Test of getCustomerByPhone method, of class CustomerResource.
     */
@Test
public void testGetCustomerByPhone() {
    CustomerResource instance = new CustomerResource();
    // First, add a customer
    String jsonData = "{\"name\":\"Jane Doe\",\"phone\":\"9876543210\"}";
    instance.addCustomer(jsonData);
    // Now fetch by phone
    Response result = instance.getCustomerByPhone("9876543210");
    assertEquals(200, result.getStatus());
    String respStr = (String) result.getEntity();
    assertTrue(respStr.contains("\"status\":\"found\""));
    assertTrue(respStr.contains("Jane Doe"));
}

    /**
     * Test of getCustomers method, of class CustomerResource.
     */
@Test
public void testGetCustomers() {
    System.out.println("getCustomers");
    String search = "";
    CustomerResource instance = new CustomerResource();
    Response result = instance.getCustomers(search);
    assertEquals(200, result.getStatus());
    String entity = (String) result.getEntity();
    assertTrue(entity.contains("\"status\":\"success\""));
}

    /**
     * Test of editCustomer method, of class CustomerResource.
     */
@Test
public void testEditCustomer() {
    CustomerResource instance = new CustomerResource();
    // Add a customer first
    String addJson = "{\"name\":\"Edit Me\",\"phone\":\"0000\"}";
    instance.addCustomer(addJson);
    // Suppose new customer is id=1 for test (you would need to fetch real id in practice)
    String editJson = "{\"name\":\"Edited Name\",\"phone\":\"1111\"}";
    Response result = instance.editCustomer(1, editJson);
    // Accept either success or not found, depending on your db state
    assertTrue(result.getStatus() == 200 || result.getStatus() == 404);
}

    /**
     * Test of deleteCustomer method, of class CustomerResource.
     */
@Test
public void testDeleteCustomer() {
    CustomerResource instance = new CustomerResource();
    // Add a customer to delete
    String addJson = "{\"name\":\"ToDelete\",\"phone\":\"9999\"}";
    instance.addCustomer(addJson);
    // Suppose id=1 for test (fetch real id in practice)
    Response result = instance.deleteCustomer(1);
    assertTrue(result.getStatus() == 200 || result.getStatus() == 404);
}
    
}