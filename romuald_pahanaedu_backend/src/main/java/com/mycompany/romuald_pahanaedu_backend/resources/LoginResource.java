package com.mycompany.romuald_pahanaedu_backend.resources;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.json.JSONObject;

@Path("login")
public class LoginResource {

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(String jsonData) {
        JSONObject obj = new JSONObject(jsonData);
        String username = obj.optString("username");
        String password = obj.optString("password");

        if ("romuald".equals(username) && "romuald123".equals(password)) {
            JSONObject resp = new JSONObject();
            resp.put("status", "success");
            resp.put("message", "Login successful");
            return Response.ok(resp.toString()).build();
        } else {
            JSONObject resp = new JSONObject();
            resp.put("status", "error");
            resp.put("message", "Invalid credentials");
            return Response.status(Response.Status.UNAUTHORIZED).entity(resp.toString()).build();
        }
    }
}