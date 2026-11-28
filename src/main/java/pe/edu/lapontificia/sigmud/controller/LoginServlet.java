package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.UsuarioDAOImpl;
import pe.edu.lapontificia.sigmud.model.Usuario;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAOImpl usuarioDAO = new UsuarioDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("usuarioSesion") != null) {
            res.sendRedirect(req.getContextPath() + "/app/inicio");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String correo = req.getParameter("correo");
        String clave  = req.getParameter("clave");

        if (correo == null || correo.isBlank() || clave == null || clave.isBlank()) {
            req.setAttribute("error", "Ingrese correo y contraseña.");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            return;
        }

        correo = correo.trim();

        try {
            // Verificar si la cuenta existe (para control de intentos)
            Usuario existente = usuarioDAO.buscarPorCorreo(correo);

            if (existente != null && existente.getActivo() == 0) {
                req.setAttribute("error", "Cuenta bloqueada por múltiples intentos fallidos. Contacte al administrador.");
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
                return;
            }

            String hash   = sha256(clave);
            Usuario usuario = usuarioDAO.autenticar(correo, hash);

            if (usuario != null) {
                // Éxito: resetear intentos y crear sesión
                usuarioDAO.resetIntentos(correo);
                HttpSession sesion = req.getSession(true);
                sesion.setAttribute("usuarioSesion", usuario);
                sesion.setMaxInactiveInterval(30 * 60);
                res.sendRedirect(req.getContextPath() + "/app/inicio");
            } else {
                // Fallo: incrementar intentos
                if (existente != null) {
                    usuarioDAO.incrementarIntentos(correo);
                    existente = usuarioDAO.buscarPorCorreo(correo);
                    int intentos = existente != null ? existente.getIntentosFallidos() : 5;
                    if (intentos >= 5) {
                        usuarioDAO.desactivarPorIntentos(correo);
                        req.setAttribute("error", "Cuenta bloqueada por 5 intentos fallidos. Contacte al administrador.");
                    } else {
                        req.setAttribute("error", "Credenciales incorrectas. Intentos restantes: " + (5 - intentos));
                    }
                } else {
                    req.setAttribute("error", "Credenciales incorrectas.");
                }
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            }

        } 
        catch (Exception e) {
    e.printStackTrace();

    req.setAttribute("error",
            e.getClass().getName() + " : " + e.getMessage());

    req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
}

    }

    /** SHA-256 puro Java – mismo resultado que SHA2(pass, 256) en MySQL */
    public static String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 no disponible", e);
        }
    }
}
