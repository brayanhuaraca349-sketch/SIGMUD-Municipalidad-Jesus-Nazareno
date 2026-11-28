package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.model.Puesto;
import java.io.IOException;
import java.math.BigDecimal;

/** RF-04 RF-05: CRUD puestos de mercado */
@WebServlet("/app/mercado/puesto")
public class PuestoServlet extends HttpServlet {

    private final PuestoDAOImpl dao = new PuestoDAOImpl();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String op = req.getParameter("op"); if (op == null) op = "listar";
        try {
            switch (op) {
                case "nuevo"  -> forward(req, res, null);
                case "editar" -> forward(req, res, dao.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                default -> {
                    req.setAttribute("lista",       dao.listar(req.getParameter("estado")));
                    req.setAttribute("fEstado",     req.getParameter("estado"));
                    req.getRequestDispatcher("/WEB-INF/jsp/mercado/listaPuesto.jsp").forward(req, res);
                }
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            switch (req.getParameter("op")) {
                case "registrar"  -> guardar(req, res, false);
                case "actualizar" -> guardar(req, res, true);
                case "eliminar"   -> { dao.eliminar(Integer.parseInt(req.getParameter("id"))); redirect(req, res); }
                default -> redirect(req, res);
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    private void guardar(HttpServletRequest req, HttpServletResponse res, boolean esEdicion)
            throws Exception {
        String num = req.getParameter("numPuesto");
        int excluirId = esEdicion ? Integer.parseInt(req.getParameter("idPuesto")) : 0;
        if (dao.existeNumPuesto(num, excluirId)) {
            req.setAttribute("error", "El número de puesto ya existe.");
            Puesto p = construir(req); if (esEdicion) p.setIdPuesto(excluirId);
            forward(req, res, p); return;
        }
        Puesto p = construir(req);
        if (esEdicion) { p.setIdPuesto(excluirId); dao.actualizar(p); }
        else dao.insertar(p);
        redirect(req, res);
    }

    private Puesto construir(HttpServletRequest req) {
        Puesto p = new Puesto();
        p.setNumPuesto(req.getParameter("numPuesto"));
        p.setTitular(req.getParameter("titular"));
        p.setDniTitular(req.getParameter("dniTitular"));
        p.setSeccion(req.getParameter("seccion"));
        String m = req.getParameter("montoMensual");
        p.setMontoMensual(m != null && !m.isBlank() ? new BigDecimal(m) : BigDecimal.ZERO);
        p.setEstado(req.getParameter("estado"));
        return p;
    }

    private void forward(HttpServletRequest req, HttpServletResponse res, Puesto p)
            throws Exception {
        req.setAttribute("puesto", p);
        req.getRequestDispatcher("/WEB-INF/jsp/mercado/formPuesto.jsp").forward(req, res);
    }
    private void redirect(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect(req.getContextPath() + "/app/mercado/puesto?msg=ok");
    }
}
