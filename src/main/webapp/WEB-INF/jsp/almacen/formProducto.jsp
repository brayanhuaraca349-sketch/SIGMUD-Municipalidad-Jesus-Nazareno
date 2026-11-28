<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Producto</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:520px">
  <h5 class="fw-semibold">${empty producto ? 'Nuevo' : 'Editar'} Producto</h5><hr>
  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/app/almacen">
        <input type="hidden" name="op" value="${empty producto ? 'guardarProducto' : 'actualizarProducto'}">
        <c:if test="${not empty producto}">
          <input type="hidden" name="idProducto" value="${producto.idProducto}">
        </c:if>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Nombre *</label>
          <input type="text" name="nombre" class="form-control" required
                 value="<c:out value='${producto.nombre}'/>">
        </div>
        <div class="row g-2 mb-3">
          <div class="col-6">
            <label class="form-label small fw-semibold">Unidad de medida</label>
            <input type="text" name="unidad" class="form-control"
                   placeholder="sacos, kg, unid, lt…"
                   value="<c:out value='${producto.unidad}'/>">
          </div>
          <div class="col-6">
            <label class="form-label small fw-semibold">Categoría</label>
            <select name="categoria" class="form-select">
              <option value="">--</option>
              <option value="Limpieza"     ${producto.categoria=='Limpieza'    ?'selected':''}>Limpieza</option>
              <option value="Herramientas" ${producto.categoria=='Herramientas'?'selected':''}>Herramientas</option>
              <option value="Combustible"  ${producto.categoria=='Combustible' ?'selected':''}>Combustible</option>
              <option value="Materiales"   ${producto.categoria=='Materiales'  ?'selected':''}>Materiales</option>
              <option value="Otros"        ${producto.categoria=='Otros'       ?'selected':''}>Otros</option>
            </select>
          </div>
        </div>
        <div class="row g-2 mb-3">
          <div class="col-6">
            <label class="form-label small fw-semibold">Stock Actual</label>
            <input type="number" name="stockActual" class="form-control" min="0"
                   value="${not empty producto ? producto.stockActual : 0}">
          </div>
          <div class="col-6">
            <label class="form-label small fw-semibold">Stock Mínimo</label>
            <input type="number" name="stockMinimo" class="form-control" min="0"
                   value="${not empty producto ? producto.stockMinimo : 0}">
          </div>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <a href="${pageContext.request.contextPath}/app/almacen" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
