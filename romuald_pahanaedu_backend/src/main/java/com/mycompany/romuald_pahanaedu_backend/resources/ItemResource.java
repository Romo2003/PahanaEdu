package com.mycompany.romuald_pahanaedu_backend.resources;

import com.mycompany.romuald_pahanaedu_backend.model.Item;
import com.mycompany.romuald_pahanaedu_backend.utils.DBUtil;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Path("items")
public class ItemResource {

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response addItem(String jsonData) {
        JSONObject obj = new JSONObject(jsonData);
        String name = obj.optString("name");
        double price = obj.optDouble("price");

        String sql = "INSERT INTO items(name, price) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.executeUpdate();
            return Response.ok(new JSONObject().put("status", "success").toString()).build();
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getItems(@QueryParam("search") String search) {
        List<Item> items = new ArrayList<>();
        String sql = (search != null && !search.isEmpty())
                ? "SELECT * FROM items WHERE name LIKE ?"
                : "SELECT * FROM items";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (search != null && !search.isEmpty()) {
                ps.setString(1, "%" + search + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(new Item(rs.getInt("id"), rs.getString("name"), rs.getDouble("price")));
            }
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }

        JSONArray arr = new JSONArray();
        for (Item i : items) {
            JSONObject obj = new JSONObject();
            obj.put("id", i.getId());
            obj.put("name", i.getName());
            obj.put("price", i.getPrice());
            arr.put(obj);
        }
        JSONObject resp = new JSONObject();
        resp.put("status", "success");
        resp.put("items", arr);
        return Response.ok(resp.toString()).build();
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response editItem(@PathParam("id") int id, String jsonData) {
        JSONObject obj = new JSONObject(jsonData);
        String name = obj.optString("name");
        double price = obj.optDouble("price");

        String sql = "UPDATE items SET name = ?, price = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, id);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                return Response.ok(new JSONObject().put("status", "success").toString()).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new JSONObject().put("status", "error").put("message", "Item not found").toString())
                        .build();
            }
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteItem(@PathParam("id") int id) {
        String sql = "DELETE FROM items WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            int deleted = ps.executeUpdate();
            if (deleted > 0) {
                return Response.ok(new JSONObject().put("status", "success").toString()).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new JSONObject().put("status", "error").put("message", "Item not found").toString())
                        .build();
            }
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new JSONObject().put("status", "error").put("message", e.getMessage()).toString())
                    .build();
        }
    }
}