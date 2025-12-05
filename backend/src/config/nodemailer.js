import sendMail from "../helpers/sendMail.js";

//Correo enviado al administrador para registrarse en la plataforma
const sendMailToRegisterAdmin = (userMail, token) => {
    return sendMail(
        userMail,
        "Confirmación de registro en la plataforma",
        `
            <h1>Bienvenido!</h1>
            <p>La plataforma te da una cordial bienvenida al sistema.</p>
            <p>Haz clic en el siguiente enlace para confirmar tu cuenta:</p>
            <a href="${process.env.URL_FRONTEND}login/${token}" style="padding:10px 20px; background:#28a745; color:white; text-decoration:none;">
            Confirmar cuenta
            </a>
            <p>Asegúrate de cambiar la contraseña al primer inicio de sesión.</p>
            <hr>
            <footer>2025 - Todos los derechos reservados.</footer>
        `
    )
}

//Correo enviado a los enfermeros que se registran en el sistema
const sendMailToRegister = (userMail, token) => {
    return sendMail(
        userMail,
        "Confirmación de registro en la plataforma",
        `
            <h1>Bienvenido!</h1>
            <p>La plataforma te da una cordial bienvenida al sistema.</p>
            <p>Haz clic en el siguiente enlace para confirmar tu cuenta:</p>
            <a href="${process.env.URL_FRONTEND}login/${token}" style="padding:10px 20px; background:#28a745; color:white; text-decoration:none;">
            Confirmar cuenta
            </a>
            <hr>
            <footer>2025 - Todos los derechos reservados.</footer>
        `
    )
}

const sendMailToRecoveryPassword = (userMail, token) => {

    return sendMail(
        userMail,
        "Recuperación de contraseña para la plataforma",
        `
            <h1>ENFERMERIA APP</h1>
            <p>Has solicitado restablecer tu contraseña. Sigue los pasos a continuación:</p>
            <p>Has clic en el siguiente enlace para recuperar tu contraseña:</p>
            <a href="${process.env.URL_BACKEND}recuperarpassword/${token}">
                Recuperar contraseña
            </a>
            <hr>
            <footer>2025 - Todos los derechos reservados.</footer>
        `
        )
}

export {
    sendMailToRegisterAdmin,
    sendMailToRegister,
    sendMailToRecoveryPassword
}