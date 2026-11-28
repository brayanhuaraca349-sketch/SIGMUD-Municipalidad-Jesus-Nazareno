package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.Tramite;
import java.sql.SQLException;
import java.util.List;

public interface TramiteDAO {
    List<Tramite> listar(String estado, String tipo, String desde, String hasta, int offset, int limit) throws SQLException;
    int contarFiltrado(String estado, String tipo, String desde, String hasta) throws SQLException;
    Tramite buscarPorId(int id) throws SQLException;
    boolean insertar(Tramite t) throws SQLException;
    boolean actualizar(Tramite t) throws SQLException;
    boolean eliminar(int id) throws SQLException;
    String generarNumExpediente(String tipo) throws SQLException;
    long contarPorEstado(String estado) throws SQLException;
}
