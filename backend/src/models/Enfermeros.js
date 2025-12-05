import {Schema, model} from 'mongoose'
import bcrypt from "bcryptjs"

const enfermeroSchema = new Schema({
    //Primer formulario
    nombre:{
        type:String,
        required:true,
        trim:true
    },
    apellido:{
        type:String,
        required:true,
        trim:true
    },
    direccion:{
        type:String,
        trim:true,
        default:null
    },
    celular:{
        type:String,
        trim:true,
        default:null
    },
    email:{
        type:String,
        required:true,
        trim:true,
		unique:true
    },
    password:{
        type:String,
        required: function () {
            return !this.isOAuth;  // la contraseña es obligatoria si el usuario no se registró mediante OAuth
            },
    },
    isOAuth: {
        type: Boolean,
        default: false,
    },
    oauthProvider: {
        type: String,
            enum: ['google', null],
            default: null,
    },
    status:{
        type:Boolean,
        default:true
    },
    token:{
        type:String,
        default:null
    },
    confirmEmail:{
        type:Boolean,
        default:false
    },
    rol:{
        type:String,
        default:"Enfermero"
    },
    // Campos adicionales para el segundo formulario
    titulo: { 
        type:String, 
        trim:true, 
        default:null 
    },
    anosExperiencia: { 
        type:Number, 
        default:null 
    },
    especialidad: { 
        type:String, 
        trim:true, 
        default:null 
    }
},{
    timestamps:true
})

// Método para cifrar el password
enfermeroSchema.methods.encryptPassword = async function(password){
    const salt = await bcrypt.genSalt(10)
    const passwordEncryp = await bcrypt.hash(password,salt)
    return passwordEncryp
}

// Método para verificar si el password es el mismo de la BDD
enfermeroSchema.methods.matchPassword = async function(password){
    const response = await bcrypt.compare(password,this.password)
    return response
}

// Método para crear un token 
enfermeroSchema.methods.createToken= function(){
    const tokenGenerado = Math.random().toString(36).slice(2)
    this.token = tokenGenerado
    return tokenGenerado
}

export default model('Enfermero',enfermeroSchema)