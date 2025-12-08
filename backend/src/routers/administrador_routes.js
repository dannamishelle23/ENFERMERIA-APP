import {Router} from "express"
import { registrarAdministrador, confirmarMailAdministrador, recuperarPasswordAdministrador,
    comprobarTokenPasword, crearNuevoPasswordAdministrador,loginAdministrador,perfilAdministrador,
    actualizarPasswordAdministrador,
    } from "../controllers/administrador_controller.js"

const router = Router()

//Registro
router.post('/administrador/registro', registrarAdministrador)

//Recuperacion contraseña
router.post('/administrador/recuperar-passowrd', recuperarPasswordAdministrador)
router.get('/administrador/recuperar-password/:token',comprobarTokenPasword)

//Nueva contraseña para reestablecer cuenta
router.post('/administrador/nuevopassword/:token',crearNuevoPasswordAdministrador)

//Login
router.post('/administrador/login', loginAdministrador)

//Perfil Administrador
router.get('/administrador/perfil', perfilAdministrador)

//Actualizar contraseña
router.put('/administrador/actualizar-password', actualizarPasswordAdministrador)

export default router