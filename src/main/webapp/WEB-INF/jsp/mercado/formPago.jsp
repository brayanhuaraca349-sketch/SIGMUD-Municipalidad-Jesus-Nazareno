<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Registrar Pago</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:580px">
  <h5 class="fw-semibold">Registrar Pago de Puesto</h5><hr>
  <div id="alertMsg" class="alert py-2 d-none"></div>
  <div class="card shadow-sm">
    <div class="card-body">
      <form id="frmPago">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Puesto *</label>
          <select id="selPuesto" name="idPuesto" class="form-select" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="p" items="${puestos}">
              <option value="${p.idPuesto}" data-monto="${p.montoMensual}">
                <c:out value="${p.numPuesto}"/> – <c:out value="${p.titular}"/>
                (<c:out value="${p.seccion}"/>)
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Período (YYYY-MM) *</label>
          <input type="month" id="inpPeriodo" name="periodo" class="form-control" required>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Monto (S/) *</label>
          <input type="number" id="inpMonto" name="monto" class="form-control"
                 step="0.01" min="0.01" required>
          <div class="form-text">Se auto-completa con el monto mensual del puesto.</div>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Fecha de Pago</label>
          <input type="date" id="inpFecha" name="fechaPago" class="form-control">
        </div>
        <div class="d-flex gap-2">
          <button type="submit" id="btnGuardar" class="btn btn-success">
            <span id="spinner" class="spinner-border spinner-border-sm d-none me-1"></span>
            Registrar Pago
          </button>
          <a href="${pageContext.request.contextPath}/app/mercado/pago" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
var ctx = '${pageContext.request.contextPath}';

// Auto-completar monto desde el puesto seleccionado
$('#selPuesto').on('change', function(){
  var monto = $(this).find(':selected').data('monto');
  if(monto) $('#inpMonto').val(monto);
});

// Poner fecha de hoy por defecto
var hoy = new Date().toISOString().split('T')[0];
$('#inpFecha').val(hoy);

// Submit via Ajax (RF-06 transacción en servidor)
$('#frmPago').on('submit', function(e){
  e.preventDefault();
  $('#btnGuardar').prop('disabled', true);
  $('#spinner').removeClass('d-none');
  $('#alertMsg').addClass('d-none');

  $.ajax({
    url: ctx + '/app/mercado/pago',
    type: 'POST',
    data: $(this).serialize() + '&op=registrar',
    dataType: 'json',
    success: function(resp){
      if(resp.ok){
        mostrarAlerta(resp.msg, 'success');
        $('#frmPago')[0].reset();
        // Redirigir después de 1.5s
        setTimeout(function(){ window.location.href = ctx+'/app/mercado/pago?msg=ok'; }, 1500);
      } else {
        mostrarAlerta(resp.msg, 'danger');
        $('#btnGuardar').prop('disabled', false);
        $('#spinner').addClass('d-none');
      }
    },
    error: function(){
      mostrarAlerta('Error de comunicación con el servidor.', 'danger');
      $('#btnGuardar').prop('disabled', false);
      $('#spinner').addClass('d-none');
    }
  });
});

function mostrarAlerta(msg, tipo){
  $('#alertMsg').removeClass('d-none alert-success alert-danger')
    .addClass('alert-'+tipo).text(msg);
}
</script>
</body></html>
