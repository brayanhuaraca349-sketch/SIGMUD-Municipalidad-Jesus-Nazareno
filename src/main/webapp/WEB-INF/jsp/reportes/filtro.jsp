<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Reportes</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:680px">
  <h5 class="fw-semibold"><i class="bi bi-file-earmark-bar-graph"></i> Reportes Parametrizados</h5><hr>
  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/app/reporte">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Módulo</label>
          <select name="modulo" id="selModulo" class="form-select">
            <option value="tramites">Trámite Documentario</option>
            <option value="pagos">Pagos de Puestos de Mercado</option>
          </select>
        </div>

        <!-- Filtros trámites -->
        <div id="filtrosTramites">
          <div class="row g-2 mb-3">
            <div class="col-md-6">
              <label class="form-label small fw-semibold">Estado</label>
              <select name="estado" class="form-select">
                <option value="">Todos</option>
                <option value="Recibido">Recibido</option>
                <option value="En proceso">En proceso</option>
                <option value="Resuelto">Resuelto</option>
                <option value="Archivado">Archivado</option>
                <option value="Vencido">Vencido</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label small fw-semibold">Tipo</label>
              <select name="tipo" class="form-select">
                <option value="">Todos</option>
                <option value="Licencia de Funcionamiento">Lic. Funcionamiento</option>
                <option value="Licencia de Obra">Lic. Obra</option>
                <option value="Constancia de Residencia">Constancia Residencia</option>
                <option value="Certificado de Numeración">Cert. Numeración</option>
                <option value="Autorización de Publicidad">Aut. Publicidad</option>
                <option value="Otros">Otros</option>
              </select>
            </div>
          </div>
          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Desde</label>
              <input type="date" name="desde" class="form-control">
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Hasta</label>
              <input type="date" name="hasta" class="form-control">
            </div>
          </div>
        </div>

        <!-- Filtros pagos -->
        <div id="filtrosPagos" class="d-none">
          <div class="row g-2 mb-3">
            <div class="col-md-6">
              <label class="form-label small fw-semibold">Período (YYYY-MM)</label>
              <input type="month" name="periodo" class="form-control">
            </div>
            <div class="col-md-6">
              <label class="form-label small fw-semibold">Estado de pago</label>
              <select name="estado" class="form-select">
                <option value="">Todos</option>
                <option value="Pagado">Pagado</option>
                <option value="Pendiente">Pendiente</option>
                <option value="Vencido">Vencido</option>
              </select>
            </div>
          </div>
        </div>

        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary">
            <i class="bi bi-search"></i> Generar
          </button>
          <button type="submit" name="exportar" value="csv" class="btn btn-outline-success">
            <i class="bi bi-download"></i> Exportar CSV
          </button>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('selModulo').addEventListener('change', function(){
  var esPagos = this.value === 'pagos';
  document.getElementById('filtrosTramites').classList.toggle('d-none', esPagos);
  document.getElementById('filtrosPagos').classList.toggle('d-none', !esPagos);
});
</script>
</body></html>
