package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.Ciudadano;
import java.sql.SQLException;
import java.util.List;

public interface CiudadanoDAO {
    List<Ciudadano> listar() throws SQLException;
    Ciudadano buscarPorId(int id) throws SQLException;
    Ciudadano buscarPorDni(String dni) throws SQLException;
    boolean insertar(Ciudadano c) throws SQLException;
    boolean actualizar(Ciudadano c) throws SQLException;
    boolean eliminar(int id) throws SQLException;
}
