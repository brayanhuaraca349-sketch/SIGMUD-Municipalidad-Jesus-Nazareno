package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.ReclamoDAO;
import pe.edu.lapontificia.sigmud.model.Reclamo;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReclamoDAOImpl implements ReclamoDAO {

    private Reclamo mapear(ResultSet rs) throws SQLException {
        Reclamo r = new Reclamo();
        r.setIdReclamo(rs.getInt("id_reclamo"));
        r.setIdCiudadano(rs.getInt("id_ciudadano"));
        r.setTipo(rs.getString("tipo"));
        r.setDescripcion(rs.getString("descripcion"));
        Date fi = rs.getDate("fecha_ingreso");
        if (fi != null) r.setFechaIngreso(fi.toLocalDate());
        r.setEstado(rs.getString("estado"));
        int resp = rs.getInt("id_responsable");
        if (!rs.wasNull()) r.setIdResponsable(resp);
        try { r.setNombreCiudadano(rs.getString("nombre_ciudadano")); }   catch (SQLException ignored){}
        try { r.setDniCiudadano(rs.getString("dni_ciudadano")); }         catch (SQLException ignored){}
        try { r.setNombreResponsable(rs.getString("nombre_responsable")); }catch (SQLException ignored){}
        return r;
    }

    @Override
    public List<Reclamo> listar(String estado) throws SQLException {
        List<Reclamo> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, " +
            "CONCAT(c.nombre,' ',c.apellidos) AS nombre_ciudadano, " +
            "c.dni AS dni_ciudadano, " +
            "u.nombre AS nombre_responsable " +
            "FROM reclamos r " +
            "JOIN ciudadanos c ON r.id_ciudadano = c.id_ciudadano " +
            "LEFT JOIN usuarios u ON r.id_responsable = u.id_usuario " +
            "WHERE 1=1");
        List<String> params = new ArrayList<>();
        if (estado != null && !estado.isBlank()) {
            sql.append(" AND r.estado=?");
            params.add(estado);
        }
        sql.append(" ORDER BY r.fecha_ingreso DESC");

        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setString(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public Reclamo buscarPorId(int id) throws SQLException {
        String sql = "SELECT r.*, " +
            "CONCAT(c.nombre,' ',c.apellidos) AS nombre_ciudadano, " +
            "c.dni AS dni_ciudadano, " +
            "u.nombre AS nombre_responsable " +
            "FROM reclamos r " +
            "JOIN ciudadanos c ON r.id_ciudadano = c.id_ciudadano " +
            "LEFT JOIN usuarios u ON r.id_responsable = u.id_usuario " +
            "WHERE r.id_reclamo=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    @Override
    public boolean insertar(Reclamo r) throws SQLException {
        String sql = "INSERT INTO reclamos(id_ciudadano,tipo,descripcion,estado,id_responsable) " +
                     "VALUES(?,?,?,?,?)";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, r.getIdCiudadano());
            ps.setString(2, r.getTipo());
            ps.setString(3, r.getDescripcion());
            ps.setString(4, r.getEstado() != null ? r.getEstado() : "Recibido");
            if (r.getIdResponsable() != null) ps.setInt(5, r.getIdResponsable());
            else ps.setNull(5, Types.INTEGER);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean cambiarEstado(int idReclamo, String estado) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "UPDATE reclamos SET estado=? WHERE id_reclamo=?")) {
            ps.setString(1, estado);
            ps.setInt(2, idReclamo);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean eliminar(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "DELETE FROM reclamos WHERE id_reclamo=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public long contarPendientes() throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT COUNT(*) FROM reclamos WHERE estado IN ('Recibido','En proceso')");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0;
        }
    }
}
