import {Router} from "express"
import { registroEnfermeros, completarPerfilEnfermero, confirmarMailEnfermero, recuperarPasswordEnfermero,
    comprobarTokenPasword, crearNuevoPassword
 } from "../controllers/enfermeros_controller.js"

const router = Router()

//Registro
router.post('/enfermero/registro', registroEnfermeros)

//Registro enfermero 2do formulario (endpoint privado)
router.post('/enfermeros/completar-perfil/:enfermeroId', completarPerfilEnfermero)

//Confirmacion cuenta 
router.get('/enfermero/confirmar/:token',confirmarMailEnfermero)

//Recuperacion contraseña
router.post('/enfermero/recuperar-passowrd', recuperarPasswordEnfermero)
router.get('/enfermero/recuperar-password/:token',comprobarTokenPasword)
router.post('/enfermero/nuevopassword/:token',crearNuevoPassword)

export default router