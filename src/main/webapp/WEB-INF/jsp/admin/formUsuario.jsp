<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Usuario</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4" style="max-width:540px">
  <h5 class="fw-semibold">${empty usuario ? 'Nuevo' : 'Editar'} Usuario</h5><hr>
  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/app/admin/usuario">
        <input type="hidden" name="op" value="${empty usuario ? 'registrar' : 'actualizar'}">
        <c:if test="${not empty usuario}">
          <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">
        </c:if>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Nombre completo *</label>
          <input type="text" name="nombre" class="form-control" required value="<c:out value='${usuario.nombre}'/>">
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Correo institucional *</label>
          <input type="email" name="correo" class="form-control" required value="<c:out value='${usuario.correo}'/>">
        </div>
        <c:if test="${empty usuario}">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Contraseña *</label>
          <input type="password" name="contrasena" class="form-control" required minlength="6">
        </div>
        </c:if>
        <div class="mb-3">
          <label class="form-label small fw-semibold">Rol *</label>
          <select name="rol" class="form-select" required>
            <option value="Administrador" ${usuario.rol=='Administrador'?'selected':''}>Administrador</option>
            <option value="MesaDePartes"  ${usuario.rol=='MesaDePartes' ?'selected':''}>Mesa de Partes</option>
            <option value="JefeMercado"   ${usuario.rol=='JefeMercado'  ?'selected':''}>Jefe de Mercado</option>
            <option value="Almacenero"    ${usuario.rol=='Almacenero'   ?'selected':''}>Almacenero</option>
            <option value="Reclamos"      ${usuario.rol=='Reclamos'     ?'selected':''}>Responsable Reclamos</option>
          </select>
        </div>
        <c:if test="${not empty usuario}">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Estado</label>
          <select name="activo" class="form-select">
            <option value="1" ${usuario.activo==1?'selected':''}>Activo</option>
            <option value="0" ${usuario.activo==0?'selected':''}>Bloqueado</option>
          </select>
        </div>
        </c:if>
        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <a href="${pageContext.request.contextPath}/app/admin/usuario" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
