package pe.edu.lapontificia.sigmud.model;

import java.time.LocalDate;

public class Ciudadano {
    private int       idCiudadano;
    private String    dni;
    private String    nombre;
    private String    apellidos;
    private String    direccion;
    private String    telefono;
    private String    correo;
    private LocalDate fechaRegistro;

    public Ciudadano() {}

    public int       getIdCiudadano()           { return idCiudadano; }
    public void      setIdCiudadano(int v)       { this.idCiudadano = v; }
    public String    getDni()                    { return dni; }
    public void      setDni(String v)            { this.dni = v; }
    public String    getNombre()                 { return nombre; }
    public void      setNombre(String v)         { this.nombre = v; }
    public String    getApellidos()              { return apellidos; }
    public void      setApellidos(String v)      { this.apellidos = v; }
    public String    getDireccion()              { return direccion; }
    public void      setDireccion(String v)      { this.direccion = v; }
    public String    getTelefono()               { return telefono; }
    public void      setTelefono(String v)       { this.telefono = v; }
    public String    getCorreo()                 { return correo; }
    public void      setCorreo(String v)         { this.correo = v; }
    public LocalDate getFechaRegistro()          { return fechaRegistro; }
    public void      setFechaRegistro(LocalDate v){ this.fechaRegistro = v; }
    public String    getNombreCompleto()         { return nombre + " " + apellidos; }
}
