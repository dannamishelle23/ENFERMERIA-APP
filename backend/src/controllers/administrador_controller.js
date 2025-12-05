import Administrador from '../models/Administrador.js';
import { sendMailToRecoveryPassword, sendMailToRegisterAdmin } from '../config/nodemailer.js';
import { v2 as cloudinary } from 'cloudinary';
import fs from "fs-extra";
import mongoose from 'mongoose';

//Paso 1: Registro de los datos básicos de los enfermeros
const registroAdministrador = async(req, res) => {
    try {
        const {email, password} = req.body
        // Validación de campos obligatorios
        if (!nombre || !apellido || !email || !password) return res.status(400).json({msg: "Debes completar todos los campos de manera obligatoria."})
        const verificarEmailBDD = await Administrador.findOne({email})
        if(verificarEmailBDD) return res.status(400).json({msg: "Lo sentimos, el email ya se encuentra registrado."})
        const nuevoAdministrador = new Administrador({nombre, apellido, email, password})
        nuevoAdministrador.password = await nuevoAdministrador.encryptPassword(password)
        const token = nuevoAdministrador.createToken()
        await sendMailToRegisterAdmin(email,token)
        await nuevoAdministrador.save()
        //Retornar ID para el siguiente formulario
        res.status(200).json({msg: "Datos registrados con éxito. Revisa tu correo electrónico para confirmar tu cuenta.", administradorId: nuevoAdministrador._id})
    } catch (error) {
        res.status(500).json({msg: "Error en el servidor."})
    }
}

//Paso 2: Confirmar email administrador
const confirmarMailAdministrador = async (req, res) => {
    try {
        const { token } = req.params
        const administradorBDD = await Administrador.findOne({ token })
        if (!administradorBDD) return res.status(404).json({ msg: "Token inválido o cuenta ya confirmada" })
        administradorBDD.token = null
        administradorBDD.confirmEmail = true
        await administradorBDD.save()
        res.status(200).json({ msg: "Su cuenta ha sido confirmada, ya puede iniciar sesión" })

    } catch (error) {
    console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

//Recuperacion de contraseña en caso de olvido
const recuperarPasswordAdministrador = async(req, res) => {
  try {
    const {email} = req.body;
    if(!email) return res.status(400).json({msg: "Debes ingresar un correo de manera obligatoria."})
    const administradorBDD = await Administrador.findOne({email})
    if (!administradorBDD) return res.status(400).json({msg: "El usuario no se encuentra registrado."})
    const token = administradorBDD.createToken()
    administradorBDD.token = token
    await sendMailToRecoveryPassword(email, token)
    await administradorBDD.save()
    res.status(200).json({msg: "Email de recuperación de cuenta enviado con éxito!"})
  } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

const comprobarTokenPasword = async (req,res)=>{
    try {
        const {token} = req.params
        const administradorBDD = await Administrador.findOne({token})
        if(administradorBDD?.token !== token) return res.status(404).json({msg:"Lo sentimos, no se puede validar la cuenta"})
        res.status(200).json({msg:"Token confirmado, ya puedes crear una nueva contraseña."}) 
    
    } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

//Crear una nueva contraseña para reestablecer la cuenta
const crearNuevoPasswordAdministrador = async (req,res)=>{

    try {
        const{password,confirmpassword} = req.body
        const { token } = req.params
        if (Object.values(req.body).includes("")) return res.status(404).json({msg:"Debes llenar todos los campos"})
        if(password !== confirmpassword) return res.status(404).json({msg:"Las contraseñas que has ingresado no coinciden."})
        const administradorBDD = await Administrador.findOne({token})
        if(!administradorBDD) return res.status(404).json({msg:"No se puede validar la cuenta"})
        administradorBDD.token = null
        administradorBDD.password = await administradorBDD.encryptPassword(password)
        await administradorBDD.save()
        res.status(200).json({msg:"Contraseña cambiada y reestablecida de manera exitosa."}) 
    } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

// Iniciar sesión como administrador
const loginAdministrador = async (req, res) => {
  const { email, password } = req.body;

  if (Object.values(req.body).includes(""))
    return res.status(400).json({ msg: "Todos los campos son obligatorios." });

  const administradorBDD = await Administrador.findOne({ email }).select(
    "-status -__v -token -createdAt -updateAt"
  );

  //Verificar si el administrador existe en la base de datos 
  if (!administradorBDD)
    return res.status(404).json({ msg: "Lo sentimos, el usuario no existe." });

  //Verificar si el password es correcto
  const verificarPassword = await administradorBDD.matchPassword(password);
  if (!verificarPassword)
    return res.status(401).json({ msg: "Lo sentimos, la contraseña es incorrecta." });

  const { nombreAdministrador, _id, rol, fotoPerfilAdmin } = administradorBDD;
  const token = crearTokenJWT(administradorBDD._id, administradorBDD.rol);
  
  res.status(200).json({
    token,
    rol,
    nombreAdministrador,
    _id,
    email: administradorBDD.email,
    fotoPerfilAdmin,
  });
};

// Perfil Administrador
const perfilAdministrador = (req, res) => {
  const { token, confirmEmail, createdAt, updatedAt, __v, ...datosPerfil } = req.administradorBDD;
  res.status(200).json(datosPerfil);
};

// Actualizar contraseña
const actualizarPasswordAdministrador = async (req, res) => {
  const administradorBDD = await Administrador.findById(req.administradorBDD._id);
  if (!administradorBDD)
    return res.status(404).json({ msg: `Lo sentimos, no existe el Administrador` });

  const verificarPassword = await administradorBDD.matchPassword(req.body.passwordactual);
  if (!verificarPassword)
    return res.status(404).json({ msg: "Lo sentimos, el password actual no es el correcto" });

  administradorBDD.password = await administradorBDD.encrypPassword(req.body.passwordnuevo);
  await administradorBDD.save();

  res.status(200).json({ msg: "Password actualizado correctamente" });
};


export {
    registroAdministrador,
    confirmarMailAdministrador,
    recuperarPasswordAdministrador,
    comprobarTokenPasword,
    crearNuevoPasswordAdministrador,
    loginAdministrador,
    perfilAdministrador,
    actualizarPasswordAdministrador
}