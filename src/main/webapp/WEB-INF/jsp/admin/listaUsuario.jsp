<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>SIGMUD – Usuarios</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6">
</head><body class="bg-light">
<jsp:include page="../navbar.jsp"/>
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">Gestión de Usuarios</h5>
    <a href="${pageContext.request.contextPath}/app/admin/usuario?op=nuevo" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg"></i> Nuevo usuario</a>
  </div>
  <c:if test="${not empty param.msg}">
    <div class="alert alert-success alert-dismissible fade show py-2">Operación realizada con éxito.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>
  <div class="card shadow-sm">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-sm mb-0">
          <thead class="table-dark"><tr><th>Nombre</th><th>Correo</th><th>Rol</th><th>Activo</th><th>Intentos</th><th>Creado</th><th>Acciones</th></tr></thead>
          <tbody>
            <c:forEach var="u" items="${lista}">
              <tr class="${u.activo==0?'table-secondary':''}">
                <td><c:out value="${u.nombre}"/></td>
                <td><c:out value="${u.correo}"/></td>
                <td><span class="badge bg-primary"><c:out value="${u.rol}"/></span></td>
                <td>
                  <c:choose>
                    <c:when test="${u.activo==1}"><span class="badge bg-success">Activo</span></c:when>
                    <c:otherwise><span class="badge bg-danger">Bloqueado</span></c:otherwise>
                  </c:choose>
                </td>
                <td><span class="${u.intentosFallidos>=5?'text-danger fw-bold':''}"><c:out value="${u.intentosFallidos}"/>/5</span></td>
                <td><c:out value="${u.fechaCreacion}"/></td>
                <td>
                  <a href="${pageContext.request.contextPath}/app/admin/usuario?op=editar&id=${u.idUsuario}" class="btn btn-sm btn-outline-primary py-0"><i class="bi bi-pencil"></i></a>
                  <form method="post" action="${pageContext.request.contextPath}/app/admin/usuario" class="d-inline" onsubmit="return confirm('¿Desactivar usuario?')">
                    <input type="hidden" name="op" value="desactivar">
                    <input type="hidden" name="id" value="${u.idUsuario}">
                    <button class="btn btn-sm btn-outline-danger py-0"><i class="bi bi-person-x"></i></button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
