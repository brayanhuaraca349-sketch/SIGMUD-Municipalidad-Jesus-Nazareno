package pe.edu.lapontificia.sigmud.dao;
import pe.edu.lapontificia.sigmud.model.MovimientoAlmacen;
import java.sql.SQLException;
import java.util.List;

public interface MovimientoDAO {
    List<MovimientoAlmacen> listar() throws SQLException;
    boolean registrar(MovimientoAlmacen m) throws SQLException; // con transacción ACID
}
