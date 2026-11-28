package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.PagoPuesto;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface PagoDAO {
    List<PagoPuesto> listar(Integer idPuesto, String periodo, String estado) throws SQLException;
    boolean insertar(PagoPuesto p, Connection cn) throws SQLException;
    boolean existePago(int idPuesto, String periodo) throws SQLException;
    long contarVencidos() throws SQLException;
}
