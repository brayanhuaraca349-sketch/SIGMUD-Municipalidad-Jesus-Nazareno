package pe.edu.lapontificia.sigmud.dao.impl;

import pe.edu.lapontificia.sigmud.dao.PagoDAO;
import pe.edu.lapontificia.sigmud.model.PagoPuesto;
import pe.edu.lapontificia.sigmud.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PagoDAOImpl implements PagoDAO {

    private PagoPuesto mapear(ResultSet rs) throws SQLException {
        PagoPuesto p = new PagoPuesto();

        p.setIdPago(rs.getInt("id_pago"));
        p.setIdPuesto(rs.getInt("id_puesto"));
        p.setPeriodo(rs.getString("periodo"));
        p.setMonto(rs.getBigDecimal("monto"));

        Date fp = rs.getDate("fecha_pago");
        if (fp != null) {
            p.setFechaPago(fp.toLocalDate());
        }

        p.setEstado(rs.getString("estado"));
        p.setIdUsuario(rs.getInt("id_usuario"));

        try {
            p.setNumPuesto(rs.getString("num_puesto"));
        } catch (SQLException ignored) {
        }

        try {
            p.setTitularPuesto(rs.getString("titular"));
        } catch (SQLException ignored) {
        }

        try {
            p.setSeccionPuesto(rs.getString("seccion"));
        } catch (SQLException ignored) {
        }

        try {
            p.setNombreUsuario(rs.getString("nombre_usuario"));
        } catch (SQLException ignored) {
        }

        return p;
    }

    @Override
    public List<PagoPuesto> listar(Integer idPuesto, String periodo, String estado) throws SQLException {

        List<PagoPuesto> lista = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT pp.*, pu.num_puesto, pu.titular, pu.seccion, u.nombre AS nombre_usuario "
                + "FROM pagos_puesto pp "
                + "JOIN puestos pu ON pp.id_puesto = pu.id_puesto "
                + "JOIN usuarios u ON pp.id_usuario = u.id_usuario "
                + "WHERE 1=1"
        );

        if (idPuesto != null) {
            sql.append(" AND pp.id_puesto=?");
            params.add(idPuesto);
        }

        if (periodo != null && !periodo.isBlank()) {
            sql.append(" AND pp.periodo=?");
            params.add(periodo);
        }

        if (estado != null && !estado.isBlank()) {
            sql.append(" AND pp.estado=?");
            params.add(estado);
        }

        sql.append(" ORDER BY pp.periodo DESC, pu.num_puesto");

        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }

        return lista;
    }

    /**
     * RF-06: inserta pago dentro de una conexión transaccional provista por el Servlet.
     */
    @Override
    public boolean insertar(PagoPuesto p, Connection cn) throws SQLException {

        String sql = "INSERT INTO pagos_puesto(id_puesto,periodo,monto,fecha_pago,estado,id_usuario) VALUES(?,?,?,?,?,?)";

        try (PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, p.getIdPuesto());
            ps.setString(2, p.getPeriodo());
            ps.setBigDecimal(3, p.getMonto());

            if (p.getFechaPago() != null) {
                ps.setDate(4, Date.valueOf(p.getFechaPago()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            ps.setString(5, p.getEstado());
            ps.setInt(6, p.getIdUsuario());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean existePago(int idPuesto, String periodo) throws SQLException {

        String sql = "SELECT COUNT(*) FROM pagos_puesto WHERE id_puesto=? AND periodo=?";

        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idPuesto);
            ps.setString(2, periodo);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    @Override
    public long contarVencidos() throws SQLException {

        try (Connection cn = ConexionDB.getConexion();
             PreparedStatement ps = cn.prepareStatement(
                     "SELECT COUNT(*) FROM pagos_puesto WHERE estado='Vencido'");
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getLong(1) : 0;
        }
    }
}