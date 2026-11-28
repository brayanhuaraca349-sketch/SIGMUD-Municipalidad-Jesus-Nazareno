package pe.edu.lapontificia.sigmud.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import pe.edu.lapontificia.sigmud.model.Usuario;

import java.io.IOException;

@WebFilter("/app/*")
public class SesionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  hReq = (HttpServletRequest)  req;
        HttpServletResponse hRes = (HttpServletResponse) res;

        HttpSession sesion   = hReq.getSession(false);
        Usuario     usuario  = sesion != null
                ? (Usuario) sesion.getAttribute("usuarioSesion") : null;

        if (usuario == null) {
            hRes.sendRedirect(hReq.getContextPath() + "/login");
            return;
        }

        // Anti-caché
        hRes.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        hRes.setHeader("Pragma", "no-cache");
        hRes.setDateHeader("Expires", 0);

        // ── Control de acceso por rol ──────────────────────────────────
        String uri  = hReq.getRequestURI();
        String ctx  = hReq.getContextPath();
        String rol  = usuario.getRol();

        boolean permitido = switch (rol) {
            case "Administrador" -> true;   // accede a todo

            case "MesaDePartes"  ->
                uri.startsWith(ctx + "/app/inicio") ||
                uri.startsWith(ctx + "/app/tramite") ||
                uri.startsWith(ctx + "/app/api/ciudadano");

            case "JefeMercado"   ->
                uri.startsWith(ctx + "/app/inicio") ||
                uri.startsWith(ctx + "/app/mercado");

            case "Almacenero"    ->
                uri.startsWith(ctx + "/app/inicio") ||
                uri.startsWith(ctx + "/app/almacen");

            case "Reclamos"      ->
                uri.startsWith(ctx + "/app/inicio") ||
                uri.startsWith(ctx + "/app/reclamo") ||
                uri.startsWith(ctx + "/app/api/ciudadano");

            default -> false;
        };

        if (permitido) {
            chain.doFilter(req, res);
        } else {
            hRes.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }
}