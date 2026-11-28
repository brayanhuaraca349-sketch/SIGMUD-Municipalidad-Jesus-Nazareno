package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.UsuarioDAOImpl;
import pe.edu.lapontificia.sigmud.model.Usuario;
import java.io.IOException;

@WebServlet("/app/admin/usuario")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAOImpl dao = new UsuarioDAOImpl();

    private boolean esAdmin(HttpServletRequest req) {
        Usuario u = (Usuario) req.getSession().getAttribute("usuarioSesion");
        return u != null && "Administrador".equals(u.getRol());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!esAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/app/inicio");
            return;
        }
        String op = req.getParameter("op");
        if (op == null) op = "listar";
        try {
            switch (op) {
                case "nuevo" ->
                    req.getRequestDispatcher("/WEB-INF/jsp/admin/formUsuario.jsp").forward(req, res);
                case "editar" -> {
                    req.setAttribute("usuario",
                        dao.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                    req.getRequestDispatcher("/WEB-INF/jsp/admin/formUsuario.jsp").forward(req, res);
                }
                default -> {
                    req.setAttribute("lista", dao.listar());
                    req.getRequestDispatcher("/WEB-INF/jsp/admin/listaUsuario.jsp").forward(req, res);
                }
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!esAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/app/inicio");
            return;
        }
        req.setCharacterEncoding("UTF-8");
        try {
            String op = req.getParameter("op");
            switch (op) {
                case "registrar" -> {
                    Usuario u = new Usuario();
                    u.setNombre(req.getParameter("nombre"));
                    u.setCorreo(req.getParameter("correo"));
                    // Hash SHA-256 de la contraseña
                    u.setContrasena(LoginServlet.sha256(req.getParameter("contrasena")));
                    u.setRol(req.getParameter("rol"));
                    dao.insertar(u);
                }
                case "actualizar" -> {
                    Usuario u = new Usuario();
                    u.setIdUsuario(Integer.parseInt(req.getParameter("idUsuario")));
                    u.setNombre(req.getParameter("nombre"));
                    u.setCorreo(req.getParameter("correo"));
                    u.setRol(req.getParameter("rol"));
                    u.setActivo(Integer.parseInt(req.getParameter("activo")));
                    dao.actualizar(u);
                }
                case "desactivar" ->
                    dao.desactivar(Integer.parseInt(req.getParameter("id")));
            }
            res.sendRedirect(req.getContextPath() + "/app/admin/usuario?msg=ok");
        } catch (Exception e) { throw new ServletException(e); }
    }
}
