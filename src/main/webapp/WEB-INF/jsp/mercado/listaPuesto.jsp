<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sig" uri="sigmud-tags" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Puestos</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Padrón de Puestos – Mercado Municipal</h5>
    <div class="d-flex gap-2">
      <a href="${pageContext.request.contextPath}/app/mercado/pago" class="btn btn-outline-success btn-sm"><i class="bi bi-cash"></i> Pagos</a>
      <a href="${pageContext.request.contextPath}/app/mercado/puesto?op=nuevo" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg"></i> Nuevo puesto</a>
    </div>
  </div>
  <!-- RF-05: filtro por estado -->
  <div class="card mb-3 shadow-sm">
    <div class="card-body py-2">
      <form method="get" action="${pageContext.request.contextPath}/app/mercado/puesto" class="row g-2 align-items-end">
        <div class="col-sm-3">
          <select name="estado" class="form-select form-select-sm">
            <option value="">Todos los estados</option>
            <option value="Activo"     ${fEstado=='Activo'?'selected':''}>Activo</option>
            <option value="Suspendido" ${fEstado=='Suspendido'?'selected':''}>Suspendido</option>
            <option value="Libre"      ${fEstado=='Libre'?'selected':''}>Libre</option>
          </select>
        </div>
        <div class="col-sm-2"><button class="btn btn-outline-primary btn-sm"><i class="bi bi-search"></i> Filtrar</button></div>
      </form>
    </div>
  </div>
  <c:if test="${not empty param.msg}">
    <div class="alert alert-success alert-dismissible fade show py-2">Operación realizada con éxito.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>
  <div class="card shadow-sm">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-sm mb-0">
          <thead class="table-dark"><tr><th>N° Puesto</th><th>Sección</th><th>Titular</th><th>DNI</th><th>Monto/Mes</th><th>Último Pago</th><th>Estado</th><th>Acciones</th></tr></thead>
          <tbody>
            <c:forEach var="p" items="${lista}">
              <tr>
                <td class="fw-semibold"><c:out value="${p.numPuesto}"/></td>
                <td><c:out value="${p.seccion}"/></td>
                <td><c:out value="${p.titular}"/></td>
                <td><c:out value="${p.dniTitular}"/></td>
                <td>S/ <c:out value="${p.montoMensual}"/></td>
                <td><c:out value="${not empty p.ultimoPeriodoPagado ? p.ultimoPeriodoPagado : '—'}"/></td>
                <td><sig:estadoBadge estado="${p.estado}"/></td>
                <td>
                  <a href="${pageContext.request.contextPath}/app/mercado/puesto?op=editar&id=${p.idPuesto}" class="btn btn-sm btn-outline-primary py-0"><i class="bi bi-pencil"></i></a>
                  <form method="post" action="${pageContext.request.contextPath}/app/mercado/puesto" class="d-inline" onsubmit="return confirm('¿Eliminar puesto?')">
                    <input type="hidden" name="op" value="eliminar"><input type="hidden" name="id" value="${p.idPuesto}">
                    <button class="btn btn-sm btn-outline-danger py-0"><i class="bi bi-trash"></i></button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty lista}"><tr><td colspan="8" class="text-center text-muted py-3">No hay puestos registrados.</td></tr></c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
