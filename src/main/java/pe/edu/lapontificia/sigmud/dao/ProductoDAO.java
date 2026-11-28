package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.Producto;
import java.sql.SQLException;
import java.util.List;

public interface ProductoDAO {
    List<Producto> listar() throws SQLException;
    Producto buscarPorId(int id) throws SQLException;
    boolean insertar(Producto p) throws SQLException;
    boolean actualizar(Producto p) throws SQLException;
    boolean eliminar(int id) throws SQLException;
    boolean actualizarStock(int idProducto, int delta) throws SQLException;
    long contarBajoMinimo() throws SQLException;
}
