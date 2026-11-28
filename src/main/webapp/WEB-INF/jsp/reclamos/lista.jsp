<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sig" uri="sigmud-tags" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Reclamos</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Reclamos y Emergencias Ciudadanas</h5>
    <a href="${pageContext.request.contextPath}/app/reclamo?op=nuevo" class="btn btn-primary btn-sm">
      <i class="bi bi-plus-lg"></i> Nuevo reclamo
    </a>
  </div>

  <!-- Filtro estado -->
  <div class="card mb-3 shadow-sm">
    <div class="card-body py-2">
      <form method="get" action="${pageContext.request.contextPath}/app/reclamo" class="row g-2 align-items-end">
        <div class="col-sm-3">
          <select name="estado" class="form-select form-select-sm">
            <option value="">Todos los estados</option>
            <option value="Recibido"   ${fEstado=='Recibido'  ?'selected':''}>Recibido</option>
            <option value="En proceso" ${fEstado=='En proceso'?'selected':''}>En proceso</option>
            <option value="Resuelto"   ${fEstado=='Resuelto'  ?'selected':''}>Resuelto</option>
            <option value="Cerrado"    ${fEstado=='Cerrado'   ?'selected':''}>Cerrado</option>
          </select>
        </div>
        <div class="col-sm-2">
          <button class="btn btn-outline-primary btn-sm">
            <i class="bi bi-search"></i> Filtrar
          </button>
        </div>
      </form>
    </div>
  </div>

  <div id="alertAjax" class="alert py-2 d-none"></div>

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
            <tr><th>#</th><th>Ciudadano</th><th>Tipo</th><th>Fecha</th><th>Responsable</th><th>Estado</th><th>Acciones</th></tr>
          </thead>
          <tbody>
            <c:forEach var="r" items="${lista}">
              <tr id="fila-${r.idReclamo}">
                <td><c:out value="${r.idReclamo}"/></td>
                <td><c:out value="${r.nombreCiudadano}"/></td>
                <td><c:out value="${r.tipo}"/></td>
                <td><c:out value="${r.fechaIngreso}"/></td>
                <td><c:out value="${not empty r.nombreResponsable ? r.nombreResponsable : '—'}"/></td>
                <td class="badge-cell"><sig:estadoBadge estado="${r.estado}"/></td>
                <td>
                  <div class="d-flex gap-1 align-items-center flex-wrap">
                    <select class="form-select form-select-sm py-0 sel-estado"
                            data-id="${r.idReclamo}" style="width:118px">
                      <option value="Recibido"   ${r.estado=='Recibido'  ?'selected':''}>Recibido</option>
                      <option value="En proceso" ${r.estado=='En proceso'?'selected':''}>En proceso</option>
                      <option value="Resuelto"   ${r.estado=='Resuelto'  ?'selected':''}>Resuelto</option>
                      <option value="Cerrado"    ${r.estado=='Cerrado'   ?'selected':''}>Cerrado</option>
                    </select>
                    <button class="btn btn-sm btn-outline-success py-0 btn-est"
                            data-id="${r.idReclamo}" title="Guardar estado">
                      <i class="bi bi-check2"></i>
                    </button>
                    <form method="post" action="${pageContext.request.contextPath}/app/reclamo"
                          class="d-inline" onsubmit="return confirm('¿Eliminar reclamo?')">
                      <input type="hidden" name="op" value="eliminar">
                      <input type="hidden" name="id"  value="${r.idReclamo}">
                      <button class="btn btn-sm btn-outline-danger py-0">
                        <i class="bi bi-trash"></i>
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty lista}">
              <tr><td colspan="7" class="text-center text-muted py-3">No hay reclamos.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
var ctx = '${pageContext.request.contextPath}';
var colores = {
  'Recibido'  : 'bg-primary',
  'En proceso': 'bg-warning text-dark',
  'Resuelto'  : 'bg-success',
  'Cerrado'   : 'bg-secondary'
};

$(document).on('click', '.btn-est', function(){
  var id  = $(this).data('id');
  var est = $('#fila-' + id + ' .sel-estado').val();
  $.ajax({
    url      : ctx + '/app/reclamo',
    type     : 'POST',
    data     : { op: 'cambiarEstado', idReclamo: id, estado: est },
    dataType : 'json',
    success  : function(r){
      if(r.ok){
        var c = colores[est] || 'bg-secondary';
        $('#fila-' + id + ' .badge-cell').html('<span class="badge ' + c + '">' + est + '</span>');
        alerta(r.msg, 'success');
      } else { alerta(r.msg, 'danger'); }
    },
    error: function(){ alerta('Error de comunicación.', 'danger'); }
  });
});

function alerta(m, t){
  $('#alertAjax').removeClass('d-none alert-success alert-danger')
    .addClass('alert-' + t).text(m);
  setTimeout(function(){ $('#alertAjax').addClass('d-none'); }, 3000);
}
</script>
</body></html>
