package com.mycompany.romuald_pahanaedu_backend.resources;

import com.mycompany.romuald_pahanaedu_backend.model.Customer;
import com.mycompany.romuald_pahanaedu_backend.utils.DBUtil;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Path("customers")
public class CustomerResource {

    // Add Customer
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response addCustomer(String jsonData) {
        JSONObject obj = new JSONObject(jsonData);
        String name = obj.optString("name");
        String phone = obj.optString("phone");

        String sql = "INSERT INTO customers(name, phone) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.executeUpdate();
            return Response.ok(new JSONObject().put("status", "success").toString()).build();
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }
    }
    
    @GET
@Path("byphone")
@Produces(MediaType.APPLICATION_JSON)
public Response getCustomerByPhone(@QueryParam("phone") String phone) {
    String sql = "SELECT * FROM customers WHERE phone = ?";
    try (Connection con = DBUtil.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, phone);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            JSONObject obj = new JSONObject();
            obj.put("id", rs.getInt("id"));
            obj.put("name", rs.getString("name"));
            obj.put("phone", rs.getString("phone"));
            return Response.ok(new JSONObject().put("status","found").put("customer",obj).toString()).build();
        } else {
            return Response.ok(new JSONObject().put("status","notfound").toString()).build();
        }
    } catch (SQLException e) {
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                .build();
    }
}

    // List/Search Customers
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCustomers(@QueryParam("search") String search) {
        List<Customer> customers = new ArrayList<>();
        String sql = (search != null && !search.isEmpty())
                ? "SELECT * FROM customers WHERE name LIKE ? OR phone LIKE ?"
                : "SELECT * FROM customers";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (search != null && !search.isEmpty()) {
                ps.setString(1, "%" + search + "%");
                ps.setString(2, "%" + search + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                customers.add(new Customer(rs.getInt("id"), rs.getString("name"), rs.getString("phone")));
            }
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }

        JSONArray arr = new JSONArray();
        for (Customer c : customers) {
            JSONObject obj = new JSONObject();
            obj.put("id", c.getId());
            obj.put("name", c.getName());
            obj.put("phone", c.getPhone());
            arr.put(obj);
        }
        JSONObject resp = new JSONObject();
        resp.put("status", "success");
        resp.put("customers", arr);
        return Response.ok(resp.toString()).build();
    }

    // Edit Customer
    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response editCustomer(@PathParam("id") int id, String jsonData) {
        JSONObject obj = new JSONObject(jsonData);
        String name = obj.optString("name");
        String phone = obj.optString("phone");

        String sql = "UPDATE customers SET name = ?, phone = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setInt(3, id);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                return Response.ok(new JSONObject().put("status", "success").toString()).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new JSONObject().put("status", "error").put("message", "Customer not found").toString())
                        .build();
            }
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }
    }

    // Delete Customer
    @DELETE
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteCustomer(@PathParam("id") int id) {
        String sql = "DELETE FROM customers WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            int deleted = ps.executeUpdate();
            if (deleted > 0) {
                return Response.ok(new JSONObject().put("status", "success").toString()).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new JSONObject().put("status", "error").put("message", "Customer not found").toString())
                        .build();
            }
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }
    }
}