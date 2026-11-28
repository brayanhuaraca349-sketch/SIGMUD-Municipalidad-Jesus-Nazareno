<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SIGMUD - Iniciar Sesión</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style.css">
    
    
<style>

/* ==========================================
   SIGMUD - DISEÑO DEFINITIVO DEL LOGIN
========================================== */

/* CENTRAR TODA LA PANTALLA */
html, body {
    width: 100% !important;
    min-height: 100% !important;
    margin: 0 !important;
    padding: 0 !important;
}

body {
    overflow: hidden !important;
    font-family: 'Segoe UI', Arial, sans-serif !important;
}

/* CONTENEDOR */
.contenedor-login {
    position: relative !important;

    width: 100% !important;
    height: 100vh !important;
    min-height: 100vh !important;

    display: flex !important;
    justify-content: center !important;
    align-items: center !important;

    padding: 0 !important;
    margin: 0 !important;

    overflow: hidden !important;
}

/* IMAGEN DE FONDO */
.panel-imagen {
    position: absolute !important;
    inset: 0 !important;

    width: 100% !important;
    height: 100% !important;

    z-index: 0 !important;

    background-image: url('${pageContext.request.contextPath}/assets/img/fondo-login.png') !important;

    background-size: cover !important;
    background-position: center !important;
    background-repeat: no-repeat !important;
}

/* TARJETA DE LOGIN */
.panel-formulario {
    position: relative !important;
    z-index: 10 !important;

    width: 500px !important;
    min-height: 650px !important;
    max-height: calc(100vh - 40px) !important;

    margin: 0 auto !important;
    padding: 30px 40px !important;

    display: flex !important;
    flex-direction: column !important;
    justify-content: center !important;

    /* TRANSPARENCIA REAL */
    background: rgba(255, 255, 255, 0.16) !important;

    /* EFECTO VIDRIO */
    backdrop-filter: blur(8px) !important;
    -webkit-backdrop-filter: blur(8px) !important;

    /* BORDE */
    border: 1px solid rgba(255,255,255,0.40) !important;
    border-radius: 25px !important;

    /* SOMBRA */
    box-shadow:
        0 10px 40px rgba(0,0,0,0.18),
        inset 0 1px 2px rgba(255,255,255,0.35) !important;

    overflow-y: auto !important;
}

/* LOGOTIPO */
.panel-formulario .logo {
    width: 115px !important;
    height: 115px !important;
    object-fit: contain !important;
    display: block !important;
    margin: 0 auto 5px !important;
}

/* TÍTULO */
.panel-formulario .titulo {
    text-align: center !important;
    font-size: 2.7rem !important;
    font-weight: 800 !important;
    color: #99002e !important;
    margin: 5px 0 !important;
}

/* SUBTÍTULO */
.panel-formulario .subtitulo {
    text-align: center !important;
    font-size: 1.05rem !important;
    color: #292929 !important;
    line-height: 1.5 !important;
    margin-bottom: 22px !important;
}

/* ETIQUETAS */
.panel-formulario .form-label {
    color: #222 !important;
    font-weight: 700 !important;
    margin-bottom: 8px !important;
}

/* CAMPOS */
.panel-formulario .form-control {
    width: 100% !important;
    height: 52px !important;

    border-radius: 30px !important;

    background: rgba(255,255,255,0.38) !important;

    border: 1px solid rgba(255,255,255,0.60) !important;

    color: #111 !important;

    padding: 12px 18px !important;

    box-shadow: none !important;
}

/* CAMPOS AL SELECCIONAR */
.panel-formulario .form-control:focus {
    background: rgba(255,255,255,0.65) !important;

    border: 1px solid #99002e !important;

    box-shadow: 0 0 0 3px rgba(153,0,46,0.12) !important;
}

/* BOTÓN */
.panel-formulario .btn-login {
    width: 100% !important;
    height: 58px !important;

    border: none !important;
    border-radius: 35px !important;

    background: linear-gradient(
        100deg,
        #a00035,
        #850025
    ) !important;

    color: white !important;

    font-size: 1.1rem !important;
    font-weight: 800 !important;

    cursor: pointer !important;
    transition: 0.3s ease !important;
}

.panel-formulario .btn-login:hover {
    background: #750020 !important;
    transform: translateY(-2px) !important;
}

/* PIE DE PÁGINA */
.panel-formulario .footer-login {
    text-align: center !important;

    margin-top: 25px !important;
    padding-top: 15px !important;

    border-top: 1px solid rgba(153,0,46,0.55) !important;

    color: #333 !important;
    font-size: 0.85rem !important;
}

/* ERROR */
.panel-formulario .alert {
    border-radius: 12px !important;
}

/* TABLETS Y CELULARES */
@media (max-width: 850px) {

    body {
        overflow-y: auto !important;
    }

    .contenedor-login {
        min-height: 100vh !important;
        height: auto !important;
        padding: 20px !important;
    }

    .panel-formulario {
        width: 100% !important;
        max-width: 480px !important;
        min-height: 600px !important;
        max-height: none !important;
        padding: 30px !important;
    }
}

@media (max-width: 500px) {

    .panel-formulario {
        min-height: auto !important;
        padding: 25px 20px !important;
        border-radius: 20px !important;
        background: rgba(255,255,255,0.23) !important;
    }

    .panel-formulario .logo {
        width: 90px !important;
        height: 90px !important;
    }

    .panel-formulario .titulo {
        font-size: 2.1rem !important;
    }
}

</style>


</head>

<body>

<div class="contenedor-login">

    <div class="panel-imagen">

        <div class="overlay">

            <h1>SIGMUD</h1>

            <p>
                Sistema de Gestión Municipal Distrital
            </p>

            <p>
                Municipalidad Distrital de Jesús Nazareno
            </p>

        </div>

    </div>

    <div class="panel-formulario">

        <img src="${pageContext.request.contextPath}/assets/img/escudo.png"
             class="logo"
             alt="Escudo">

        <h2 class="titulo">
            SIGMUD
        </h2>

        <p class="subtitulo">
            Municipalidad Distrital de Jesús Nazareno
            <br>
            Ayacucho - 2026
        </p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <form method="post"
              action="${pageContext.request.contextPath}/login">

            <div class="mb-3">

                <label class="form-label">
                    Correo institucional
                </label>

                <input type="email"
                       name="correo"
                       class="form-control"
                       required
                       autofocus
                       placeholder="admin@mdjn.gob.pe">

            </div>

            <div class="mb-4">

                <label class="form-label">
                    Contraseña
                </label>

                <input type="password"
                       name="clave"
                       class="form-control"
                       required>

            </div>

            <button type="submit" class="btn-login">
                Ingresar
            </button>

        </form>

        <div class="footer-login">
            © 2026 Municipalidad Distrital de Jesús Nazareno
        </div>

    </div>

</div>

</body>
</html>