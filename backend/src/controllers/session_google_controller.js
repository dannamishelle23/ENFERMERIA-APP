import Enfermero from "../models/Enfermero.js";
import Usuario from "../models/Usuario.js";
import Administrador from "../models/Administrador.js";
import { crearTokenJWT } from "../middlewares/JWT.js";

// Función para el inicio de sesión de un enfermero mediante OAuth
const loginOAuthEnfermero = async (req, res) => {
  const { email, nombre, provider } = req.body;
  try {
    // Validación para permitir solo cuentas institucionales de EPN
    if (provider === "gmail" && !email.endsWith("@gmail.com")) {
      return res.status(403).json({ msg: "Ingrese un correo válido" });
    }
    // Buscar estudiante por email
    let enfermero = await Enfermero.findOne({ emailEnfermero: email });
    if (!estudiante) {
      // Registro automático de enfermero si no existe (sin contraseña porque es OAuth)
      enfermero = new Enfermero({
        nombreEnfermero: nombre,
        emailEnfermero: email,
        password: "", // vacío porque es OAuth
        isOAuth: true,
        oauthProvider: provider,
        confirmEmail: true // Validación de que el correo es confiable
      });
      await enfermero.save();
    }
    // Creación de token con el middleware
    const token = crearTokenJWT(enfermero._id, enfermero.rol);
    res.json({ token, usuario: enfermero });
  } catch (error) {
    res.status(500).json({ msg: "Error en autenticación OAuth", error });
  }
};

// Función para el inicio de sesión de un cliente mediante OAuth
const loginOAuthUsuario = async (req, res) => {
  const { email, nombre, provider } = req.body;
  try {
    // Validación para permitir solo cuentas institucionales de EPN
    if (provider === 'gmail' && !email.endsWith('@gmail.com')) {
      return res.status(403).json({ msg: 'Correo no verificado.' });
    }
    // Buscar usuario por email
    let usuario = await Usuario.findOne({ emailUsuario: email });
    if (!usuario) {
      // Registro automático de usuario si no existe (solo con campos mínimos gracias a isOAuth)
      usuario = new Usuario({
        nombreUsuario: nombre,
        emailUsuario: email,
        emailAlternativoUsuario: email, // Opcional: mismo email como alternativo
        isOAuth: true,
        oauthProvider: provider,
        confirmEmail: true // Validación de que el correo es confiable
      });
      await usuario.save();
    }
    // Generar token JWT
    const token = crearTokenJWT(usuario._id, usuario.rol);
    return res.json({
      msg: 'Inicio de sesión exitoso',
      token,
      usuario: usuario
    });
  } catch (error) {
    console.error('Error en login OAuth:', error);
    return res.status(500).json({
      msg: 'Error al iniciar sesión con OAuth',
      error: error.message
    });
  }
};

export { loginOAuthEnfermero, loginOAuthUsuario};