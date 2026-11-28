package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.CiudadanoDAO;
import pe.edu.lapontificia.sigmud.model.Ciudadano;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CiudadanoDAOImpl implements CiudadanoDAO {

    private Ciudadano mapear(ResultSet rs) throws SQLException {
        Ciudadano c = new Ciudadano();
        c.setIdCiudadano(rs.getInt("id_ciudadano"));
        c.setDni(rs.getString("dni"));
        c.setNombre(rs.getString("nombre"));
        c.setApellidos(rs.getString("apellidos"));
        c.setDireccion(rs.getString("direccion"));
        c.setTelefono(rs.getString("telefono"));
        c.setCorreo(rs.getString("correo"));
        Date fr = rs.getDate("fecha_registro");
        if (fr != null) c.setFechaRegistro(fr.toLocalDate());
        return c;
    }

    @Override public List<Ciudadano> listar() throws SQLException {
        List<Ciudadano> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT * FROM ciudadanos ORDER BY apellidos,nombre");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        return lista;
    }

    @Override public Ciudadano buscarPorId(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT * FROM ciudadanos WHERE id_ciudadano=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapear(rs) : null; }
        }
    }

    @Override public Ciudadano buscarPorDni(String dni) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "SELECT * FROM ciudadanos WHERE dni=?")) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? mapear(rs) : null; }
        }
    }

    @Override public boolean insertar(Ciudadano c) throws SQLException {
        String sql = "INSERT INTO ciudadanos(dni,nombre,apellidos,direccion,telefono,correo) VALUES(?,?,?,?,?,?)";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, c.getDni());
            ps.setString(2, c.getNombre());
            ps.setString(3, c.getApellidos());
            ps.setString(4, c.getDireccion());
            ps.setString(5, c.getTelefono());
            ps.setString(6, c.getCorreo());
            return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean actualizar(Ciudadano c) throws SQLException {
        String sql = "UPDATE ciudadanos SET dni=?,nombre=?,apellidos=?,direccion=?,telefono=?,correo=? WHERE id_ciudadano=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, c.getDni()); ps.setString(2, c.getNombre());
            ps.setString(3, c.getApellidos()); ps.setString(4, c.getDireccion());
            ps.setString(5, c.getTelefono()); ps.setString(6, c.getCorreo());
            ps.setInt(7, c.getIdCiudadano());
            return ps.executeUpdate() > 0;
        }
    }

    @Override public boolean eliminar(int id) throws SQLException {
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                 "DELETE FROM ciudadanos WHERE id_ciudadano=?")) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        }
    }
}
