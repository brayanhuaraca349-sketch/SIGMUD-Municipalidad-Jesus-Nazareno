package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.MovimientoDAO;
import pe.edu.lapontificia.sigmud.model.MovimientoAlmacen;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovimientoDAOImpl implements MovimientoDAO {

    @Override
    public List<MovimientoAlmacen> listar() throws SQLException {
        List<MovimientoAlmacen> lista = new ArrayList<>();
        String sql = "SELECT m.*, p.nombre AS nombre_producto, p.unidad, " +
                     "u.nombre AS nombre_usuario " +
                     "FROM movimientos_almacen m " +
                     "JOIN productos p ON m.id_producto = p.id_producto " +
                     "JOIN usuarios  u ON m.id_usuario  = u.id_usuario " +
                     "ORDER BY m.fecha_movimiento DESC";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MovimientoAlmacen m = new MovimientoAlmacen();
                m.setIdMovimiento(rs.getInt("id_movimiento"));
                m.setIdProducto(rs.getInt("id_producto"));
                m.setTipo(rs.getString("tipo"));
                m.setCantidad(rs.getInt("cantidad"));
                Timestamp ts = rs.getTimestamp("fecha_movimiento");
                if (ts != null) m.setFechaMovimiento(ts.toLocalDateTime());
                m.setIdUsuario(rs.getInt("id_usuario"));
                m.setObservacion(rs.getString("observacion"));
                m.setNombreProducto(rs.getString("nombre_producto"));
                m.setUnidadProducto(rs.getString("unidad"));
                m.setNombreUsuario(rs.getString("nombre_usuario"));
                lista.add(m);
            }
        }
        return lista;
    }

    /**
     * RF-07: Registra movimiento con transacción explícita ACID.
     * 1) INSERT movimientos_almacen
     * 2) UPDATE stock (con verificación de stock suficiente para salidas)
     * Si falla cualquier paso → rollback.
     */
    @Override
    public boolean registrar(MovimientoAlmacen m) throws SQLException {
        String sqlInsert = "INSERT INTO movimientos_almacen" +
            "(id_producto,tipo,cantidad,fecha_movimiento,id_usuario,observacion) VALUES(?,?,?,NOW(),?,?)";
        String sqlUpdateEntrada = "UPDATE productos SET stock_actual = stock_actual + ? WHERE id_producto=?";
        String sqlUpdateSalida  = "UPDATE productos SET stock_actual = stock_actual - ? " +
                                   "WHERE id_producto=? AND stock_actual >= ?";

        Connection cn = null;
        try {
            cn = ConexionDB.getConexion();
            cn.setAutoCommit(false);

            // Paso 1: registrar movimiento
            try (PreparedStatement ps = cn.prepareStatement(sqlInsert)) {
                ps.setInt(1, m.getIdProducto());
                ps.setString(2, m.getTipo());
                ps.setInt(3, m.getCantidad());
                ps.setInt(4, m.getIdUsuario());
                ps.setString(5, m.getObservacion());
                ps.executeUpdate();
            }

            // Paso 2: ajustar stock
            int filas;
            if ("E".equals(m.getTipo())) {
                try (PreparedStatement ps = cn.prepareStatement(sqlUpdateEntrada)) {
                    ps.setInt(1, m.getCantidad());
                    ps.setInt(2, m.getIdProducto());
                    filas = ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = cn.prepareStatement(sqlUpdateSalida)) {
                    ps.setInt(1, m.getCantidad());
                    ps.setInt(2, m.getIdProducto());
                    ps.setInt(3, m.getCantidad()); // condición: stock_actual >= cantidad
                    filas = ps.executeUpdate();
                }
            }

            if (filas == 0) {
                cn.rollback(); // stock insuficiente
                return false;
            }

            cn.commit();
            return true;
        } catch (SQLException e) {
            if (cn != null) { try { cn.rollback(); } catch (SQLException ignored){} }
            throw e;
        } finally {
            if (cn != null) {
                try { cn.setAutoCommit(true); cn.close(); } catch (SQLException ignored){}
            }
        }
    }
}
