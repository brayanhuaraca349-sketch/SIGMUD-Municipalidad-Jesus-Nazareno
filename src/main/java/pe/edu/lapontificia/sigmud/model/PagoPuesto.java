package pe.edu.lapontificia.sigmud.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class PagoPuesto {
    private int        idPago;
    private int        idPuesto;
    private String     periodo;     // YYYY-MM
    private BigDecimal monto;
    private LocalDate  fechaPago;
    private String     estado;      // Pagado|Pendiente|Vencido
    private int        idUsuario;
    // JOIN fields
    private String     numPuesto;
    private String     titularPuesto;
    private String     seccionPuesto;
    private String     nombreUsuario;

    public PagoPuesto() {}

    public int        getIdPago()              { return idPago; }
    public void       setIdPago(int v)          { this.idPago = v; }
    public int        getIdPuesto()             { return idPuesto; }
    public void       setIdPuesto(int v)        { this.idPuesto = v; }
    public String     getPeriodo()              { return periodo; }
    public void       setPeriodo(String v)       { this.periodo = v; }
    public BigDecimal getMonto()                { return monto; }
    public void       setMonto(BigDecimal v)    { this.monto = v; }
    public LocalDate  getFechaPago()            { return fechaPago; }
    public void       setFechaPago(LocalDate v) { this.fechaPago = v; }
    public String     getEstado()               { return estado; }
    public void       setEstado(String v)        { this.estado = v; }
    public int        getIdUsuario()            { return idUsuario; }
    public void       setIdUsuario(int v)       { this.idUsuario = v; }
    public String     getNumPuesto()            { return numPuesto; }
    public void       setNumPuesto(String v)     { this.numPuesto = v; }
    public String     getTitularPuesto()        { return titularPuesto; }
    public void       setTitularPuesto(String v) { this.titularPuesto = v; }
    public String     getSeccionPuesto()        { return seccionPuesto; }
    public void       setSeccionPuesto(String v) { this.seccionPuesto = v; }
    public String     getNombreUsuario()        { return nombreUsuario; }
    public void       setNombreUsuario(String v) { this.nombreUsuario = v; }
}
