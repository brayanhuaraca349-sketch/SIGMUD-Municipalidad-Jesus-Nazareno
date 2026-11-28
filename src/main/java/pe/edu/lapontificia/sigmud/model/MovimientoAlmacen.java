package pe.edu.lapontificia.sigmud.model;

import java.time.LocalDateTime;

public class MovimientoAlmacen {
    private int           idMovimiento;
    private int           idProducto;
    private String        tipo;             // E=Entrada, S=Salida
    private int           cantidad;
    private LocalDateTime fechaMovimiento;
    private int           idUsuario;
    private String        observacion;
    // JOIN
    private String        nombreProducto;
    private String        unidadProducto;
    private String        nombreUsuario;

    public MovimientoAlmacen() {}

    public int           getIdMovimiento()          { return idMovimiento; }
    public void          setIdMovimiento(int v)      { this.idMovimiento = v; }
    public int           getIdProducto()             { return idProducto; }
    public void          setIdProducto(int v)        { this.idProducto = v; }
    public String        getTipo()                   { return tipo; }
    public void          setTipo(String v)            { this.tipo = v; }
    public int           getCantidad()               { return cantidad; }
    public void          setCantidad(int v)           { this.cantidad = v; }
    public LocalDateTime getFechaMovimiento()        { return fechaMovimiento; }
    public void          setFechaMovimiento(LocalDateTime v){ this.fechaMovimiento = v; }
    public int           getIdUsuario()              { return idUsuario; }
    public void          setIdUsuario(int v)         { this.idUsuario = v; }
    public String        getObservacion()            { return observacion; }
    public void          setObservacion(String v)    { this.observacion = v; }
    public String        getNombreProducto()         { return nombreProducto; }
    public void          setNombreProducto(String v) { this.nombreProducto = v; }
    public String        getUnidadProducto()         { return unidadProducto; }
    public void          setUnidadProducto(String v) { this.unidadProducto = v; }
    public String        getNombreUsuario()          { return nombreUsuario; }
    public void          setNombreUsuario(String v)  { this.nombreUsuario = v; }
    public String        getTipoDescripcion()        { return "E".equals(tipo) ? "Entrada" : "Salida"; }
}
