package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.TramiteDAO;
import pe.edu.lapontificia.sigmud.model.Tramite;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TramiteDAOImpl implements TramiteDAO {

    private static final String BASE_SELECT =
        "SELECT t.id_tramite, t.num_expediente, t.id_ciudadano, t.tipo_tramite, " +
        "t.descripcion, t.fecha_ingreso, t.fecha_respuesta, t.estado, t.id_usuario, " +
        "CONCAT(c.nombre,' ',c.apellidos) AS nombre_ciudadano, c.dni AS dni_ciudadano, " +
        "u.nombre AS nombre_usuario " +
        "FROM tramites t " +
        "JOIN ciudadanos c ON t.id_ciudadano = c.id_ciudadano " +
        "JOIN usuarios   u ON t.id_usuario   = u.id_usuario ";

    private Tramite mapear(ResultSet rs) throws SQLException {
        Tramite t = new Tramite();
        t.setIdTramite(rs.getInt("id_tramite"));
        t.setNumExpediente(rs.getString("num_expediente"));
        t.setIdCiudadano(rs.getInt("id_ciudadano"));
        t.setTipoTramite(rs.getString("tipo_tramite"));
        t.setDescripcion(rs.getString("descripcion"));
        Date fi = rs.getDate("fecha_ingreso");
        if (fi != null) t.setFechaIngreso(fi.toLocalDate());
        Date fr = rs.getDate("fecha_respuesta");
        if (fr != null) t.setFechaRespuesta(fr.toLocalDate());
        t.setEstado(rs.getString("estado"));
        t.setIdUsuario(rs.getInt("id_usuario"));
        try { t.setNombreCiudadano(rs.getString("nombre_ciudadano")); } catch (SQLException ignored){}
        try { t.setDniCiudadano(rs.getString("dni_ciudadano")); }       catch (SQLException ignored){}
        try { t.setNombreUsuario(rs.getString("nombre_usuario")); }     catch (SQLException ignored){}
        return t;
    }

    private void agregarFiltros(StringBuilder sql, List<Object> params,
                                 String estado, String tipo, String desde, String hasta) {
        if (estado != null && !estado.isBlank()) { sql.append(" AND t.estado=?");        params.add(estado); }
        if (tipo   != null && !tipo.isBlank())   { sql.append(" AND t.tipo_tramite=?");  params.add(tipo); }
        if (desde  != null && !desde.isBlank())  { sql.append(" AND t.fecha_ingreso>=?");params.add(desde); }
        if (hasta  != null && !hasta.isBlank())  { sql.append(" AND t.fecha_ingreso<=?");params.add(hasta); }
    }

    private void setParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) ps.setString(i + 1, params.get(i).toString());
    }

    @Override
    public List<Tramite> listar(String estado, String tipo, String desde, String hasta,
                                 int offset, int limit) throws SQLException {
        List<Tramite> lista = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE 1=1");
        agregarFiltros(sql, params, estado, tipo, desde, hasta);
        sql.append(" ORDER BY t.fecha_ingreso DESC LIMIT ? OFFSET ?");

        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            setParams(ps, params);
            ps.setInt(params.size() + 1, limit);
            ps.setInt(params.size() + 2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public int contarFiltrado(String estado, String tipo, String desde, String hasta) throws SQLException {
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM tramites t WHERE 1=1");
        agregarFiltros(sql, params, estado, tipo, desde, hasta);
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            setParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    @Override
    public Tramite buscarPorId(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(BASE_SELECT + " WHERE t.id_tramite=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    @Override
    public boolean insertar(Tramite t) throws SQLException {
        String sql = "INSERT INTO tramites(num_expediente,id_ciudadano,tipo_tramite," +
                     "descripcion,fecha_ingreso,estado,id_usuario) VALUES(?,?,?,?,?,?,?)";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, t.getNumExpediente());
            ps.setInt(2, t.getIdCiudadano());
            ps.setString(3, t.getTipoTramite());
            ps.setString(4, t.getDescripcion());
            ps.setDate(5, Date.valueOf(t.getFechaIngreso()));
            ps.setString(6, t.getEstado());
            ps.setInt(7, t.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean actualizar(Tramite t) throws SQLException {
        String sql = "UPDATE tramites SET tipo_tramite=?,descripcion=?,estado=?,fecha_respuesta=? WHERE id_tramite=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, t.getTipoTramite());
            ps.setString(2, t.getDescripcion());
            ps.setString(3, t.getEstado());
            if (t.getFechaRespuesta() != null) ps.setDate(4, Date.valueOf(t.getFechaRespuesta()));
            else ps.setNull(4, Types.DATE);
            ps.setInt(5, t.getIdTramite());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean eliminar(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement("DELETE FROM tramites WHERE id_tramite=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Genera número de expediente: ABREV-2026-NNN */
    @Override
    public String generarNumExpediente(String tipo) throws SQLException {
        int anio = LocalDate.now().getYear();
        // Abreviatura de 4 letras según tipo
        String abrev = switch (tipo) {
            case "Licencia de Funcionamiento" -> "LICF";
            case "Licencia de Obra"           -> "LICO";
            case "Constancia de Residencia"   -> "CONS";
            case "Certificado de Numeración"  -> "CERN";
            case "Autorización de Publicidad" -> "PUBLI";
            default                            -> "TRM";
        };
        String sql = "SELECT COUNT(*) FROM tramites WHERE tipo_tramite=? AND YEAR(fecha_ingreso)=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tipo);
            ps.setInt(2, anio);
            try (ResultSet rs = ps.executeQuery()) {
                int siguiente = rs.next() ? rs.getInt(1) + 1 : 1;
                return String.format("%s-%d-%03d", abrev, anio, siguiente);
            }
        }
    }

    @Override
    public long contarPorEstado(String estado) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT COUNT(*) FROM tramites WHERE estado=?")) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        }
    }
}
