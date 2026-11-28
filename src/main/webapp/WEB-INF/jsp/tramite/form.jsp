<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>SIGMUD – Trámite</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head>
<body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:720px">
  <h5 class="fw-semibold">${empty tramite ? 'Nuevo' : 'Editar'} Trámite</h5><hr>
  <c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
  </c:if>
  <div class="card shadow-sm">
    <div class="card-body">
      <!-- Búsqueda DNI Ajax (solo en nuevo) -->
      <c:if test="${empty tramite}">
      <div class="p-3 bg-light rounded border mb-3">
        <label class="form-label small fw-semibold">Buscar ciudadano por DNI</label>
        <div class="input-group input-group-sm">
          <input type="text" id="inpDni" class="form-control" maxlength="8" placeholder="8 dígitos">
          <button class="btn btn-outline-secondary" id="btnBuscar" type="button">Buscar</button>
        </div>
        <div id="msgDni" class="small mt-1"></div>
      </div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/app/tramite">
        <input type="hidden" name="op" value="${empty tramite ? 'registrar' : 'actualizar'}">
        <c:if test="${not empty tramite}">
          <input type="hidden" name="idTramite" value="${tramite.idTramite}">
        </c:if>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Ciudadano <span class="text-danger">*</span></label>
          <select name="idCiudadano" id="selCiudadano" class="form-select" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="c" items="${ciudadanos}">
              <option value="${c.idCiudadano}"
                ${not empty tramite && tramite.idCiudadano == c.idCiudadano ? 'selected' : ''}>
                <c:out value="${c.dni}"/> – <c:out value="${c.nombreCompleto}"/>
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Tipo de trámite <span class="text-danger">*</span></label>
          <select name="tipoTramite" class="form-select" required>
            <option value="">-- Seleccione --</option>
            <option value="Licencia de Funcionamiento" ${not empty tramite && tramite.tipoTramite=='Licencia de Funcionamiento'?'selected':''}>Licencia de Funcionamiento</option>
            <option value="Licencia de Obra"           ${not empty tramite && tramite.tipoTramite=='Licencia de Obra'?'selected':''}>Licencia de Obra</option>
            <option value="Constancia de Residencia"   ${not empty tramite && tramite.tipoTramite=='Constancia de Residencia'?'selected':''}>Constancia de Residencia</option>
            <option value="Certificado de Numeración"  ${not empty tramite && tramite.tipoTramite=='Certificado de Numeración'?'selected':''}>Certificado de Numeración</option>
            <option value="Autorización de Publicidad" ${not empty tramite && tramite.tipoTramite=='Autorización de Publicidad'?'selected':''}>Autorización de Publicidad</option>
            <option value="Otros"                      ${not empty tramite && tramite.tipoTramite=='Otros'?'selected':''}>Otros</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Descripción</label>
          <textarea name="descripcion" class="form-control" rows="3"><c:if test="${not empty tramite}"><c:out value="${tramite.descripcion}"/></c:if></textarea>
        </div>

        <c:if test="${not empty tramite}">
        <div class="row g-2 mb-3">
          <div class="col-md-6">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select">
              <option value="Recibido"   ${tramite.estado=='Recibido'  ?'selected':''}>Recibido</option>
              <option value="En proceso" ${tramite.estado=='En proceso'?'selected':''}>En proceso</option>
              <option value="Resuelto"   ${tramite.estado=='Resuelto'  ?'selected':''}>Resuelto</option>
              <option value="Archivado"  ${tramite.estado=='Archivado' ?'selected':''}>Archivado</option>
              <option value="Vencido"    ${tramite.estado=='Vencido'   ?'selected':''}>Vencido</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold">Fecha de respuesta</label>
            <input type="date" name="fechaRespuesta" class="form-control"
                   value="${tramite.fechaRespuesta}">
          </div>
        </div>
        </c:if>

        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <a href="${pageContext.request.contextPath}/app/tramite" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
var ctx = '${pageContext.request.contextPath}';
$('#btnBuscar').on('click', function(){
  var dni = $('#inpDni').val().trim();
  if(!/^\d{8}$/.test(dni)){
    $('#msgDni').html('<span class="text-danger">DNI debe tener 8 dígitos.</span>');
    return;
  }
  $.get(ctx+'/app/api/ciudadano', {dni: dni}, function(d){
    if(d.encontrado){
      $('#selCiudadano').val(d.idCiudadano);
      $('#msgDni').html('<span class="text-success">✔ '+d.nombreCompleto+'</span>');
    } else {
      $('#msgDni').html('<span class="text-danger">DNI no encontrado. Regístrelo primero.</span>');
    }
  }, 'json').fail(function(){
    $('#msgDni').html('<span class="text-danger">Error de red.</span>');
  });
});
</script>
</body></html>
