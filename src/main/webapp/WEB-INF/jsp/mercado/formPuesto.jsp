<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Puesto</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:650px">
  <h5 class="fw-semibold">${empty puesto ? 'Nuevo' : 'Editar'} Puesto</h5><hr>
  <c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
  </c:if>
  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/app/mercado/puesto" id="frm">
        <input type="hidden" name="op" value="${empty puesto ? 'registrar' : 'actualizar'}">
        <c:if test="${not empty puesto}">
          <input type="hidden" name="idPuesto" value="${puesto.idPuesto}">
        </c:if>
        <div class="row g-2">
          <div class="col-md-4 mb-2">
            <label class="form-label small fw-semibold">N° Puesto *</label>
            <input type="text" name="numPuesto" class="form-control" required
                   value="<c:out value='${puesto.numPuesto}'/>">
          </div>
          <div class="col-md-4 mb-2">
            <label class="form-label small fw-semibold">Sección</label>
            <select name="seccion" class="form-select">
              <option value="">--</option>
              <option value="Carnes"    ${puesto.seccion=='Carnes'   ?'selected':''}>Carnes</option>
              <option value="Verduras"  ${puesto.seccion=='Verduras' ?'selected':''}>Verduras</option>
              <option value="Frutas"    ${puesto.seccion=='Frutas'   ?'selected':''}>Frutas</option>
              <option value="Abarrotes" ${puesto.seccion=='Abarrotes'?'selected':''}>Abarrotes</option>
              <option value="Ropa"      ${puesto.seccion=='Ropa'     ?'selected':''}>Ropa</option>
              <option value="Calzado"   ${puesto.seccion=='Calzado'  ?'selected':''}>Calzado</option>
              <option value="Otros"     ${puesto.seccion=='Otros'    ?'selected':''}>Otros</option>
            </select>
          </div>
          <div class="col-md-4 mb-2">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select">
              <option value="Libre"      ${puesto.estado=='Libre'     ?'selected':''}>Libre</option>
              <option value="Activo"     ${puesto.estado=='Activo'    ?'selected':''}>Activo</option>
              <option value="Suspendido" ${puesto.estado=='Suspendido'?'selected':''}>Suspendido</option>
            </select>
          </div>
          <div class="col-md-6 mb-2">
            <label class="form-label small fw-semibold">Titular</label>
            <input type="text" name="titular" class="form-control"
                   value="<c:out value='${puesto.titular}'/>">
          </div>
          <div class="col-md-6 mb-2">
            <label class="form-label small fw-semibold">DNI Titular</label>
            <input type="text" name="dniTitular" id="dniT" class="form-control" maxlength="8"
                   value="<c:out value='${puesto.dniTitular}'/>">
            <div id="errDni" class="text-danger small"></div>
          </div>
          <div class="col-md-6 mb-2">
            <label class="form-label small fw-semibold">Monto Mensual (S/)</label>
            <input type="number" name="montoMensual" class="form-control"
                   step="0.01" min="0" value="<c:out value='${puesto.montoMensual}'/>">
          </div>
        </div>
        <div class="d-flex gap-2 mt-3">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <a href="${pageContext.request.contextPath}/app/mercado/puesto" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('frm').addEventListener('submit', function(e){
  var d = document.getElementById('dniT').value;
  if(d && !/^\d{8}$/.test(d)){
    e.preventDefault();
    document.getElementById('errDni').textContent = 'El DNI debe tener 8 dígitos numéricos.';
  }
});
</script>
</body></html>
