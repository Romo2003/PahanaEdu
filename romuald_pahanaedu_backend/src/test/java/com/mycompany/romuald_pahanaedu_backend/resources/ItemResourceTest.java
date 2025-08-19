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
public class ItemResourceTest {
    
    public ItemResourceTest() {
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
     * Test of addItem method, of class ItemResource.
     */
    @Test
    public void testAddItem() {
        System.out.println("addItem");
        // Provide valid JSON for item creation
        String jsonData = "{\"name\":\"Test Item\",\"price\":9.99}";
        ItemResource instance = new ItemResource();
        Response result = instance.addItem(jsonData);
        assertEquals(200, result.getStatus());
        String respStr = (String) result.getEntity();
        assertTrue(respStr.contains("\"status\":\"success\""));
    }

    /**
     * Test of getItems method, of class ItemResource.
     */
    @Test
    public void testGetItems() {
        System.out.println("getItems");
        String search = "";
        ItemResource instance = new ItemResource();
        Response result = instance.getItems(search);
        assertEquals(200, result.getStatus());
        String entity = (String) result.getEntity();
        assertTrue(entity.contains("\"status\":\"success\""));
        assertTrue(entity.contains("\"items\""));
    }

    /**
     * Test of editItem method, of class ItemResource.
     */
    @Test
    public void testEditItem() {
        System.out.println("editItem");
        ItemResource instance = new ItemResource();
        // Add an item to edit (assume id=1 for this test)
        String addJson = "{\"name\":\"Edit Me\",\"price\":1.23}";
        instance.addItem(addJson);
        // Now attempt to edit id=1 (assumption for test purposes, in real test fetch actual id)
        int id = 1;
        String jsonData = "{\"name\":\"Edited Item\",\"price\":2.34}";
        Response result = instance.editItem(id, jsonData);
        // Accept either success or not found, depending on your db state
        assertTrue(result.getStatus() == 200 || result.getStatus() == 404);
    }

    /**
     * Test of deleteItem method, of class ItemResource.
     */
    @Test
    public void testDeleteItem() {
        System.out.println("deleteItem");
        ItemResource instance = new ItemResource();
        // Add an item to delete (assume id=1 for this test)
        String addJson = "{\"name\":\"ToDelete\",\"price\":7.77}";
        instance.addItem(addJson);
        int id = 1;
        Response result = instance.deleteItem(id);
        // Accept either success or not found, depending on your db state
        assertTrue(result.getStatus() == 200 || result.getStatus() == 404);
    }
    
}