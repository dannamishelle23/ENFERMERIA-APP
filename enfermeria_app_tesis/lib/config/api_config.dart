class ApiConfig {
  // CONFIGURACIÓN BASE
  // Para emulador de Android Studio
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // ========== ENDPOINTS DE AUTENTICACIÓN ==========
  
  // Login por rol
  static const String loginAdministrador = '$baseUrl/administrador/login';
  static const String loginEnfermero = '$baseUrl/enfermero/login';
  static const String loginUsuario = '$baseUrl/usuario/login';
  
  // Registro por rol
  static const String registroEnfermero = '$baseUrl/enfermero/registro';
  static const String registroUsuario = '$baseUrl/usuario/registro';
  
  // ========== CONFIRMAR EMAIL ==========
  
  // Confirmar email (solo enfermeros y clientes)
  static String confirmarEmail(String token) => '$baseUrl/confirmar/$token';
  
  // ========== RECUPERAR CONTRASEÑA - POR ROL ==========
  
  // ENFERMERO
  static const String recuperarPasswordEnfermero = '$baseUrl/enfermero/recuperarpassword';
  static String comprobarTokenEnfermero(String token) => '$baseUrl/enfermero/recuperarpassword/$token';
  static String nuevoPasswordEnfermero(String token) => '$baseUrl/enfermero/nuevopassword/$token';
  
  // USUARIO NORMAL
  static const String recuperarPasswordUsuario = '$baseUrl/usuario/recuperarpassword';
  static String comprobarTokenUsuario(String token) => '$baseUrl/usuario/recuperarpassword/$token';
  static String nuevoPasswordUsuario(String token) => '$baseUrl/usuario/nuevopassword/$token';
  
  // ADMINISTRADOR
  static const String recuperarPasswordAdmin = '$baseUrl/administrador/recuperarpassword';
  static String comprobarTokenAdmin(String token) => '$baseUrl/administrador/recuperarpassword/$token';
  static String nuevoPasswordAdmin(String token) => '$baseUrl/administrador/nuevopassword/$token';
  
  // ========== CAMBIO DE CONTRASEÑA OBLIGATORIO ==========
  
  // NUEVO: Para enfermeros recién creados con contraseña temporal
  static const String cambiarPasswordObligatorioEnfermero = '$baseUrl/enfermero/cambiar-password-obligatorio';
  
  // ========== ENDPOINTS DE PERFIL ==========
  
  static const String perfilAdministrador = '$baseUrl/administrador/perfil';
  static const String perfilEnfermero = '$baseUrl/enfermero/perfil';
  static const String perfilUsuario = '$baseUrl/usuario/perfil';
  
  // Actualizar perfil
  static String actualizarPerfilAdmin(String id) => '$baseUrl/actualizar-perfil/administrador/$id';
  static String actualizarPerfilEnfermero(String id) => '$baseUrl/actualizar-perfil/enfermero/$id';
  static String actualizarPerfilUsuario(String id) => '$baseUrl/actualizar-perfil/usuario/$id';
  static String actualizarPerfilEstudiante(String id) => '$baseUrl/actualizar-perfil/estudiante/$id';
  
  // Actualizar contraseña
  static String actualizarPasswordAdmin(String id) => '$baseUrl/administrador/administrador/actualizarpassword/$id';
  //static String actualizarPasswordenfermero(String id) => '$baseUrl/enfermero/actualizarpassword/$id';
  //static String actualizarPasswordusuario(String id) => '$baseUrl/usuario/actualizarpassword/$id';
  
  // ========== ENDPOINTS DE ENFERMEROS ==========
  
  static const String registrarenfermero = '$baseUrl/enfermeros/registro';
  static const String listarenfermeros = '$baseUrl/enfermeros';
  static String detalleenfermero(String id) => '$baseUrl/enfermero/$id';
  static String eliminarenfermero(String id) => '$baseUrl/enfermero/eliminar/$id';
  
  /* ========== ENDPOINTS DE DISPONIBILIDAD ==========
  
  static const String registrarDisponibilidad = '$baseUrl/tutorias/registrar-disponibilidad';
  static String verDisponibilidad(String enfermeroId) => '$baseUrl/ver-disponibilidad-enfermero/$enfermeroId';
  static String bloquesOcupados(String enfermeroId) => '$baseUrl/tutorias-ocupadas/$enfermeroId';*/
  
  // ========== MÉTODOS DE UTILIDAD ==========
  
  /// Headers para peticiones JSON
  static Map<String, String> getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  /// Headers para multipart (subir archivos)
  static Map<String, String> getMultipartHeaders({String? token}) {
    final headers = <String, String>{};
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  /// Obtiene el endpoint de login según el rol
  static String getLoginEndpoint(String rol) {
    switch (rol.toLowerCase()) {
      case 'administrador':
        return loginAdministrador;
      case 'enfermero':
        return loginEnfermero;
      case 'usuario':
      default:
        return loginUsuario;
    }
  }
  
  /// Obtiene el endpoint de perfil según el rol
  static String getPerfilEndpoint(String rol) {
    switch (rol.toLowerCase()) {
      case 'administrador':
        return perfilAdministrador;
      case 'enfermero':
        return perfilEnfermero;
      case 'usuario':
      default:
        return perfilUsuario;
    }
  }
  
  // ========== MÉTODOS PARA RECUPERACIÓN DE CONTRASEÑA ==========
  
  /// Obtiene el endpoint de recuperación de contraseña según el rol
  /// @deprecated Usa los endpoints específicos por rol
  static String getRecuperarPasswordEndpoint(String rol) {
    switch (rol.toLowerCase()) {
      case 'administrador':
        return recuperarPasswordAdmin;
      case 'enfermero':
        return recuperarPasswordEnfermero;
      case 'usuario':
      default:
        return recuperarPasswordUsuario;
    }
  }
  
  /// Obtiene el endpoint de comprobación de token según el rol
  /// @deprecated Usa los endpoints específicos por rol
  static String getComprobarTokenEndpoint(String rol, String token) {
    switch (rol.toLowerCase()) {
      case 'administrador':
        return comprobarTokenAdmin(token);
      case 'enfermero':
        return comprobarTokenEnfermero(token);
      case 'usuario':
      default:
        return comprobarTokenUsuario(token);
    }
  }
  
  /// Obtiene el endpoint de nueva contraseña según el rol
  /// @deprecated Usa los endpoints específicos por rol
  static String getNuevoPasswordEndpoint(String rol, String token) {
    switch (rol.toLowerCase()) {
      case 'administrador':
        return nuevoPasswordAdmin(token);
      case 'enfermero':
        return nuevoPasswordEnfermero(token);
      case 'usuario':
      default:
        return nuevoPasswordUsuario(token);
    }
  }
  
  /// Detecta el rol basándose en el formato del email
  /// Emails @epn.edu.ec = institucionales (enfermero/admin)
  /// Otros emails = usuario
  static String detectarRolPorEmail(String email) {
    final emailLower = email.toLowerCase().trim();
    
    if (emailLower.endsWith('@epn.edu.ec')) {
      // Email institucional - por defecto enfermero
      // El backend intentará primero enfermero, luego admin
      return 'enfermero';
    } else {
      // Email normal - usuario
      return 'usuario';
    }
  }
  
  /// Obtiene el nombre del campo de email según el rol para el body de las peticiones
  static String getCampoEmailPorRol(String rol) {
    switch (rol.toLowerCase()) {
      case 'administrador':
        return 'email';
      case 'enfermero':
        return 'emailenfermero';
      case 'usuario':
      default:
        return 'emailusuario';
    }
  }
}