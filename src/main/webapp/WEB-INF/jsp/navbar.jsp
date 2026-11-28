<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar-sigmud">

    <!-- Identidad institucional -->
    <a class="sidebar-brand"
       href="${pageContext.request.contextPath}/app/inicio">
        <img src="${pageContext.request.contextPath}/assets/img/escudo.png"
             alt="Escudo municipal">
        <span>SIGMUD</span>
    </a>

    <div class="sidebar-section-title">MENÚ PRINCIPAL</div>

    <nav class="sidebar-menu">

        <a class="sidebar-link"
           href="${pageContext.request.contextPath}/app/inicio">
            <i class="bi bi-speedometer2"></i>
            <span>Panel principal</span>
        </a>

        <%-- Trámites: Administrador y Mesa de Partes --%>
        <c:if test="${usuarioSesion.rol == 'Administrador'
                   || usuarioSesion.rol == 'MesaDePartes'}">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/app/tramite">
                <i class="bi bi-folder2-open"></i>
                <span>Trámites</span>
            </a>
        </c:if>

        <%-- Mercado: Administrador y Jefe de Mercado --%>
        <c:if test="${usuarioSesion.rol == 'Administrador'
                   || usuarioSesion.rol == 'JefeMercado'}">
            <div class="sidebar-group">
                <button class="sidebar-link sidebar-toggle"
                        type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#submenuMercado"
                        aria-expanded="false"
                        aria-controls="submenuMercado">
                    <i class="bi bi-shop"></i>
                    <span>Mercado</span>
                    <i class="bi bi-chevron-down sidebar-chevron"></i>
                </button>
                <div class="collapse" id="submenuMercado">
                    <a class="sidebar-sublink"
                       href="${pageContext.request.contextPath}/app/mercado/puesto">
                        <i class="bi bi-shop-window"></i>
                        <span>Puestos</span>
                    </a>
                    <a class="sidebar-sublink"
                       href="${pageContext.request.contextPath}/app/mercado/pago">
                        <i class="bi bi-cash-coin"></i>
                        <span>Pagos</span>
                    </a>
                </div>
            </div>
        </c:if>

        <%-- Almacén: Administrador y Almacenero --%>
        <c:if test="${usuarioSesion.rol == 'Administrador'
                   || usuarioSesion.rol == 'Almacenero'}">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/app/almacen">
                <i class="bi bi-box-seam"></i>
                <span>Almacén</span>
            </a>
        </c:if>

        <%-- Reclamos: Administrador y Responsable de Reclamos --%>
        <c:if test="${usuarioSesion.rol == 'Administrador'
                   || usuarioSesion.rol == 'Reclamos'}">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/app/reclamo">
                <i class="bi bi-chat-left-text"></i>
                <span>Reclamos</span>
            </a>
        </c:if>

        <%-- Reportes: solo Administrador --%>
        <c:if test="${usuarioSesion.rol == 'Administrador'}">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/app/reporte">
                <i class="bi bi-bar-chart-line"></i>
                <span>Reportes</span>
            </a>
        </c:if>

        <%-- Usuarios: solo Administrador --%>
        <c:if test="${usuarioSesion.rol == 'Administrador'}">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/app/admin/usuario">
                <i class="bi bi-people"></i>
                <span>Usuarios</span>
            </a>
        </c:if>

    </nav>

    <!-- Información de sesión -->
    <div class="sidebar-bottom">
        <div class="sidebar-user">
            <div class="sidebar-user-icon">
                <i class="bi bi-person-fill"></i>
            </div>
            <div class="sidebar-user-info">
                <strong><c:out value="${usuarioSesion.nombre}"/></strong>
                <small><c:out value="${usuarioSesion.rol}"/></small>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/logout"
           class="sidebar-logout">
            <i class="bi bi-box-arrow-left"></i>
            <span>Cerrar sesión</span>
        </a>
    </div>

</aside>