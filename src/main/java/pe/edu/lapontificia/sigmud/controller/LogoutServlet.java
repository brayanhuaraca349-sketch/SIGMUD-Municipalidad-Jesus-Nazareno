package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();
        res.setHeader("Cache-Control", "no-store");
        res.sendRedirect(req.getContextPath() + "/login");
    }
}
