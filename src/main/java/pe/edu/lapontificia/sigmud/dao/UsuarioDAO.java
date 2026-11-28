package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.Usuario;
import java.sql.SQLException;
import java.util.List;

public interface UsuarioDAO {
    Usuario autenticar(String correo, String claveHash) throws SQLException;
    Usuario buscarPorCorreo(String correo) throws SQLException;
    List<Usuario> listar() throws SQLException;
    Usuario buscarPorId(int id) throws SQLException;
    boolean insertar(Usuario u) throws SQLException;
    boolean actualizar(Usuario u) throws SQLException;
    boolean desactivar(int id) throws SQLException;
    boolean incrementarIntentos(String correo) throws SQLException;
    boolean resetIntentos(String correo) throws SQLException;
    boolean desactivarPorIntentos(String correo) throws SQLException;
}
