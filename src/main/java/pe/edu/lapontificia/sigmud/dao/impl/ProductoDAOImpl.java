package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.ProductoDAO;
import pe.edu.lapontificia.sigmud.model.Producto;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAOImpl implements ProductoDAO {

    private Producto mapear(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto(rs.getInt("id_producto"));
        p.setNombre(rs.getString("nombre"));
        p.setUnidad(rs.getString("unidad"));
        p.setStockActual(rs.getInt("stock_actual"));
        p.setStockMinimo(rs.getInt("stock_minimo"));
        p.setCategoria(rs.getString("categoria"));
        return p;
    }

    @Override public List<Producto> listar() throws SQLException {
        List<Producto> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement("SELECT * FROM productos ORDER BY nombre");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        return lista;
    }

    @Override public Producto buscarPorId(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement("SELECT * FROM productos WHERE id_producto=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapear(rs) : null; }
        }
    }

    @Override public boolean insertar(Producto p) throws SQLException {
        String sql = "INSERT INTO productos(nombre,unidad,stock_actual,stock_minimo,categoria) VALUES(?,?,?,?,?)";
        try (Connection cn = ConexionDB.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, p.getNombre()); ps.setString(2, p.getUnidad());
            ps.setInt(3, p.getStockActual()); ps.setInt(4, p.getStockMinimo());
            ps.setString(5, p.getCategoria());
            return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean actualizar(Producto p) throws SQLException {
        String sql = "UPDATE productos SET nombre=?,unidad=?,stock_actual=?,stock_minimo=?,categoria=? WHERE id_producto=?";
        try (Connection cn = ConexionDB.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, p.getNombre()); ps.setString(2, p.getUnidad());
            ps.setInt(3, p.getStockActual()); ps.setInt(4, p.getStockMinimo());
            ps.setString(5, p.getCategoria()); ps.setInt(6, p.getIdProducto());
            return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean eliminar(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement("DELETE FROM productos WHERE id_producto=?")) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        }
    }

    /** Ajusta stock: delta > 0 = entrada, delta < 0 = salida */
    @Override public boolean actualizarStock(int idProducto, int delta) throws SQLException {
        String sql = (delta < 0)
            ? "UPDATE productos SET stock_actual = stock_actual + ? WHERE id_producto=? AND stock_actual >= ?"
            : "UPDATE productos SET stock_actual = stock_actual + ? WHERE id_producto=?";
        try (Connection cn = ConexionDB.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, delta); ps.setInt(2, idProducto);
            if (delta < 0) ps.setInt(3, Math.abs(delta));
            return ps.executeUpdate() > 0;
        }
    }

    @Override public long contarBajoMinimo() throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT COUNT(*) FROM productos WHERE stock_actual <= stock_minimo");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0;
        }
    }
}
