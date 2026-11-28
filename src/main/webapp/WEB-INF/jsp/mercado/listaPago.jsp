<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sig" uri="sigmud-tags" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Pagos</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Pagos de Puestos de Mercado</h5>
    <a href="${pageContext.request.contextPath}/app/mercado/pago?op=nuevo" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg"></i> Registrar pago</a>
  </div>
  <!-- Filtros -->
  <div class="card mb-3 shadow-sm">
    <div class="card-body py-2">
      <form method="get" action="${pageContext.request.contextPath}/app/mercado/pago" class="row g-2 align-items-end">
        <div class="col-sm-3">
          <select name="idPuesto" class="form-select form-select-sm">
            <option value="">Todos los puestos</option>
            <c:forEach var="p" items="${puestos}">
              <option value="${p.idPuesto}" ${fIdPuesto==p.idPuesto?'selected':''}><c:out value="${p.numPuesto}"/> – <c:out value="${p.titular}"/></option>
            </c:forEach>
          </select>
        </div>
        <div class="col-sm-2"><input type="month" name="periodo" value="${fPeriodo}" class="form-control form-control-sm"></div>
        <div class="col-sm-2">
          <select name="estado" class="form-select form-select-sm">
            <option value="">Todos</option>
            <option value="Pagado"   ${fEstado=='Pagado'?'selected':''}>Pagado</option>
            <option value="Pendiente"${fEstado=='Pendiente'?'selected':''}>Pendiente</option>
            <option value="Vencido"  ${fEstado=='Vencido'?'selected':''}>Vencido</option>
          </select>
        </div>
        <div class="col-sm-2"><button class="btn btn-outline-primary btn-sm"><i class="bi bi-search"></i> Filtrar</button></div>
      </form>
    </div>
  </div>
  <div id="alertAjax" class="alert py-2 d-none"></div>
  <div class="card shadow-sm">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-sm mb-0">
          <thead class="table-dark"><tr><th>Puesto</th><th>Titular</th><th>Sección</th><th>Período</th><th>Monto</th><th>Fecha Pago</th><th>Estado</th></tr></thead>
          <tbody>
            <c:forEach var="p" items="${lista}">
              <tr>
                <td class="fw-semibold"><c:out value="${p.numPuesto}"/></td>
                <td><c:out value="${p.titularPuesto}"/></td>
                <td><c:out value="${p.seccionPuesto}"/></td>
                <td><c:out value="${p.periodo}"/></td>
                <td>S/ <c:out value="${p.monto}"/></td>
                <td><c:out value="${p.fechaPago != null ? p.fechaPago : '—'}"/></td>
                <td><sig:estadoBadge estado="${p.estado}"/></td>
              </tr>
            </c:forEach>
            <c:if test="${empty lista}"><tr><td colspan="7" class="text-center text-muted py-3">No hay pagos registrados.</td></tr></c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
