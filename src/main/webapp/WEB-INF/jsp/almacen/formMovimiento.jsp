<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Movimiento</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:580px">
  <h5 class="fw-semibold">Registrar Movimiento de Almacén</h5><hr>
  <c:if test="${not empty error}"><div class="alert alert-danger py-2 small"><c:out value="${error}"/></div></c:if>
  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/app/almacen" id="frmMov">
        <input type="hidden" name="op" value="registrarMovimiento">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Producto *</label>
          <select name="idProducto" id="selProd" class="form-select" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="p" items="${productos}">
              <option value="${p.idProducto}" data-stock="${p.stockActual}">
                <c:out value="${p.nombre}"/> (<c:out value="${p.unidad}"/>) – Stock: <c:out value="${p.stockActual}"/>
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Tipo *</label>
          <div class="d-flex gap-3">
            <div class="form-check">
              <input class="form-check-input" type="radio" name="tipo" id="tipoE" value="E" checked>
              <label class="form-check-label text-success fw-semibold" for="tipoE">Entrada</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="tipo" id="tipoS" value="S">
              <label class="form-check-label text-danger fw-semibold" for="tipoS">Salida</label>
            </div>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Cantidad *</label>
          <input type="number" name="cantidad" id="inpCantidad" class="form-control" min="1" required>
          <div id="alertStock" class="text-danger small mt-1 d-none">⚠ Stock insuficiente para esta salida.</div>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Observación</label>
          <textarea name="observacion" class="form-control" rows="2"></textarea>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-success">Registrar</button>
          <a href="${pageContext.request.contextPath}/app/almacen" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function verificar(){
  var esSalida = document.querySelector('input[name="tipo"]:checked').value === 'S';
  var stock    = parseInt(document.getElementById('selProd').selectedOptions[0]?.dataset?.stock || 0);
  var cant     = parseInt(document.getElementById('inpCantidad').value || 0);
  document.getElementById('alertStock').classList.toggle('d-none', !(esSalida && cant > stock));
}
document.querySelectorAll('input[name="tipo"]').forEach(r => r.addEventListener('change', verificar));
document.getElementById('selProd').addEventListener('change', verificar);
document.getElementById('inpCantidad').addEventListener('input', verificar);
</script>
</body></html>
