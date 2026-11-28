package pe.edu.lapontificia.sigmud.controller;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.model.*;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;

/**
 * RF-06: Registrar pagos de puesto.
 * GET ?op=listar  → lista pagos con filtros
 * GET ?op=nuevo   → formulario de pago
 * POST op=registrar → transacción Ajax: INSERT pagos + UPDATE puestos.estado
 */
@WebServlet("/app/mercado/pago")
public class PagoServlet extends HttpServlet {

    private final PagoDAOImpl   pagoDAO   = new PagoDAOImpl();
    private final PuestoDAOImpl puestoDAO = new PuestoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String op = req.getParameter("op"); if (op == null) op = "listar";
        try {
            switch (op) {
                case "nuevo" -> {
                    req.setAttribute("puestos", puestoDAO.listar(null));
                    req.getRequestDispatcher("/WEB-INF/jsp/mercado/formPago.jsp").forward(req, res);
                }
                default -> {
                    Integer idPuesto = req.getParameter("idPuesto") != null && !req.getParameter("idPuesto").isBlank()
                            ? Integer.parseInt(req.getParameter("idPuesto")) : null;
                    List<PagoPuesto> lista = pagoDAO.listar(idPuesto,
                            req.getParameter("periodo"), req.getParameter("estado"));
                    req.setAttribute("lista",    lista);
                    req.setAttribute("puestos",  puestoDAO.listar(null));
                    req.setAttribute("fIdPuesto",req.getParameter("idPuesto"));
                    req.setAttribute("fPeriodo", req.getParameter("periodo"));
                    req.setAttribute("fEstado",  req.getParameter("estado"));
                    req.getRequestDispatcher("/WEB-INF/jsp/mercado/listaPago.jsp").forward(req, res);
                }
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    /**
     * POST Ajax: registra pago con transacción setAutoCommit(false).
     * Responde JSON {ok: bool, msg: string}
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json;charset=UTF-8");
        JsonObject json = new JsonObject();

        try {
            int    idPuesto = Integer.parseInt(req.getParameter("idPuesto"));
            String periodo  = req.getParameter("periodo");
            String montoStr = req.getParameter("monto");
            String fechaStr = req.getParameter("fechaPago");

            // Validar duplicado ANTES de abrir transacción
            if (pagoDAO.existePago(idPuesto, periodo)) {
                json.addProperty("ok",  false);
                json.addProperty("msg", "Ya existe un pago para ese puesto en el período " + periodo);
                res.getWriter().print(json);
                return;
            }

            Usuario u = (Usuario) req.getSession().getAttribute("usuarioSesion");
            PagoPuesto pago = new PagoPuesto();
            pago.setIdPuesto(idPuesto);
            pago.setPeriodo(periodo);
            pago.setMonto(new BigDecimal(montoStr));
            if (fechaStr != null && !fechaStr.isBlank()) pago.setFechaPago(LocalDate.parse(fechaStr));
            pago.setEstado("Pagado");
            pago.setIdUsuario(u.getIdUsuario());

            // Transacción explícita: INSERT pago + UPDATE estado puesto
            try (Connection cn = ConexionDB.getConexion()) {
                cn.setAutoCommit(false);
                try {
                    pagoDAO.insertar(pago, cn);
                    puestoDAO.actualizarEstado(idPuesto, "Activo", cn);
                    cn.commit();
                    json.addProperty("ok",  true);
                    json.addProperty("msg", "Pago registrado correctamente.");
                } catch (Exception e) {
                    cn.rollback();
                    json.addProperty("ok",  false);
                    json.addProperty("msg", "Error al registrar pago: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            json.addProperty("ok",  false);
            json.addProperty("msg", "Error: " + e.getMessage());
        }
        res.getWriter().print(json);
    }
}
