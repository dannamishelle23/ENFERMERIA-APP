import Enfermero from '../models/Enfermeros.js';
import { sendMailToRecoveryPassword, sendMailToRegister } from '../config/nodemailer.js';

//Paso 1: Registro de los datos básicos de los enfermeros
const registroEnfermeros = async(req, res) => {
    try {
        const {email, password} = req.body
        // Validación de campos obligatorios
        if (!nombre || !apellido || !email || !password) return res.status(400).json({msg: "Debes completar todos los campos de manera obligatoria."})
        const verificarEmailBDD = await Enfermero.findOne({email})
        if(verificarEmailBDD) return res.status(400).json({msg: "Lo sentimos, el email ya se encuentra registrado."})
        const nuevoEnfermero = new Enfermero({nombre, apellido, email, password})
        nuevoEnfermero.password = await nuevoEnfermero.encryptPassword(password)
        await nuevoEnfermero.save()
        //Retornar ID para el siguiente formulario
        res.status(200).json({msg: "Datos registrados con éxito.", enfermeroId: nuevoEnfermero._id})
    } catch (error) {
        res.status(500).json({msg: "Error en el servidor."})
    }
}

//Paso 2: Completar perfil y enviar correo
const completarPerfilEnfermero = async(req, res) => {
    try {
        const {titulo, anosExperiencia, especialidad} = req.body
        const enfermero = await Enfermero.findById(req.params.id)
        if(!enfermero) return res.status(404).json({msg: "Enfermero no encontrado."})

        enfermero.titulo = titulo || enfermero.titulo
        enfermero.anosExperiencia = anosExperiencia || enfermero.anosExperiencia
        enfermero.especialidad = especialidad || enfermero.especialidad

        //Crear token y enviar correo
        const token = enfermero.createToken()
        await sendMailToRegister(enfermero.email, token)
        await enfermero.save()
        res.status(200).json({msg: "Su perfil ha sido registrado con éxito! Revisa tu correo para confirmar la cuenta."})
    } catch (error) {
        res.status(500).json({msg: "Error en el servidor."})
    }
}

// Paso 3: Confirmar email
const confirmarMailEnfermero = async(req, res) => {
    try {
        const {token} = req.params
        const enfermeroBDD = await Enfermero.findOne({token})
        if (!enfermeroBDD) {
            return res.redirect(`${process.env.URL_FRONTEND}/login?confirmado=false`)
        }
        enfermeroBDD.token = null
        enfermeroBDD.confirmEmail = true
        await enfermeroBDD.save()
        // Redirige al login con query param de éxito
        res.redirect(`${process.env.URL_FRONTEND}/login?confirmado=true`)
    } catch (error) {
        console.error(error)
        // Redirige al login con query param de error
        res.redirect(`${process.env.URL_FRONTEND}/login?confirmado=false`)
    }
}

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
}

export {
    registroEnfermeros,
    completarPerfilEnfermero,
    confirmarMailEnfermero,
    recuperarPasswordEnfermero,
    comprobarTokenPasword,
    crearNuevoPassword
}