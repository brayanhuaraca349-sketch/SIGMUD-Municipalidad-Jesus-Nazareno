package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.listener.SesionListener;
import pe.edu.lapontificia.sigmud.model.Usuario;
import java.io.IOException;
import java.sql.*;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

@WebServlet("/app/inicio")
public class InicioServlet extends HttpServlet {

    private final TramiteDAOImpl  tramiteDAO  = new TramiteDAOImpl();
    private final ProductoDAOImpl productoDAO = new ProductoDAOImpl();
    private final ReclamoDAOImpl  reclamoDAO  = new ReclamoDAOImpl();
    private final PagoDAOImpl     pagoDAO     = new PagoDAOImpl();
    private final PuestoDAOImpl   puestoDAO   = new PuestoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Usuario u = (Usuario) req.getSession().getAttribute("usuarioSesion");
        String rol = u != null ? u.getRol() : "";

        try {
            // Contadores comunes
            req.setAttribute("sesionesActivas", SesionListener.getSesionesActivas());

            switch (rol) {
                case "Administrador" -> {
                    req.setAttribute("tramitesRecibidos",  tramiteDAO.contarPorEstado("Recibido"));
                    req.setAttribute("tramitesEnProceso",  tramiteDAO.contarPorEstado("En proceso"));
                    req.setAttribute("tramitesResueltos",  tramiteDAO.contarPorEstado("Resuelto"));
                    req.setAttribute("productosbajoMin",   productoDAO.contarBajoMinimo());
                    req.setAttribute("reclamosPendientes", reclamoDAO.contarPendientes());
                    req.setAttribute("pagosVencidos",      pagoDAO.contarVencidos());
                    req.setAttribute("puestosActivos",     puestoDAO.contarPorEstado("Activo"));
                }
                case "MesaDePartes" -> {
                    req.setAttribute("tramitesRecibidos", tramiteDAO.contarPorEstado("Recibido"));
                    req.setAttribute("tramitesEnProceso", tramiteDAO.contarPorEstado("En proceso"));
                    req.setAttribute("tramitesResueltos", tramiteDAO.contarPorEstado("Resuelto"));
                }
                case "JefeMercado" -> {
                    req.setAttribute("puestosActivos",     puestoDAO.contarPorEstado("Activo"));
                    req.setAttribute("puestosSuspendidos", puestoDAO.contarPorEstado("Suspendido"));
                    req.setAttribute("pagosVencidos",      pagoDAO.contarVencidos());
                }
                case "Almacenero" -> {
                    req.setAttribute("productosbajoMin", productoDAO.contarBajoMinimo());
                    req.setAttribute("productosTotal",   contarTotal("SELECT COUNT(*) FROM productos"));
                    req.setAttribute("movimientosHoy",   contarTotal(
                        "SELECT COUNT(*) FROM movimientos_almacen WHERE DATE(fecha_movimiento)=CURDATE()"));
                }
                case "Reclamos" -> {
                    req.setAttribute("reclamosPendientes",  reclamoDAO.contarPendientes());
                    req.setAttribute("reclamosEnProceso",   contarTotal(
                        "SELECT COUNT(*) FROM reclamos WHERE estado='En proceso'"));
                    req.setAttribute("reclamosResueltos",   contarTotal(
                        "SELECT COUNT(*) FROM reclamos WHERE estado='Resuelto'"));
                }
            }
        } catch (Exception e) {
            getServletContext().log("Error en dashboard: " + e.getMessage(), e);
        }
        req.getRequestDispatcher("/WEB-INF/jsp/inicio.jsp").forward(req, res);
    }

    private long contarTotal(String sql) {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0;
        } catch (Exception e) { return 0; }
    }
}