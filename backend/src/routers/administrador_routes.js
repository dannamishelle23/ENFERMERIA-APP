import {Router} from "express"
import { registroAdministrador, confirmarMailEnfermero, recuperarPasswordEnfermero,
    comprobarTokenPasword, crearNuevoPassword} from "../controllers/administrador_controller.js"

const router = Router()

//Registro
router.post('/administrador/registro', registroAdministrador)

//Confirmacion cuenta 
router.get('/enfermero/confirmar/:token',confirmarMailEnfermero)

//Recuperacion contraseña
router.post('/enfermero/recuperar-passowrd', recuperarPasswordEnfermero)
router.get('/enfermero/recuperar-password/:token',comprobarTokenPasword)
router.post('/enfermero/nuevopassword/:token',crearNuevoPassword)

export default router