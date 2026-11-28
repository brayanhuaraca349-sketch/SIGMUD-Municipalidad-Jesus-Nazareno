package pe.edu.lapontificia.sigmud.controller;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.model.*;
import java.io.IOException;

@WebServlet("/app/reclamo")
public class ReclamoServlet extends HttpServlet {

    private final ReclamoDAOImpl   reclamoDAO   = new ReclamoDAOImpl();
    private final CiudadanoDAOImpl ciudadanoDAO = new CiudadanoDAOImpl();
    private final UsuarioDAOImpl   usuarioDAO   = new UsuarioDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String op = req.getParameter("op");
        if (op == null) op = "listar";
        try {
            switch (op) {
                case "nuevo" -> {
                    req.setAttribute("ciudadanos", ciudadanoDAO.listar());
                    req.setAttribute("usuarios",   usuarioDAO.listar());
                    req.getRequestDispatcher("/WEB-INF/jsp/reclamos/form.jsp").forward(req, res);
                }
                default -> {
                    req.setAttribute("lista",   reclamoDAO.listar(req.getParameter("estado")));
                    req.setAttribute("fEstado", req.getParameter("estado"));
                    req.getRequestDispatcher("/WEB-INF/jsp/reclamos/lista.jsp").forward(req, res);
                }
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        // Operación Ajax: cambiar estado
        if ("cambiarEstado".equals(op)) {
            res.setContentType("application/json;charset=UTF-8");
            JsonObject json = new JsonObject();
            try {
                int id    = Integer.parseInt(req.getParameter("idReclamo"));
                String est = req.getParameter("estado");
                boolean ok = reclamoDAO.cambiarEstado(id, est);
                json.addProperty("ok",  ok);
                json.addProperty("msg", ok ? "Estado actualizado." : "Error al actualizar.");
            } catch (Exception e) {
                json.addProperty("ok",  false);
                json.addProperty("msg", e.getMessage());
            }
            res.getWriter().print(json);
            return;
        }

        // Operaciones normales
        try {
            switch (op) {
                case "registrar" -> registrar(req, res);
                case "eliminar"  -> {
                    reclamoDAO.eliminar(Integer.parseInt(req.getParameter("id")));
                    res.sendRedirect(req.getContextPath() + "/app/reclamo?msg=ok");
                }
                default -> res.sendRedirect(req.getContextPath() + "/app/reclamo");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    private void registrar(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        String idCiudStr = req.getParameter("idCiudadano");
        String tipo      = req.getParameter("tipo");
        String desc      = req.getParameter("descripcion");

        if (idCiudStr == null || idCiudStr.isBlank()
                || tipo == null || tipo.isBlank()
                || desc == null || desc.isBlank()) {
            req.setAttribute("error", "Ciudadano, tipo y descripción son obligatorios.");
            req.setAttribute("ciudadanos", ciudadanoDAO.listar());
            req.setAttribute("usuarios",   usuarioDAO.listar());
            req.getRequestDispatcher("/WEB-INF/jsp/reclamos/form.jsp").forward(req, res);
            return;
        }

        Reclamo r = new Reclamo();
        r.setIdCiudadano(Integer.parseInt(idCiudStr));
        r.setTipo(tipo);
        r.setDescripcion(desc);
        r.setEstado("Recibido");
        String idRespStr = req.getParameter("idResponsable");
        if (idRespStr != null && !idRespStr.isBlank()) {
            r.setIdResponsable(Integer.parseInt(idRespStr));
        }
        reclamoDAO.insertar(r);
        res.sendRedirect(req.getContextPath() + "/app/reclamo?msg=ok");
    }
}
