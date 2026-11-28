package pe.edu.lapontificia.sigmud.tags;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

/**
 * Custom Tag que genera un badge Bootstrap 5 según el estado
 * de un trámite, pago o reclamo.
 * Uso en JSP: &lt;sig:estadoBadge estado="${t.estado}"/&gt;
 */
public class EstadoBadgeTag extends SimpleTagSupport {

    private String estado;

    public void setEstado(String estado) {
        this.estado = estado;
    }

    @Override
    public void doTag() throws JspException, IOException {
        String e = (estado == null) ? "" : estado;
        String css = switch (e) {
            case "Recibido"              -> "primary";
            case "En proceso"            -> "warning text-dark";
            case "Resuelto", "Pagado"    -> "success";
            case "Archivado", "Cerrado"  -> "secondary";
            case "Vencido", "Pendiente"  -> "danger";
            default                       -> "light text-dark";
        };
        // XSS-safe: estado viene de BD, no de input usuario, pero escapamos igualmente
        String textoSafe = e.replace("<", "&lt;").replace(">", "&gt;");
        getJspContext().getOut().write(
            "<span class=\"badge bg-" + css + "\">" + textoSafe + "</span>"
        );
    }
}
