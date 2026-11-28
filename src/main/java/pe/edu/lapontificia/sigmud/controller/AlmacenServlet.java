package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.model.*;
import java.io.IOException;

@WebServlet("/app/almacen")
public class AlmacenServlet extends HttpServlet {

    private final ProductoDAOImpl   productoDAO   = new ProductoDAOImpl();
    private final MovimientoDAOImpl movimientoDAO = new MovimientoDAOImpl();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String op = req.getParameter("op"); if (op == null) op = "stock";
        try {
            switch (op) {
                case "movimientos" -> {
                    req.setAttribute("lista", movimientoDAO.listar());
                    req.getRequestDispatcher("/WEB-INF/jsp/almacen/movimientos.jsp").forward(req, res);
                }
                case "nuevoMovimiento" -> {
                    req.setAttribute("productos", productoDAO.listar());
                    req.getRequestDispatcher("/WEB-INF/jsp/almacen/formMovimiento.jsp").forward(req, res);
                }
                case "nuevoProducto"  -> req.getRequestDispatcher("/WEB-INF/jsp/almacen/formProducto.jsp").forward(req, res);
                case "editarProducto" -> {
                    req.setAttribute("producto", productoDAO.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                    req.getRequestDispatcher("/WEB-INF/jsp/almacen/formProducto.jsp").forward(req, res);
                }
                default -> {
                    req.setAttribute("lista", productoDAO.listar());
                    req.getRequestDispatcher("/WEB-INF/jsp/almacen/stock.jsp").forward(req, res);
                }
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            switch (req.getParameter("op")) {
                case "registrarMovimiento" -> registrarMovimiento(req, res);
                case "guardarProducto"     -> guardarProducto(req, res, false);
                case "actualizarProducto"  -> guardarProducto(req, res, true);
                case "eliminarProducto"    -> { productoDAO.eliminar(Integer.parseInt(req.getParameter("id"))); redirect(req, res, "stock"); }
                default -> redirect(req, res, "stock");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    private void registrarMovimiento(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        Usuario u = (Usuario) req.getSession().getAttribute("usuarioSesion");
        MovimientoAlmacen m = new MovimientoAlmacen();
        m.setIdProducto(Integer.parseInt(req.getParameter("idProducto")));
        m.setTipo(req.getParameter("tipo"));
        m.setCantidad(Integer.parseInt(req.getParameter("cantidad")));
        m.setIdUsuario(u.getIdUsuario());
        m.setObservacion(req.getParameter("observacion"));
        boolean ok = movimientoDAO.registrar(m);
        if (ok) redirect(req, res, "movimientos");
        else {
            req.setAttribute("error", "Stock insuficiente para registrar la salida.");
            req.setAttribute("productos", productoDAO.listar());
            req.getRequestDispatcher("/WEB-INF/jsp/almacen/formMovimiento.jsp").forward(req, res);
        }
    }

    private void guardarProducto(HttpServletRequest req, HttpServletResponse res, boolean esEdicion)
            throws Exception {
        Producto p = new Producto();
        p.setNombre(req.getParameter("nombre"));
        p.setUnidad(req.getParameter("unidad"));
        p.setStockActual(Integer.parseInt(req.getParameter("stockActual")));
        p.setStockMinimo(Integer.parseInt(req.getParameter("stockMinimo")));
        p.setCategoria(req.getParameter("categoria"));
        if (esEdicion) { p.setIdProducto(Integer.parseInt(req.getParameter("idProducto"))); productoDAO.actualizar(p); }
        else productoDAO.insertar(p);
        redirect(req, res, "stock");
    }

    private void redirect(HttpServletRequest req, HttpServletResponse res, String op) throws IOException {
        res.sendRedirect(req.getContextPath() + "/app/almacen?op=" + op + "&msg=ok");
    }
}
