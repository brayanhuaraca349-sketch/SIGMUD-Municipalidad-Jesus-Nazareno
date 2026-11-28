package pe.edu.lapontificia.sigmud.model;

import java.math.BigDecimal;

public class Puesto {
    private int        idPuesto;
    private String     numPuesto;
    private String     titular;
    private String     dniTitular;
    private String     seccion;
    private BigDecimal montoMensual;
    private String     estado;   // Activo|Suspendido|Libre
    // campo JOIN: último pago
    private String     ultimoPeriodoPagado;

    public Puesto() {}

    public int        getIdPuesto()               { return idPuesto; }
    public void       setIdPuesto(int v)           { this.idPuesto = v; }
    public String     getNumPuesto()               { return numPuesto; }
    public void       setNumPuesto(String v)        { this.numPuesto = v; }
    public String     getTitular()                 { return titular; }
    public void       setTitular(String v)          { this.titular = v; }
    public String     getDniTitular()              { return dniTitular; }
    public void       setDniTitular(String v)       { this.dniTitular = v; }
    public String     getSeccion()                 { return seccion; }
    public void       setSeccion(String v)          { this.seccion = v; }
    public BigDecimal getMontoMensual()            { return montoMensual; }
    public void       setMontoMensual(BigDecimal v) { this.montoMensual = v; }
    public String     getEstado()                  { return estado; }
    public void       setEstado(String v)           { this.estado = v; }
    public String     getUltimoPeriodoPagado()     { return ultimoPeriodoPagado; }
    public void       setUltimoPeriodoPagado(String v){ this.ultimoPeriodoPagado = v; }
}
