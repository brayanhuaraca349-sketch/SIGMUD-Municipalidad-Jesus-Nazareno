package pe.edu.lapontificia.sigmud.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.dao.impl.*;
import pe.edu.lapontificia.sigmud.model.*;

import java.io.*;
import java.util.List;

@WebServlet("/app/reporte")
public class ReporteServlet extends HttpServlet {

    private final TramiteDAOImpl tramiteDAO = new TramiteDAOImpl();
    private final PagoDAOImpl    pagoDAO    = new PagoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/reportes/filtro.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String modulo   = req.getParameter("modulo");
        String estado   = req.getParameter("estado");
        String desde    = req.getParameter("desde");
        String hasta    = req.getParameter("hasta");
        String exportar = req.getParameter("exportar");

        try {
            if ("pagos".equals(modulo)) {
                List<PagoPuesto> lista = pagoDAO.listar(null, req.getParameter("periodo"), estado);
                if ("csv".equals(exportar)) { exportarPagosCSV(res, lista); return; }
                req.setAttribute("listaPagos", lista);
                req.setAttribute("modulo", "pagos");
            } else {
                List<Tramite> lista = tramiteDAO.listar(estado, req.getParameter("tipo"),
                        desde, hasta, 0, 1000);
                if ("csv".equals(exportar)) { exportarTramitesCSV(res, lista); return; }
                req.setAttribute("listaTramites", lista);
                req.setAttribute("modulo", "tramites");
            }
            req.setAttribute("fEstado", estado);
            req.setAttribute("fDesde",  desde);
            req.setAttribute("fHasta",  hasta);
            req.getRequestDispatcher("/WEB-INF/jsp/reportes/resultado.jsp").forward(req, res);
        } catch (Exception e) { throw new ServletException(e); }
    }

    private void exportarTramitesCSV(HttpServletResponse res, List<Tramite> lista)
            throws IOException {
        res.setContentType("text/csv;charset=UTF-8");
        res.setHeader("Content-Disposition",
                "attachment; filename=\"reporte_tramites.csv\"");
        PrintWriter pw = res.getWriter();
        // BOM para que Excel reconozca UTF-8
        pw.print('\uFEFF');
        pw.println("N° Expediente,Ciudadano,DNI,Tipo de Trámite,Fecha Ingreso,Estado,Funcionario");
        for (Tramite t : lista) {
            pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                safe(t.getNumExpediente()),
                safe(t.getNombreCiudadano()),
                safe(t.getDniCiudadano()),
                safe(t.getTipoTramite()),
                t.getFechaIngreso() != null ? t.getFechaIngreso().toString() : "",
                safe(t.getEstado()),
                safe(t.getNombreUsuario()));
        }
    }

    private void exportarPagosCSV(HttpServletResponse res, List<PagoPuesto> lista)
            throws IOException {
        res.setContentType("text/csv;charset=UTF-8");
        res.setHeader("Content-Disposition",
                "attachment; filename=\"reporte_pagos.csv\"");
        PrintWriter pw = res.getWriter();
        // BOM para que Excel reconozca UTF-8
        pw.print('\uFEFF');
        pw.println("N° Puesto,Titular,Sección,Período,Monto (S/),Fecha Pago,Estado");
        for (PagoPuesto p : lista) {
            pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                safe(p.getNumPuesto()),
                safe(p.getTitularPuesto()),
                safe(p.getSeccionPuesto()),
                safe(p.getPeriodo()),
                p.getMonto() != null ? p.getMonto().toString() : "0.00",
                p.getFechaPago() != null ? p.getFechaPago().toString() : "—",
                safe(p.getEstado()));
        }
    }

    private String safe(String s) { return s == null ? "" : s; }
}