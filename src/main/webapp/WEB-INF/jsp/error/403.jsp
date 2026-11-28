<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<title>403 – Acceso denegado</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head><body class="bg-light d-flex align-items-center justify-content-center" style="min-height:100vh">
<div class="text-center">
  <h1 class="display-1 fw-bold text-danger">403</h1>
  <h4>Acceso Denegado</h4>
  <p class="text-muted">No tiene permisos para acceder a este recurso.</p>
  <a href="${pageContext.request.contextPath}/app/inicio" class="btn btn-primary">Ir al inicio</a>
</div></body></html>
