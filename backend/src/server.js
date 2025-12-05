// Requerir modulos 
import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors';

import routerEnfermeros from "./routers/enfermeros_routes.js"
import routerAdministrador from "./routers/administrador_routes.js"

// Inicializaciones
const app = express()
dotenv.config()

// Configuraciones

// Middlewares
app.use(express.json())
app.use(cors())

// Variables globales
app.set('port', process.env.PORT || 3000)

// Ruta principal
app.get('/',(req,res)=> res.send("Server on"))

// Rutas para administradores
app.use('/api', routerAdministrador)

// Rutas para enfermeros
app.use('/api', routerEnfermeros)

//Manejo de una ruta que no sea encontrada
app.use((req, res) => res.status(404).send("Endpoint no encontrado."))

// Exportar la instancia 
export default app