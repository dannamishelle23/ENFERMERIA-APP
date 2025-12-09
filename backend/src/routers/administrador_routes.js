import {Router} from "express"
import { registrarAdministrador, recuperarPasswordAdministrador,
    comprobarTokenPasword, crearNuevoPasswordAdministrador,loginAdministrador,perfilAdministrador,
    actualizarPerfilAdministrador,actualizarPasswordAdministrador,
    } from "../controllers/administrador_controller.js"
import { verificarTokenJWT } from '../middlewares/JWT.js'

const routerAdministrador = Router()

//Registro con confirmacion de mail
routerAdministrador.post('/administrador/registro', registrarAdministrador)

//Recuperacion contraseña
routerAdministrador.post('/administrador/recuperar-passowrd', recuperarPasswordAdministrador)
routerAdministrador.get('/administrador/recuperar-password/:token',comprobarTokenPasword)

//Nueva contraseña para reestablecer cuenta
routerAdministrador.post('/administrador/nuevopassword/:token',crearNuevoPasswordAdministrador)

//Login
routerAdministrador.post('/administrador/login', loginAdministrador)

//Perfil Administrador
routerAdministrador.get('/administrador/perfil', verificarTokenJWT, perfilAdministrador)

//Actualizar perfil como administrador
routerAdministrador.put('/administrador/actualizar-perfil/:id', verificarTokenJWT, actualizarPerfilAdministrador)

//Actualizar contraseña
routerAdministrador.put('/administrador/actualizar-password/:id', verificarTokenJWT, actualizarPasswordAdministrador)

export default routerAdministrador