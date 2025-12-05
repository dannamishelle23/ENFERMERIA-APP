import {Router} from "express"
import { registroAdministrador, confirmarMailAdministrador, recuperarPasswordAdministrador,
    comprobarTokenPasword, crearNuevoPasswordAdministrador,loginAdministrador,perfilAdministrador,
    actualizarPasswordAdministrador,
    } from "../controllers/administrador_controller.js"

const router = Router()

//Registro
router.post('/administrador/registro', registroAdministrador)

//Confirmacion cuenta 
router.get('/enfermero/confirmar/:token',confirmarMailAdministrador)

//Recuperacion contraseña
router.post('/enfermero/recuperar-passowrd', recuperarPasswordAdministrador)
router.get('/enfermero/recuperar-password/:token',comprobarTokenPasword)

//Nueva contraseña para reestablecer cuenta
router.post('/enfermero/nuevopassword/:token',crearNuevoPasswordAdministrador)

//Login
router.post('/administrador/login', loginAdministrador)

//Perfil Administrador
router.get('/administrador/perfil', perfilAdministrador)

//Actualizar contraseña
router.put('/administrador/actualizar-password', actualizarPasswordAdministrador)

export default router