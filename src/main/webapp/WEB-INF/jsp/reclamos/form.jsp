<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Nuevo Reclamo</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:650px">
  <h5 class="fw-semibold">Registrar Reclamo / Emergencia</h5><hr>
  <c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
  </c:if>
  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/app/reclamo">
        <input type="hidden" name="op" value="registrar">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Ciudadano *</label>
          <select name="idCiudadano" class="form-select" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="c" items="${ciudadanos}">
              <option value="${c.idCiudadano}">
                <c:out value="${c.dni}"/> – <c:out value="${c.nombreCompleto}"/>
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Tipo de reclamo *</label>
          <select name="tipo" class="form-select" required>
            <option value="">-- Seleccione --</option>
            <option value="Ruido excesivo">Ruido excesivo</option>
            <option value="Acumulación de basura">Acumulación de basura</option>
            <option value="Alumbrado público">Alumbrado público</option>
            <option value="Vía pública en mal estado">Vía pública en mal estado</option>
            <option value="Emergencia de seguridad">Emergencia de seguridad</option>
            <option value="Agua y desagüe">Agua y desagüe</option>
            <option value="Otro">Otro</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Descripción *</label>
          <textarea name="descripcion" class="form-control" rows="3" required></textarea>
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Responsable asignado</label>
          <select name="idResponsable" class="form-select">
            <option value="">-- Sin asignar --</option>
            <c:forEach var="u" items="${usuarios}">
              <option value="${u.idUsuario}">
                <c:out value="${u.nombre}"/> (<c:out value="${u.rol}"/>)
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary">Registrar</button>
          <a href="${pageContext.request.contextPath}/app/reclamo" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
