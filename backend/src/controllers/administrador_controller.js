import Administrador from '../models/Administrador.js';
import { sendMailWithCredentialsAdmin,sendMailToRecoveryPassword } from '../config/nodemailer.js';
import { v2 as cloudinary } from 'cloudinary';
import fs from "fs-extra";
import { crearTokenJWT } from "../middlewares/JWT.js";
import mongoose from 'mongoose';

//Paso 1: Registro del administrador en la base de datos
const registrarAdministrador = async () => {
  try {
    const emailAdmin = "dannamishelle.53@gmail.com";  //Correo del administrador principal
    // Buscar si ya existe ese correo
    const admin = await Administrador.findOne({ email: emailAdmin });
    if (!admin) {
      const passwordGenerada = "Welcome-1234567$";
      const nuevoAdmin = new Administrador({
        nombreAdministrador: "Danna Lopez",
        email: emailAdmin,
        password: await new Administrador().encryptPassword(passwordGenerada),
        confirmEmail: true,
      });
      await nuevoAdmin.save();
      console.log("Administrador registrado con éxito.");

      // Enviar correo con las credenciales
      await sendMailWithCredentialsAdmin(
          nuevoAdmin.nombreAdministrador,
          nuevoAdmin.email,
          passwordGenerada
      );
    } else {
      console.log("El administrador ya se encuentra registrado en la base de datos.");
    }
  } catch (error) {
    if (error.code === 11000) {
      console.log("El administrador ya existe, no se volverá a crear.");
    } else {
      console.error("Error al registrar administrador:", error);
    }
  }
};

//Recuperacion de contraseña en caso de olvido
const recuperarPasswordAdministrador = async(req, res) => {
  try {
    const {email} = req.body;
    if (Object.values(req.body).includes(""))
      return res.status(400).json({msg:"Todos los campos deben ser llenados de manera obligatoria"});
    
    //Verificar si el email existe en la base de datos
    const administradorBDD = await Administrador.findOne({email})
    if (!administradorBDD) return res.status(400).json({msg: "El usuario no se encuentra registrado."})
    
    //Generar token y enviar email de confirmación
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

//Comprobar el token para reestablecer la contraseña
const comprobarTokenPasword = async (req,res)=>{
    try {
        const {token} = req.params
        const administradorBDD = await Administrador.findOne({token})
        if(!administradorBDD || administradorBDD?.token !== token) 
          return res.status(404).json({msg:"Lo sentimos, no se puede validar la cuenta"})
        await administradorBDD.save();
        res.status(200).json({msg:"Token confirmado, puedes crear una nueva contraseña."}) 
    } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

//Crear una nueva contraseña para reestablecer la cuenta
const crearNuevoPasswordAdministrador = async (req,res)=>{
    try {
        const{password,confirmpassword} = req.body
        if (Object.values(req.body).includes("")) 
          return res.status(404).json({msg:"Todos los campos deben ser llenados de forma obligatoria."})
        if(password !== confirmpassword) 
          return res.status(404).json({msg:"Las contraseñas que has ingresado no coinciden."})
        const administradorBDD = await Administrador.findOne({token: req.params.token})
        if(!administradorBDD || administradorBDD.token !== req.params.token) 
          return res.status(404).json({msg:"Lo sentimos, no se puede validar la cuenta"})
        administradorBDD.token = null
        administradorBDD.password = await administradorBDD.encryptPassword(password)
        await administradorBDD.save()
        res.status(200).json({msg:"Contraseña cambiada de manera exitosa. Ahora puedes iniciar sesión."}) 
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
    registrarAdministrador,
    recuperarPasswordAdministrador,
    comprobarTokenPasword,
    crearNuevoPasswordAdministrador,
    loginAdministrador,
    perfilAdministrador,
    actualizarPasswordAdministrador
}