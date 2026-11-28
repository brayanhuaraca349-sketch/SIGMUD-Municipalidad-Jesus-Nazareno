<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>SIGMUD – Panel de Control</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS personalizado SIGMUD -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=5">

    <style>
        .dash-card {
            border: none;
            border-radius: 1rem;
            color: #ffffff !important;
            padding: 1.5rem;
            min-height: 140px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.18);
            transition: transform 0.15s;
        }
        .dash-card:hover { transform: translateY(-3px); }
        .dash-card .num  { font-size: 2.6rem; font-weight: 700; line-height: 1; color: #ffffff !important; }
        .dash-card .lbl  { font-size: 0.92rem; opacity: 0.92; color: #ffffff !important; }
        .dash-card .ico  { font-size: 2rem; opacity: 0.35; align-self: flex-end; color: #ffffff !important; }
        .dash-card a     { color: #ffffff !important; font-size: 0.8rem; text-decoration: none; opacity: 0.85; }
        .dash-card a:hover { opacity: 1; text-decoration: underline; }
        .c-gris     { background: #4a5568; }
        .c-naranja  { background: #d97706; }
        .c-rojo     { background: #dc2626; }
        .c-teal     { background: #0d9488; }
        .c-amarillo { background: #b45309; }
        .c-verde    { background: #16a34a; }
        .c-oscuro   { background: #1e293b; }
    </style>
</head>

<body class="bg-light">

    <!-- Barra / menú de navegación -->
    <jsp:include page="navbar.jsp"/>

    <!-- Panel principal con contenedor de style.css -->
    <main class="dashboard-container">

        <div class="dashboard-header">
            <div class="dashboard-label">SIGMUD</div>
            <h2 class="dashboard-title">Panel de Control</h2>
            <p class="dashboard-subtitle">
                Municipalidad Distrital de Jesús Nazareno
            </p>
        </div>

        <div class="row g-3">

            <%-- ═══ ADMINISTRADOR: ve TODO ═══ --%>
            <c:if test="${usuarioSesion.rol == 'Administrador'}">

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-gris">
                        <div>
                            <div class="num"><c:out value="${tramitesRecibidos}" default="0"/></div>
                            <div class="lbl">Trámites Recibidos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/tramite">Ver trámites →</a>
                            <i class="bi bi-inbox ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-naranja">
                        <div>
                            <div class="num"><c:out value="${tramitesEnProceso}" default="0"/></div>
                            <div class="lbl">Trámites en Proceso</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/tramite?estado=En+proceso">Ver trámites →</a>
                            <i class="bi bi-arrow-repeat ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-rojo">
                        <div>
                            <div class="num"><c:out value="${productosbajoMin}" default="0"/></div>
                            <div class="lbl">Productos Bajo Mínimo</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/almacen">Ver almacén →</a>
                            <i class="bi bi-exclamation-triangle ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-teal">
                        <div>
                            <div class="num"><c:out value="${reclamosPendientes}" default="0"/></div>
                            <div class="lbl">Reclamos Pendientes</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/reclamo">Ver reclamos →</a>
                            <i class="bi bi-chat-left-text ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-amarillo">
                        <div>
                            <div class="num"><c:out value="${pagosVencidos}" default="0"/></div>
                            <div class="lbl">Pagos Vencidos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/mercado/pago?estado=Vencido">Ver pagos →</a>
                            <i class="bi bi-currency-dollar ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-verde">
                        <div>
                            <div class="num"><c:out value="${puestosActivos}" default="0"/></div>
                            <div class="lbl">Puestos Activos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/mercado/puesto">Ver puestos →</a>
                            <i class="bi bi-shop ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="dash-card c-oscuro">
                        <div>
                            <div class="num"><c:out value="${sesionesActivas}" default="0"/></div>
                            <div class="lbl">Sesiones Activas</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <span style="font-size:.8rem;opacity:.75;">En este momento</span>
                            <i class="bi bi-people ico"></i>
                        </div>
                    </div>
                </div>

            </c:if>

            <%-- ═══ MESA DE PARTES: solo trámites ═══ --%>
            <c:if test="${usuarioSesion.rol == 'MesaDePartes'}">

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-gris">
                        <div>
                            <div class="num"><c:out value="${tramitesRecibidos}" default="0"/></div>
                            <div class="lbl">Trámites Recibidos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/tramite?estado=Recibido">Ver trámites →</a>
                            <i class="bi bi-inbox ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-naranja">
                        <div>
                            <div class="num"><c:out value="${tramitesEnProceso}" default="0"/></div>
                            <div class="lbl">Trámites en Proceso</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/tramite?estado=En+proceso">Ver trámites →</a>
                            <i class="bi bi-arrow-repeat ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-verde">
                        <div>
                            <div class="num"><c:out value="${tramitesResueltos}" default="0"/></div>
                            <div class="lbl">Trámites Resueltos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/tramite?estado=Resuelto">Ver trámites →</a>
                            <i class="bi bi-check2-circle ico"></i>
                        </div>
                    </div>
                </div>

            </c:if>

            <%-- ═══ JEFE DE MERCADO: solo mercado ═══ --%>
            <c:if test="${usuarioSesion.rol == 'JefeMercado'}">

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-verde">
                        <div>
                            <div class="num"><c:out value="${puestosActivos}" default="0"/></div>
                            <div class="lbl">Puestos Activos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                           <a href="${pageContext.request.contextPath}/app/mercado/puesto?estado=Activo">Ver puestos →</a>
                            <i class="bi bi-shop ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-amarillo">
                        <div>
                            <div class="num"><c:out value="${pagosVencidos}" default="0"/></div>
                            <div class="lbl">Pagos Vencidos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/mercado/pago?estado=Vencido">Ver pagos →</a>
                            <i class="bi bi-currency-dollar ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-oscuro">
                        <div>
                            <div class="num"><c:out value="${puestosSuspendidos}" default="0"/></div>
                            <div class="lbl">Puestos Suspendidos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/mercado/puesto?estado=Suspendido">Ver puestos →</a>
                            <i class="bi bi-shop-window ico"></i>
                        </div>
                    </div>
                </div>

            </c:if>

            <%-- ═══ ALMACENERO: solo almacén ═══ --%>
            <c:if test="${usuarioSesion.rol == 'Almacenero'}">

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-rojo">
                        <div>
                            <div class="num"><c:out value="${productosbajoMin}" default="0"/></div>
                            <div class="lbl">Productos Bajo Mínimo</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/almacen?op=stock&filtro=bajo">Ver almacén →</a>
                            <i class="bi bi-exclamation-triangle ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-verde">
                        <div>
                            <div class="num"><c:out value="${productosTotal}" default="0"/></div>
                            <div class="lbl">Total Productos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/almacen">Ver stock →</a>
                            <i class="bi bi-box-seam ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-oscuro">
                        <div>
                            <div class="num"><c:out value="${movimientosHoy}" default="0"/></div>
                            <div class="lbl">Movimientos Hoy</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/almacen?op=movimientos">Ver historial →</a>
                            <i class="bi bi-clock-history ico"></i>
                        </div>
                    </div>
                </div>

            </c:if>

            <%-- ═══ RECLAMOS: solo reclamos ═══ --%>
            <c:if test="${usuarioSesion.rol == 'Reclamos'}">

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-teal">
                        <div>
                            <div class="num"><c:out value="${reclamosPendientes}" default="0"/></div>
                            <div class="lbl">Reclamos Pendientes</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/reclamo?estado=Recibido">Ver reclamos →</a>
                            <i class="bi bi-chat-left-text ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-naranja">
                        <div>
                            <div class="num"><c:out value="${reclamosEnProceso}" default="0"/></div>
                            <div class="lbl">Reclamos en Proceso</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/reclamo?estado=En+proceso">Ver reclamos →</a>
                            <i class="bi bi-arrow-repeat ico"></i>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-lg-4">
                    <div class="dash-card c-verde">
                        <div>
                            <div class="num"><c:out value="${reclamosResueltos}" default="0"/></div>
                            <div class="lbl">Reclamos Resueltos</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-end">
                            <a href="${pageContext.request.contextPath}/app/reclamo?estado=Resuelto">Ver reclamos →</a>
                            <i class="bi bi-check2-circle ico"></i>
                        </div>
                    </div>
                </div>

            </c:if>

        </div>

        <footer class="dashboard-footer">
            Sistema de Gestión Municipal Distrital – SIGMUD
        </footer>

    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>