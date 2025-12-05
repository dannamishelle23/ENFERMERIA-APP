import Administrador from '../models/Administrador.js';
import { sendMailToRecoveryPassword, sendMailToRegisterAdmin } from '../config/nodemailer.js';

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
        res.status(200).json({ msg: "Cuenta confirmada, ya puedes iniciar sesión" })

    } catch (error) {
    console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

/*
//Recuperacion de contraseña en caso de olvido
const recuperarPasswordEnfermero = async(req, res) => {
  try {
    const {email} = req.body;
    if(!email) return res.status(400).json({msg: "Debes ingresar un correo de manera obligatoria."})
    const enfermeroBDD = await Enfermero.findOne({email})
    if (!enfermeroBDD) return res.status(400).json({msg: "El usuario no se encuentra registrado."})
    const token = enfermeroBDD.createToken()
    enfermeroBDD.token = token
    await sendMailToRecoveryPassword(email, token)
    await enfermeroBDD.save()
    res.status(200).json({msg: "Email de recuperación de cuenta enviado con éxito!"})
  } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

const comprobarTokenPasword = async (req,res)=>{
    try {
        const {token} = req.params
        const enfermeroBDD = await Enfermero.findOne({token})
        if(enfermeroBDD?.token !== token) return res.status(404).json({msg:"Lo sentimos, no se puede validar la cuenta"})
        res.status(200).json({msg:"Token confirmado, ahora puedes crear una nueva contraseña."}) 
    
    } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}

//Crear una nueva contraseña para reestablecer la cuenta
const crearNuevoPassword = async (req,res)=>{

    try {
        const{password,confirmpassword} = req.body
        const { token } = req.params
        if (Object.values(req.body).includes("")) return res.status(404).json({msg:"Debes llenar todos los campos"})
        if(password !== confirmpassword) return res.status(404).json({msg:"Las contraseñas que has ingresado no coinciden."})
        const enfermeroBDD = await Enfermero.findOne({token})
        if(!enfermeroBDD) return res.status(404).json({msg:"No se puede validar la cuenta"})
        enfermeroBDD.token = null
        enfermeroBDD.password = await enfermeroBDD.encryptPassword(password)
        await enfermeroBDD.save()
        res.status(200).json({msg:"Felicitaciones, ya puedes iniciar sesión con tu nuevo password"}) 

    } catch (error) {
        console.error(error)
        res.status(500).json({ msg: `Error en el servidor - ${error}` })
    }
}*/

export {
    registroAdministrador,
    confirmarMailAdministrador,
    //recuperarPasswordEnfermero,
    //comprobarTokenPasword,
    //crearNuevoPassword
}