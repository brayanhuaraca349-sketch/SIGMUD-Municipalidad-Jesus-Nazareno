package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.model.*;
import pe.edu.lapontificia.sigmud.util.Paginador;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/** RF-02: CRUD trámites. RF-03: búsqueda con filtros y paginación. */
@WebServlet("/app/tramite")
public class TramiteServlet extends HttpServlet {

    private final TramiteDAOImpl  tramiteDAO  = new TramiteDAOImpl();
    private final CiudadanoDAOImpl ciudadanoDAO = new CiudadanoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String op = req.getParameter("op");
        if (op == null) op = "listar";
        try {
            switch (op) {
                case "nuevo"  -> mostrarFormulario(req, res, null);
                case "editar" -> mostrarFormulario(req, res,
                        tramiteDAO.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                default       -> listar(req, res);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            switch (req.getParameter("op")) {
                case "registrar"  -> registrar(req, res);
                case "actualizar" -> actualizar(req, res);
                case "eliminar"   -> eliminar(req, res);
                default -> res.sendRedirect(req.getContextPath() + "/app/tramite");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    private void listar(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        // RF-03: filtros
        String estado = req.getParameter("estado");
        String tipo   = req.getParameter("tipo");
        String desde  = req.getParameter("desde");
        String hasta  = req.getParameter("hasta");
        int pagina    = parsePagina(req.getParameter("pagina"));

        int total     = tramiteDAO.contarFiltrado(estado, tipo, desde, hasta);
        Paginador pag = new Paginador(total, pagina);
        List<Tramite> lista = tramiteDAO.listar(estado, tipo, desde, hasta,
                pag.getOffset(), pag.getRegistrosPorPagina());

        req.setAttribute("lista",    lista);
        req.setAttribute("pag",      pag);
        req.setAttribute("fEstado",  estado);
        req.setAttribute("fTipo",    tipo);
        req.setAttribute("fDesde",   desde);
        req.setAttribute("fHasta",   hasta);
        req.getRequestDispatcher("/WEB-INF/jsp/tramite/lista.jsp").forward(req, res);
    }

    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse res, Tramite t)
            throws Exception {
        req.setAttribute("tramite",    t);
        req.setAttribute("ciudadanos", ciudadanoDAO.listar());
        req.getRequestDispatcher("/WEB-INF/jsp/tramite/form.jsp").forward(req, res);
    }

    private void registrar(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        String idCiudStr = req.getParameter("idCiudadano");
        String tipo      = req.getParameter("tipoTramite");
        if (idCiudStr == null || idCiudStr.isBlank() || tipo == null || tipo.isBlank()) {
            req.setAttribute("error", "Ciudadano y tipo de trámite son obligatorios.");
            mostrarFormulario(req, res, null);
            return;
        }
        Usuario u = (Usuario) req.getSession().getAttribute("usuarioSesion");
        Tramite t = new Tramite();
        t.setIdCiudadano(Integer.parseInt(idCiudStr));
        t.setTipoTramite(tipo);
        t.setDescripcion(req.getParameter("descripcion"));
        t.setFechaIngreso(LocalDate.now());
        t.setEstado("Recibido");
        t.setIdUsuario(u.getIdUsuario());
        t.setNumExpediente(tramiteDAO.generarNumExpediente(tipo));
        tramiteDAO.insertar(t);
        res.sendRedirect(req.getContextPath() + "/app/tramite?msg=ok");
    }

    private void actualizar(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("idTramite"));
        Tramite t = tramiteDAO.buscarPorId(id);
        t.setTipoTramite(req.getParameter("tipoTramite"));
        t.setDescripcion(req.getParameter("descripcion"));
        t.setEstado(req.getParameter("estado"));
        String fr = req.getParameter("fechaRespuesta");
        if (fr != null && !fr.isBlank()) t.setFechaRespuesta(LocalDate.parse(fr));
        tramiteDAO.actualizar(t);
        res.sendRedirect(req.getContextPath() + "/app/tramite?msg=ok");
    }

    private void eliminar(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        tramiteDAO.eliminar(Integer.parseInt(req.getParameter("id")));
        res.sendRedirect(req.getContextPath() + "/app/tramite?msg=ok");
    }

    private int parsePagina(String p) {
        try { return Integer.parseInt(p); } catch (Exception e) { return 1; }
    }
}
