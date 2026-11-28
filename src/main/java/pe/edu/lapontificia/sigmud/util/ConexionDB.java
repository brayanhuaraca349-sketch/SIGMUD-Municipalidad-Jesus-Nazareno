package pe.edu.lapontificia.sigmud.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    private static final String URL =
            "jdbc:mysql://localhost:3306/sigmud_db" +
            "?useSSL=false" +
            "&serverTimezone=America/Lima" +
            "&characterEncoding=UTF-8" +
            "&allowPublicKeyRetrieval=true";

    private static final String USUARIO = "root";
    private static final String CLAVE = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                    "Driver MySQL no encontrado: " + e.getMessage());
        }
    }

    private ConexionDB() {
    }

    public static Connection getConexion() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}   