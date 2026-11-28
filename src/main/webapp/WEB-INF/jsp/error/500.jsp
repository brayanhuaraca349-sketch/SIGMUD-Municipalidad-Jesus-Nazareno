<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<title>500 – Error interno</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head><body class="bg-light d-flex align-items-center justify-content-center" style="min-height:100vh">
<div class="text-center">
  <h1 class="display-1 fw-bold text-danger">500</h1>
  <h4>Error Interno del Servidor</h4>
  <p class="text-muted">Ocurrió un error inesperado. Por favor contacte al administrador.</p>
  <c:if test="${not empty pageContext.exception}">
    <p class="text-danger small"><c:out value="${pageContext.exception.message}"/></p>
  </c:if>
  <a href="${pageContext.request.contextPath}/app/inicio" class="btn btn-primary">Ir al inicio</a>
</div></body></html>
