<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Historial Almacén</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Historial de Movimientos de Almacén</h5>
    <div class="d-flex gap-2">
      <a href="${pageContext.request.contextPath}/app/almacen?op=nuevoMovimiento" class="btn btn-success btn-sm"><i class="bi bi-plus-lg"></i> Registrar</a>
      <a href="${pageContext.request.contextPath}/app/almacen" class="btn btn-outline-secondary btn-sm"><i class="bi bi-box-seam"></i> Ver Stock</a>
    </div>
  </div>
  <div class="card shadow-sm">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-sm mb-0">
          <thead class="table-dark"><tr><th>Fecha</th><th>Producto</th><th>Unidad</th><th>Tipo</th><th>Cantidad</th><th>Responsable</th><th>Observación</th></tr></thead>
          <tbody>
            <c:forEach var="m" items="${lista}">
              <tr>
                <td><c:out value="${m.fechaMovimiento}"/></td>
                <td><c:out value="${m.nombreProducto}"/></td>
                <td><c:out value="${m.unidadProducto}"/></td>
                <td>
                  <c:choose>
                    <c:when test="${m.tipo=='E'}"><span class="badge bg-success">Entrada</span></c:when>
                    <c:otherwise><span class="badge bg-danger">Salida</span></c:otherwise>
                  </c:choose>
                </td>
                <td class="fw-semibold"><c:out value="${m.cantidad}"/></td>
                <td><c:out value="${m.nombreUsuario}"/></td>
                <td><c:out value="${m.observacion}"/></td>
              </tr>
            </c:forEach>
            <c:if test="${empty lista}"><tr><td colspan="7" class="text-center text-muted py-3">No hay movimientos.</td></tr></c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
