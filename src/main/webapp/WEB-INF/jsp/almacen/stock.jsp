<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Almacén</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Almacén Municipal – Stock Actual</h5>
    <div class="d-flex gap-2">
      <a href="${pageContext.request.contextPath}/app/almacen?op=nuevoMovimiento" class="btn btn-success btn-sm"><i class="bi bi-arrow-left-right"></i> Movimiento</a>
      <a href="${pageContext.request.contextPath}/app/almacen?op=movimientos"     class="btn btn-outline-secondary btn-sm"><i class="bi bi-clock-history"></i> Historial</a>
      <a href="${pageContext.request.contextPath}/app/almacen?op=nuevoProducto"   class="btn btn-primary btn-sm"><i class="bi bi-plus-lg"></i> Producto</a>
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
          <thead class="table-dark"><tr><th>Producto</th><th>Categoría</th><th>Unidad</th><th>Stock Actual</th><th>Stock Mínimo</th><th>Acciones</th></tr></thead>
          <tbody>
            <c:forEach var="p" items="${lista}">
              <tr class="${p.bajoMinimo ? 'table-danger' : ''}">
                <td class="fw-semibold"><c:out value="${p.nombre}"/>
                  <c:if test="${p.bajoMinimo}"><span class="badge bg-danger ms-1 small">¡Bajo!</span></c:if>
                </td>
                <td><c:out value="${p.categoria}"/></td>
                <td><c:out value="${p.unidad}"/></td>
                <td class="fw-bold ${p.bajoMinimo?'text-danger':''}"><c:out value="${p.stockActual}"/></td>
                <td><c:out value="${p.stockMinimo}"/></td>
                <td>
                  <a href="${pageContext.request.contextPath}/app/almacen?op=editarProducto&id=${p.idProducto}" class="btn btn-sm btn-outline-primary py-0"><i class="bi bi-pencil"></i></a>
                  <form method="post" action="${pageContext.request.contextPath}/app/almacen" class="d-inline" onsubmit="return confirm('¿Eliminar producto?')">
                    <input type="hidden" name="op" value="eliminarProducto">
                    <input type="hidden" name="id" value="${p.idProducto}">
                    <button class="btn btn-sm btn-outline-danger py-0"><i class="bi bi-trash"></i></button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty lista}"><tr><td colspan="6" class="text-center text-muted py-3">No hay productos registrados.</td></tr></c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
