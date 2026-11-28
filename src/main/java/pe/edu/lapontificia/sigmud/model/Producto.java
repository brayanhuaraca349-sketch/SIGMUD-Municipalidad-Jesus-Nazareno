package pe.edu.lapontificia.sigmud.model;

public class Producto {
    private int    idProducto;
    private String nombre;
    private String unidad;
    private int    stockActual;
    private int    stockMinimo;
    private String categoria;

    public Producto() {}

    public int    getIdProducto()           { return idProducto; }
    public void   setIdProducto(int v)      { this.idProducto = v; }
    public String getNombre()               { return nombre; }
    public void   setNombre(String v)       { this.nombre = v; }
    public String getUnidad()               { return unidad; }
    public void   setUnidad(String v)       { this.unidad = v; }
    public int    getStockActual()          { return stockActual; }
    public void   setStockActual(int v)     { this.stockActual = v; }
    public int    getStockMinimo()          { return stockMinimo; }
    public void   setStockMinimo(int v)     { this.stockMinimo = v; }
    public String getCategoria()            { return categoria; }
    public void   setCategoria(String v)    { this.categoria = v; }
    public boolean isBajoMinimo()           { return stockActual <= stockMinimo; }
}
