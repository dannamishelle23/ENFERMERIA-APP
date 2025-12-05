import mongoose from 'mongoose'

mongoose.set('strictQuery', true)

const connection = async()=>{
    try {
        const {connection} = await mongoose.connect(process.env.MONGODB_URL)
        console.log(`Se ha conectado a la base de datos de manera exitosa.`)
    } catch (error) {
        console.log(error);
    }
}

export default  connection