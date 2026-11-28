package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.Reclamo;
import java.sql.SQLException;
import java.util.List;

public interface ReclamoDAO {
    List<Reclamo> listar(String estado) throws SQLException;
    Reclamo buscarPorId(int id) throws SQLException;
    boolean insertar(Reclamo r) throws SQLException;
    boolean cambiarEstado(int idReclamo, String estado) throws SQLException;
    boolean eliminar(int id) throws SQLException;
    long contarPendientes() throws SQLException;
}
