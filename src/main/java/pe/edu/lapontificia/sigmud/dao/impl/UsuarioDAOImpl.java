package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.UsuarioDAO;
import pe.edu.lapontificia.sigmud.model.Usuario;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAOImpl implements UsuarioDAO {

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setNombre(rs.getString("nombre"));
        u.setCorreo(rs.getString("correo"));
        u.setRol(rs.getString("rol"));
        u.setActivo(rs.getInt("activo"));
        u.setIntentosFallidos(rs.getInt("intentos_fallidos"));
        Timestamp fc = rs.getTimestamp("fecha_creacion");
        if (fc != null) u.setFechaCreacion(fc.toLocalDateTime());
        return u;
    }

    /** RF-01: autentica por correo + hash SHA2-256 */
    @Override
    public Usuario autenticar(String correo, String claveHash) throws SQLException {
        String sql = "SELECT id_usuario,nombre,correo,rol,activo,intentos_fallidos,fecha_creacion " +
                     "FROM usuarios WHERE correo=? AND contrasena=? AND activo=1";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            ps.setString(2, claveHash);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    @Override
    public List<Usuario> listar() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT id_usuario,nombre,correo,rol,activo,intentos_fallidos,fecha_creacion " +
                     "FROM usuarios ORDER BY nombre";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        return lista;
    }

    @Override
    public Usuario buscarPorId(int id) throws SQLException {
        String sql = "SELECT id_usuario,nombre,correo,rol,activo,intentos_fallidos,fecha_creacion " +
                     "FROM usuarios WHERE id_usuario=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /** Busca usuario solo por correo (sin verificar password) para control de intentos */
    public Usuario buscarPorCorreo(String correo) throws SQLException {
        String sql = "SELECT id_usuario,nombre,correo,rol,activo,intentos_fallidos,fecha_creacion " +
                     "FROM usuarios WHERE correo=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    @Override
    public boolean insertar(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuarios(nombre,correo,contrasena,rol,activo) VALUES(?,?,?,?,1)";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getCorreo());
            ps.setString(3, u.getContrasena());
            ps.setString(4, u.getRol());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean actualizar(Usuario u) throws SQLException {
        String sql = "UPDATE usuarios SET nombre=?,correo=?,rol=?,activo=? WHERE id_usuario=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getCorreo());
            ps.setString(3, u.getRol());
            ps.setInt(4, u.getActivo());
            ps.setInt(5, u.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean desactivar(int id) throws SQLException {
        String sql = "UPDATE usuarios SET activo=0 WHERE id_usuario=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** RF-01: incrementa contador de intentos fallidos */
    @Override
    public boolean incrementarIntentos(String correo) throws SQLException {
        String sql = "UPDATE usuarios SET intentos_fallidos = intentos_fallidos + 1 WHERE correo=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            return ps.executeUpdate() > 0;
        }
    }

    /** RF-01: resetea intentos tras login exitoso */
    @Override
    public boolean resetIntentos(String correo) throws SQLException {
        String sql = "UPDATE usuarios SET intentos_fallidos = 0 WHERE correo=?";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            return ps.executeUpdate() > 0;
        }
    }

    /** RF-01: desactiva cuenta tras 5 intentos fallidos */
    @Override
    public boolean desactivarPorIntentos(String correo) throws SQLException {
        String sql = "UPDATE usuarios SET activo=0 WHERE correo=? AND intentos_fallidos >= 5";
        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            return ps.executeUpdate() > 0;
        }
    }
}
