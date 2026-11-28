package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.Puesto;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface PuestoDAO {
    List<Puesto> listar(String estado) throws SQLException;
    Puesto buscarPorId(int id) throws SQLException;
    boolean insertar(Puesto p) throws SQLException;
    boolean actualizar(Puesto p) throws SQLException;
    boolean eliminar(int id) throws SQLException;
    boolean existeNumPuesto(String num, int excluirId) throws SQLException;
    boolean actualizarEstado(int idPuesto, String estado, Connection cn) throws SQLException;
    long contarPorEstado(String estado) throws SQLException;
}
