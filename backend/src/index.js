import app from './server.js';
import connection from './database.js';

// Conectar a la base de datos
connection();

// Inicializar el servidor
app.listen(app.get('port'), () => {
  console.log(`Server is running on: http://localhost:${app.get('port')}`);
});
