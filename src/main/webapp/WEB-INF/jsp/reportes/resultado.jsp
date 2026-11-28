<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sig" uri="sigmud-tags" %>
<!DOCTYPE html><html lang="es">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>SIGMUD – Reporte</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=5">
  
  <style>
    @media print {
      .no-print { display: none !important; }
      body { font-size: 11px; }
    }
    .reporte-header {
      background: #8b1a1a;
      color: #fff;
      border-radius: .5rem .5rem 0 0;
      padding: 1.2rem 1.5rem;
    }
    .reporte-header img { width: 60px; }
    .reporte-header h4  { font-size: 1rem; margin: 0; font-weight: 700; }
    .reporte-header p   { font-size: .78rem; margin: 0; opacity: .88; }
    .reporte-meta {
      background: #f8f4f0;
      border: 1px solid #ddd;
      padding: .7rem 1.5rem;
      font-size: .82rem;
    }
    .reporte-tabla thead {
      background: #8b1a1a;
      color: #fff;
      font-size: .82rem;
    }
    .reporte-tabla tbody tr:hover { background: #fdf4f4; }
    .reporte-tabla td, .reporte-tabla th { vertical-align: middle; font-size: .82rem; }
    .reporte-footer {
      background: #f8f4f0;
      border: 1px solid #ddd;
      border-top: none;
      border-radius: 0 0 .5rem .5rem;
      padding: .6rem 1.5rem;
      font-size: .78rem;
      color: #666;
    }
    .reporte-wrap {
      border: 1px solid #ddd;
      border-radius: .5rem;
      overflow: hidden;
      box-shadow: 0 2px 12px rgba(0,0,0,.1);
    }
  </style>
</head>
<body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4 mb-5">

  <!-- Botones acción -->
  <div class="d-flex gap-2 mb-3 no-print">
    <a href="${pageContext.request.contextPath}/app/reporte" class="btn btn-outline-secondary btn-sm">
      <i class="bi bi-arrow-left"></i> Nuevo filtro
    </a>
    <form method="post" action="${pageContext.request.contextPath}/app/reporte" class="d-inline">
      <input type="hidden" name="modulo"  value="${modulo}">
      <input type="hidden" name="estado"  value="${fEstado}">
      <input type="hidden" name="desde"   value="${fDesde}">
      <input type="hidden" name="hasta"   value="${fHasta}">
      <button type="submit" name="exportar" value="csv" class="btn btn-success btn-sm">
        <i class="bi bi-file-earmark-spreadsheet"></i> Exportar Excel/CSV
      </button>
    </form>
    <button onclick="window.print()" class="btn btn-outline-primary btn-sm">
      <i class="bi bi-printer"></i> Imprimir
    </button>
  </div>

  <!-- Bloque reporte institucional -->
  <div class="reporte-wrap">

    <!-- Cabecera institucional -->
    <div class="reporte-header d-flex align-items-center gap-3">
      <img src="${pageContext.request.contextPath}/assets/img/escudo.png" alt="Escudo MDJN">
      <div>
        <h4>MUNICIPALIDAD DISTRITAL DE JESÚS NAZARENO</h4>
        <p>Huamanga – Ayacucho – Perú</p>
        <p class="mt-1 fw-semibold">
          REPORTE:
          <c:choose>
            <c:when test="${modulo=='pagos'}">PAGOS DE PUESTOS DE MERCADO</c:when>
            <c:otherwise>TRÁMITE DOCUMENTARIO</c:otherwise>
          </c:choose>
        </p>
      </div>
      <div class="ms-auto text-end" style="font-size:.78rem;opacity:.85">
        <div>Sistema: SIGMUD v3.0</div>
        <div>Generado por: <c:out value="${usuarioSesion.nombre}"/></div>
      </div>
    </div>

    <!-- Metadatos del filtro -->
    <div class="reporte-meta d-flex flex-wrap gap-4">
      <span><strong>Estado:</strong> <c:out value="${not empty fEstado ? fEstado : 'Todos'}"/></span>
      <c:if test="${modulo!='pagos'}">
        <span><strong>Desde:</strong> <c:out value="${not empty fDesde ? fDesde : '—'}"/></span>
        <span><strong>Hasta:</strong> <c:out value="${not empty fHasta ? fHasta : '—'}"/></span>
      </c:if>
      <span><strong>Total registros:</strong>
        <c:choose>
          <c:when test="${modulo=='pagos'}"><c:out value="${fn:length(listaPagos)}"/></c:when>
          <c:otherwise><c:out value="${fn:length(listaTramites)}"/></c:otherwise>
        </c:choose>
      </span>
    </div>

    <!-- Tabla trámites -->
    <c:if test="${modulo=='tramites'}">
    <div class="table-responsive">
      <table class="table table-bordered reporte-tabla mb-0">
        <thead>
          <tr>
            <th>#</th>
            <th>N° Expediente</th>
            <th>Ciudadano</th>
            <th>DNI</th>
            <th>Tipo de Trámite</th>
            <th>Fecha Ingreso</th>
            <th>Estado</th>
            <th>Funcionario</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="t" items="${listaTramites}" varStatus="st">
            <tr>
              <td class="text-muted"><c:out value="${st.count}"/></td>
              <td class="fw-semibold"><c:out value="${t.numExpediente}"/></td>
              <td><c:out value="${t.nombreCiudadano}"/></td>
              <td><c:out value="${t.dniCiudadano}"/></td>
              <td><c:out value="${t.tipoTramite}"/></td>
              <td><c:out value="${t.fechaIngreso}"/></td>
              <td><sig:estadoBadge estado="${t.estado}"/></td>
              <td><c:out value="${t.nombreUsuario}"/></td>
            </tr>
          </c:forEach>
          <c:if test="${empty listaTramites}">
            <tr><td colspan="8" class="text-center text-muted py-4">
              No se encontraron registros con los filtros aplicados.
            </td></tr>
          </c:if>
        </tbody>
      </table>
    </div>
    </c:if>

    <!-- Tabla pagos -->
    <c:if test="${modulo=='pagos'}">
    <div class="table-responsive">
      <table class="table table-bordered reporte-tabla mb-0">
        <thead>
          <tr>
            <th>#</th>
            <th>N° Puesto</th>
            <th>Titular</th>
            <th>Sección</th>
            <th>Período</th>
            <th>Monto (S/)</th>
            <th>Fecha Pago</th>
            <th>Estado</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="p" items="${listaPagos}" varStatus="st">
            <tr>
              <td class="text-muted"><c:out value="${st.count}"/></td>
              <td class="fw-semibold"><c:out value="${p.numPuesto}"/></td>
              <td><c:out value="${p.titularPuesto}"/></td>
              <td><c:out value="${p.seccionPuesto}"/></td>
              <td><c:out value="${p.periodo}"/></td>
              <td>S/ <c:out value="${p.monto}"/></td>
              <td><c:out value="${p.fechaPago != null ? p.fechaPago : '—'}"/></td>
              <td><sig:estadoBadge estado="${p.estado}"/></td>
            </tr>
          </c:forEach>
          <c:if test="${empty listaPagos}">
            <tr><td colspan="8" class="text-center text-muted py-4">
              No se encontraron registros con los filtros aplicados.
            </td></tr>
          </c:if>
        </tbody>
      </table>
    </div>
    </c:if>

    <!-- Pie del reporte -->
    <div class="reporte-footer d-flex justify-content-between">
      <span>SIGMUD – Sistema de Gestión Municipal Distrital © 2026 MDJN</span>
      <span>Documento generado electrónicamente – No requiere firma</span>
    </div>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>