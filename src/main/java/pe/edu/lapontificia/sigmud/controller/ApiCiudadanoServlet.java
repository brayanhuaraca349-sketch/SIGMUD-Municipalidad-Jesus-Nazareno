package pe.edu.lapontificia.sigmud.controller;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.CiudadanoDAOImpl;
import pe.edu.lapontificia.sigmud.model.Ciudadano;
import java.io.IOException;

/** Ajax: busca ciudadano por DNI → responde JSON */
@WebServlet("/app/api/ciudadano")
public class ApiCiudadanoServlet extends HttpServlet {

    private final CiudadanoDAOImpl dao = new CiudadanoDAOImpl();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.setContentType("application/json;charset=UTF-8");
        JsonObject json = new JsonObject();
        String dni = req.getParameter("dni");
        if (dni == null || !dni.matches("^\\d{8}$")) {
            json.addProperty("encontrado", false);
            json.addProperty("msg", "DNI inválido");
            res.getWriter().print(json); return;
        }
        try {
            Ciudadano c = dao.buscarPorDni(dni.trim());
            if (c != null) {
                json.addProperty("encontrado",   true);
                json.addProperty("idCiudadano",  c.getIdCiudadano());
                json.addProperty("nombre",        c.getNombre());
                json.addProperty("apellidos",     c.getApellidos());
                json.addProperty("nombreCompleto",c.getNombreCompleto());
            } else {
                json.addProperty("encontrado", false);
            }
        } catch (Exception e) {
            json.addProperty("encontrado", false);
            json.addProperty("msg", e.getMessage());
        }
        res.getWriter().print(json);
    }
}
