package pe.edu.lapontificia.sigmud.model;

import java.time.LocalDate;

public class Tramite {
    private int       idTramite;
    private String    numExpediente;
    private int       idCiudadano;
    private String    tipoTramite;
    private String    descripcion;
    private LocalDate fechaIngreso;
    private LocalDate fechaRespuesta;
    private String    estado;       // Recibido|En proceso|Resuelto|Archivado|Vencido
    private int       idUsuario;
    // JOIN fields
    private String    nombreCiudadano;
    private String    dniCiudadano;
    private String    nombreUsuario;

    public Tramite() {}

    public int       getIdTramite()             { return idTramite; }
    public void      setIdTramite(int v)         { this.idTramite = v; }
    public String    getNumExpediente()          { return numExpediente; }
    public void      setNumExpediente(String v)  { this.numExpediente = v; }
    public int       getIdCiudadano()            { return idCiudadano; }
    public void      setIdCiudadano(int v)       { this.idCiudadano = v; }
    public String    getTipoTramite()            { return tipoTramite; }
    public void      setTipoTramite(String v)    { this.tipoTramite = v; }
    public String    getDescripcion()            { return descripcion; }
    public void      setDescripcion(String v)    { this.descripcion = v; }
    public LocalDate getFechaIngreso()           { return fechaIngreso; }
    public void      setFechaIngreso(LocalDate v){ this.fechaIngreso = v; }
    public LocalDate getFechaRespuesta()         { return fechaRespuesta; }
    public void      setFechaRespuesta(LocalDate v){ this.fechaRespuesta = v; }
    public String    getEstado()                 { return estado; }
    public void      setEstado(String v)         { this.estado = v; }
    public int       getIdUsuario()              { return idUsuario; }
    public void      setIdUsuario(int v)         { this.idUsuario = v; }
    public String    getNombreCiudadano()        { return nombreCiudadano; }
    public void      setNombreCiudadano(String v){ this.nombreCiudadano = v; }
    public String    getDniCiudadano()           { return dniCiudadano; }
    public void      setDniCiudadano(String v)   { this.dniCiudadano = v; }
    public String    getNombreUsuario()          { return nombreUsuario; }
    public void      setNombreUsuario(String v)  { this.nombreUsuario = v; }
}
