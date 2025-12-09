import nodemailer from "nodemailer"
import dotenv from "dotenv"
dotenv.config()

//Configuración del transportador de correo
const transporter = nodemailer.createTransport({
    service: "gmail",
    host: process.env.HOST_MAILTRAP,
    port: process.env.PORT_MAILTRAP,
    auth: {
    user: process.env.USER_MAILTRAP,
    pass: process.env.PASS_MAILTRAP,
    },
})

//Email de envío de credenciales para administrador
const sendMailWithCredentialsAdmin = async (nombreAdministrador, apellido, email, passwordGenerada) => {
  try {
    let mailOptions = {
      from: "Enfermería APP <no-reply@enfermeria-app@gmail.com>",
      to: email,
      subject: "🔐 Credenciales de Administrador - Enfermería-APP",
      html: `
        <div style="font-family: Verdana, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e0e0e0; padding: 20px; text-align: center; background-color: #fafafa;">
          <h2 style="color: #81180aff; font-weight: bold;">¡Bienvenido/a, ${nombreAdministrador}, ${apellido}!</h2>
          <p style="font-size: 16px; color: #333;">
            Se ha creado tu cuenta de <strong>Administrador</strong> en la plataforma de Enfermería.
          </p>
          <div style="background-color: white; padding: 20px; border-radius: 8px; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <p style="margin: 10px 0;"><strong>📧 Correo electrónico:</strong><br>${email}</p>
            <p style="margin: 10px 0;"><strong>🔑 Contraseña:</strong><br>
              <code style="background-color: #f5f5f5; padding: 8px 12px; border-radius: 4px; font-size: 16px; color: #D32F2F;">${passwordGenerada}</code>
            </p>
          </div>
          <p style="font-size: 14px; color: #666;">
            ⚠️ Por favor, <strong>cambia tu contraseña</strong> inmediatamente después de tu primer inicio de sesión.
          </p>
          <hr style="border: 0; border-top: 1px solid #424040ff; margin: 20px 0;">
          <footer style="font-size: 12px; color: #999;">
            <p>&copy; 2025 Enfermería APP. Todos los derechos reservados.</p>
          </footer>
        </div>
      `,
    };
    await transporter.sendMail(mailOptions);
    console.log("Correo de credenciales enviado al administrador");
  } catch (error) {
    console.error("Error enviando correo con credenciales:", error);
    throw error;
  }
};

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
    sendMailWithCredentialsAdmin,
    sendMailToRegister,
    sendMailToRecoveryPassword
}