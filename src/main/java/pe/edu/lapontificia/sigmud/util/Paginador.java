package pe.edu.lapontificia.sigmud.util;

/**
 * Calcula los parámetros de paginación (RNF-03: 20 registros por página).
 */
public class Paginador {

    public static final int REGISTROS_POR_PAGINA = 20;

    private final int totalRegistros;
    private final int paginaActual;
    private final int totalPaginas;
    private final int offset;

    public Paginador(int totalRegistros, int paginaActual) {
        this.totalRegistros = totalRegistros;
        this.paginaActual   = Math.max(1, paginaActual);
        this.totalPaginas   = (int) Math.ceil((double) totalRegistros / REGISTROS_POR_PAGINA);
        this.offset         = (this.paginaActual - 1) * REGISTROS_POR_PAGINA;
    }

    public int getTotalRegistros()  { return totalRegistros; }
    public int getPaginaActual()    { return paginaActual; }
    public int getTotalPaginas()    { return totalPaginas; }
    public int getOffset()          { return offset; }
    public int getRegistrosPorPagina() { return REGISTROS_POR_PAGINA; }
    public boolean hayAnterior()    { return paginaActual > 1; }
    public boolean haysiguiente()   { return paginaActual < totalPaginas; }
}
