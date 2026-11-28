package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.PuestoDAO;
import pe.edu.lapontificia.sigmud.model.Puesto;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PuestoDAOImpl implements PuestoDAO {

    private Puesto mapear(ResultSet rs) throws SQLException {
        Puesto p = new Puesto();
        p.setIdPuesto(rs.getInt("id_puesto"));
        p.setNumPuesto(rs.getString("num_puesto"));
        p.setTitular(rs.getString("titular"));
        p.setDniTitular(rs.getString("dni_titular"));
        p.setSeccion(rs.getString("seccion"));
        p.setMontoMensual(rs.getBigDecimal("monto_mensual"));
        p.setEstado(rs.getString("estado"));
        try { p.setUltimoPeriodoPagado(rs.getString("ultimo_periodo")); } catch (SQLException ignored) {}
        return p;
    }

    @Override public List<Puesto> listar(String estado) throws SQLException {
        List<Puesto> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, " +
            "(SELECT MAX(pp.periodo) FROM pagos_puesto pp WHERE pp.id_puesto=p.id_puesto AND pp.estado='Pagado') AS ultimo_periodo " +
            "FROM puestos p WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (estado != null && !estado.isBlank()) { sql.append(" AND p.estado=?"); params.add(estado); }
        sql.append(" ORDER BY p.num_puesto");
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setString(i+1, params.get(i).toString());
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) lista.add(mapear(rs)); }
        }
        return lista;
    }

    @Override public Puesto buscarPorId(int id) throws SQLException {
        String sql = "SELECT p.*, " +
            "(SELECT MAX(pp.periodo) FROM pagos_puesto pp WHERE pp.id_puesto=p.id_puesto AND pp.estado='Pagado') AS ultimo_periodo " +
            "FROM puestos p WHERE p.id_puesto=?";
        try (Connection cn = ConexionDB.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapear(rs) : null; }
        }
    }

    @Override public boolean insertar(Puesto p) throws SQLException {
        String sql = "INSERT INTO puestos(num_puesto,titular,dni_titular,seccion,monto_mensual,estado) VALUES(?,?,?,?,?,?)";
        try (Connection cn = ConexionDB.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, p.getNumPuesto()); ps.setString(2, p.getTitular());
            ps.setString(3, p.getDniTitular()); ps.setString(4, p.getSeccion());
            ps.setBigDecimal(5, p.getMontoMensual()); ps.setString(6, p.getEstado());
            return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean actualizar(Puesto p) throws SQLException {
        String sql = "UPDATE puestos SET num_puesto=?,titular=?,dni_titular=?,seccion=?,monto_mensual=?,estado=? WHERE id_puesto=?";
        try (Connection cn = ConexionDB.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, p.getNumPuesto()); ps.setString(2, p.getTitular());
            ps.setString(3, p.getDniTitular()); ps.setString(4, p.getSeccion());
            ps.setBigDecimal(5, p.getMontoMensual()); ps.setString(6, p.getEstado());
            ps.setInt(7, p.getIdPuesto());
            return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean eliminar(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement("DELETE FROM puestos WHERE id_puesto=?")) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean existeNumPuesto(String num, int excluirId) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT COUNT(*) FROM puestos WHERE num_puesto=? AND id_puesto<>?")) {
            ps.setString(1, num); ps.setInt(2, excluirId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() && rs.getInt(1) > 0; }
        }
    }

    /** Usado dentro de transacción de pago */
    @Override public boolean actualizarEstado(int idPuesto, String estado, Connection cn) throws SQLException {
        try (PreparedStatement ps = cn.prepareStatement(
                 "UPDATE puestos SET estado=? WHERE id_puesto=?")) {
            ps.setString(1, estado); ps.setInt(2, idPuesto);
            return ps.executeUpdate() > 0;
        }
    }

    @Override public long contarPorEstado(String estado) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT COUNT(*) FROM puestos WHERE estado=?")) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getLong(1) : 0; }
        }
    }
}
