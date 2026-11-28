package pe.edu.lapontificia.sigmud.listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * SesionListener (Sección 4.6.2):
 * Registra creación y destrucción de sesiones HTTP.
 * Usa AtomicInteger para conteo seguro en entornos concurrentes.
 */
@WebListener
public class SesionListener implements HttpSessionListener {

    private static final AtomicInteger sesionesActivas = new AtomicInteger(0);

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        int total = sesionesActivas.incrementAndGet();
        System.out.printf("[SIGMUD] Sesión creada:    %s | Activas: %d%n",
                se.getSession().getId(), total);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        int total = sesionesActivas.decrementAndGet();
        System.out.printf("[SIGMUD] Sesión destruida: %s | Activas: %d%n",
                se.getSession().getId(), total);
    }

    public static int getSesionesActivas() {
        return sesionesActivas.get();
    }
}
