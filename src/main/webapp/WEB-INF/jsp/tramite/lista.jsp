<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sig" uri="sigmud-tags" %>
<!DOCTYPE html><html lang="es">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>SIGMUD – Trámites</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head>
<body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Trámite Documentario</h5>
    <a href="${pageContext.request.contextPath}/app/tramite?op=nuevo" class="btn btn-primary btn-sm">
      <i class="bi bi-plus-lg"></i> Nuevo trámite
    </a>
  </div>

  <!-- RF-03: Filtros -->
  <div class="card mb-3 shadow-sm">
    <div class="card-body py-2">
      <form method="get" action="${pageContext.request.contextPath}/app/tramite" class="row g-2 align-items-end">
        <div class="col-sm-3">
          <label class="form-label small mb-1">Estado</label>
          <select name="estado" class="form-select form-select-sm">
            <option value="">Todos</option>
            <option value="Recibido"   ${fEstado=='Recibido'   ?'selected':''}>Recibido</option>
            <option value="En proceso" ${fEstado=='En proceso' ?'selected':''}>En proceso</option>
            <option value="Resuelto"   ${fEstado=='Resuelto'   ?'selected':''}>Resuelto</option>
            <option value="Archivado"  ${fEstado=='Archivado'  ?'selected':''}>Archivado</option>
            <option value="Vencido"    ${fEstado=='Vencido'    ?'selected':''}>Vencido</option>
          </select>
        </div>
        <div class="col-sm-3">
          <label class="form-label small mb-1">Tipo</label>
          <select name="tipo" class="form-select form-select-sm">
            <option value="">Todos</option>
            <option value="Licencia de Funcionamiento" ${fTipo=='Licencia de Funcionamiento'?'selected':''}>Lic. Funcionamiento</option>
            <option value="Licencia de Obra"           ${fTipo=='Licencia de Obra'?'selected':''}>Lic. Obra</option>
            <option value="Constancia de Residencia"   ${fTipo=='Constancia de Residencia'?'selected':''}>Constancia Residencia</option>
            <option value="Certificado de Numeración"  ${fTipo=='Certificado de Numeración'?'selected':''}>Cert. Numeración</option>
            <option value="Autorización de Publicidad" ${fTipo=='Autorización de Publicidad'?'selected':''}>Aut. Publicidad</option>
            <option value="Otros"                      ${fTipo=='Otros'?'selected':''}>Otros</option>
          </select>
        </div>
        <div class="col-sm-2">
          <label class="form-label small mb-1">Desde</label>
          <input type="date" name="desde" value="${fDesde}" class="form-control form-control-sm">
        </div>
        <div class="col-sm-2">
          <label class="form-label small mb-1">Hasta</label>
          <input type="date" name="hasta" value="${fHasta}" class="form-control form-control-sm">
        </div>
        <div class="col-sm-2">
          <button class="btn btn-outline-primary btn-sm w-100">
            <i class="bi bi-search"></i> Buscar
          </button>
        </div>
      </form>
    </div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert alert-success alert-dismissible fade show py-2">
      Operación realizada con éxito.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <div class="card shadow-sm">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-sm mb-0">
          <thead class="table-dark">
            <tr>
              <th>N° Expediente</th><th>Ciudadano</th><th>DNI</th>
              <th>Tipo</th><th>Fecha</th><th>Estado</th><th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="t" items="${lista}">
              <tr>
                <td class="fw-semibold"><c:out value="${t.numExpediente}"/></td>
                <td><c:out value="${t.nombreCiudadano}"/></td>
                <td><c:out value="${t.dniCiudadano}"/></td>
                <td><c:out value="${t.tipoTramite}"/></td>
                <td><c:out value="${t.fechaIngreso}"/></td>
                <td><sig:estadoBadge estado="${t.estado}"/></td>
                <td>
                  <a href="${pageContext.request.contextPath}/app/tramite?op=editar&id=${t.idTramite}"
                     class="btn btn-sm btn-outline-primary py-0">
                    <i class="bi bi-pencil"></i>
                  </a>
                  <form method="post" action="${pageContext.request.contextPath}/app/tramite"
                        class="d-inline" onsubmit="return confirm('¿Eliminar trámite?')">
                    <input type="hidden" name="op" value="eliminar">
                    <input type="hidden" name="id" value="${t.idTramite}">
                    <button class="btn btn-sm btn-outline-danger py-0">
                      <i class="bi bi-trash"></i>
                    </button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty lista}">
              <tr><td colspan="7" class="text-center text-muted py-3">No se encontraron registros.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Paginación -->
  <c:if test="${pag.totalPaginas > 1}">
    <nav class="mt-3">
      <ul class="pagination pagination-sm justify-content-center mb-1">
        <li class="page-item ${!pag.hayAnterior()?'disabled':''}">
          <a class="page-link" href="?pagina=${pag.paginaActual-1}&estado=${fEstado}&tipo=${fTipo}&desde=${fDesde}&hasta=${fHasta}">‹</a>
        </li>
        <c:forEach begin="1" end="${pag.totalPaginas}" var="i">
          <li class="page-item ${i==pag.paginaActual?'active':''}">
            <a class="page-link" href="?pagina=${i}&estado=${fEstado}&tipo=${fTipo}&desde=${fDesde}&hasta=${fHasta}">
              <c:out value="${i}"/>
            </a>
          </li>
        </c:forEach>
        <li class="page-item ${!pag.haysiguiente()?'disabled':''}">
          <a class="page-link" href="?pagina=${pag.paginaActual+1}&estado=${fEstado}&tipo=${fTipo}&desde=${fDesde}&hasta=${fHasta}">›</a>
        </li>
      </ul>
      <p class="text-center text-muted small">
        Total: <c:out value="${pag.totalRegistros}"/> registros
      </p>
    </nav>
  </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
