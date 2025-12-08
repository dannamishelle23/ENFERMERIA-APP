// Requerir modulos 
import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors';
import { registrarAdministrador } from './controllers/administrador_controller.js'
import routerAdministrador from "./routers/administrador_routes.js"
import routerEnfermeros from "./routers/enfermeros_routes.js"
import cloudinary from 'cloudinary';
import fileUpload from 'express-fileupload';

// Inicializaciones
const app = express()
dotenv.config()

// Configuraciones
app.set('port', process.env.PORT || 3000)

// Middlewares
app.use(express.json())
app.use(cors())

app.use(fileUpload({
    useTempFiles: true,
    tempFileDir: './uploads',
}));

// 1) Ruta principal
app.get('/',(req,res)=> res.send("Server on"))

// 2) Rutas específicas

// Rutas para administrador
app.use('/api', routerAdministrador)
//Llamar a la función de registro del administrador al iniciar el servidor
registrarAdministrador()

// Ruta para enfermeros
app.use('/api', routerEnfermeros)

//Manejo de una ruta que no sea encontrada
app.use((req, res) => res.status(404).send("Endpoint no encontrado."))

// Inicializaciones
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
})

// Exportar la instancia 
export default app