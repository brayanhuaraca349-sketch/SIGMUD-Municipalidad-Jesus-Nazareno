package pe.edu.lapontificia.sigmud.model;

import java.time.LocalDate;

public class Reclamo {
    private int       idReclamo;
    private int       idCiudadano;
    private String    tipo;
    private String    descripcion;
    private LocalDate fechaIngreso;
    private String    estado;         // Recibido|En proceso|Resuelto|Cerrado
    private Integer   idResponsable;
    // JOIN
    private String    nombreCiudadano;
    private String    dniCiudadano;
    private String    nombreResponsable;

    public Reclamo() {}

    public int     getIdReclamo()              { return idReclamo; }
    public void    setIdReclamo(int v)          { this.idReclamo = v; }
    public int     getIdCiudadano()             { return idCiudadano; }
    public void    setIdCiudadano(int v)        { this.idCiudadano = v; }
    public String  getTipo()                    { return tipo; }
    public void    setTipo(String v)             { this.tipo = v; }
    public String  getDescripcion()             { return descripcion; }
    public void    setDescripcion(String v)     { this.descripcion = v; }
    public LocalDate getFechaIngreso()          { return fechaIngreso; }
    public void    setFechaIngreso(LocalDate v) { this.fechaIngreso = v; }
    public String  getEstado()                  { return estado; }
    public void    setEstado(String v)           { this.estado = v; }
    public Integer getIdResponsable()           { return idResponsable; }
    public void    setIdResponsable(Integer v)  { this.idResponsable = v; }
    public String  getNombreCiudadano()         { return nombreCiudadano; }
    public void    setNombreCiudadano(String v) { this.nombreCiudadano = v; }
    public String  getDniCiudadano()            { return dniCiudadano; }
    public void    setDniCiudadano(String v)    { this.dniCiudadano = v; }
    public String  getNombreResponsable()       { return nombreResponsable; }
    public void    setNombreResponsable(String v){ this.nombreResponsable = v; }
}
