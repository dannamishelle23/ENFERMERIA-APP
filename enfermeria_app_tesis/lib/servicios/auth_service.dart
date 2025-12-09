import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../modelos/usuario.dart';

class AuthService {
  // ========== CONSTANTES PARA SHAREDPREFERENCES ==========
  static const String _keyToken = 'token';
  static const String _keyUsuario = 'usuario';
  static const String _keyRol = 'rol';

  // ========== LOGIN ==========

  /// Login para Administrador
  /// Backend devuelve: { token, rol, nombreAdministrador, _id, email, fotoPerfilAdmin }
  static Future<Map<String, dynamic>?> loginAdministrador({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginAdministrador),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Guardar datos en SharedPreferences
        await _guardarSesion(
          token: data['token'],
          rol: 'Administrador',
          usuarioJson: {
            '_id': data['_id'],
            'nombreAdministrador': data['nombreAdministrador'],
            'email': data['email'],
            'fotoPerfilAdmin': data['fotoPerfilAdmin'],
            'rol': data['rol'],
            'status': true,
            'confirmEmail': true,
            'isOAuth': false,
          },
        );

        return data;
      } else {
        final error = jsonDecode(response.body);
        return {'error': error['msg'] ?? 'Error al iniciar sesión'};
      }
    } catch (e) {
      print('Error en loginAdministrador: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

  /// Login para Enfermeros
  /// Backend devuelve: { token, rol, _id, avatarEnfermero, requiresPasswordChange? }
  /// NOTA: El backend solo devuelve estos 4 campos, necesitamos obtener el perfil completo después
  static Future<Map<String, dynamic>?> loginEnfermero({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginEnfermero),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // VERIFICAR SI REQUIERE CAMBIO DE CONTRASEÑA
        if (data['requiresPasswordChange'] == true) {
          print('Enfermero requiere cambio de contraseña obligatorio');
          
          // Guardar token temporalmente
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_keyToken, data['token']);
          await prefs.setString(_keyRol, 'Enfermero');

          // Obtener perfil mínimo para mostrar en pantalla de cambio
          final perfilResponse = await http.get(
            Uri.parse(ApiConfig.perfilEnfermero),
            headers: ApiConfig.getHeaders(token: data['token']),
          );

          if (perfilResponse.statusCode == 200) {
            final perfilData = jsonDecode(perfilResponse.body);

            // Guardar sesión temporal
            await _guardarSesion(
              token: data['token'],
              rol: 'Enfermero',
              usuarioJson: {
                '_id': perfilData['_id'],
                'nombreEnfermero': perfilData['nombreEnfermero'],
                'emailEnfermero': perfilData['emailEnfermero'],
                'cedulaEnfermero': perfilData['cedulaEnfermero'],
                'celularEnfermero': perfilData['celularEnfermero'],
                'emailAlternativoEnfermero': perfilData['emailAlternativoEnfermero'],
                'avatarEnfermero': perfilData['avatarEnfermero'],
                'fechaNacimientoEnfermero': perfilData['fechaNacimientoEnfermero'],
                'fechaIngresoEnfermero': perfilData['fechaIngresoEnfermero'],
                'rol': data['rol'],
                'estadoEnfermero': true,
                'confirmEmail': true,
                'isOAuth': false,
              },
            );
          }

          // Retornar con flag de cambio obligatorio
          return {
            ...data,
            'requiresPasswordChange': true,
          };
        }

        // LOGIN NORMAL - Sin cambio obligatorio
        // Guardar token temporalmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyToken, data['token']);
        await prefs.setString(_keyRol, 'Enfermero');

        // Obtener perfil completo del Enfermero
        final perfilResponse = await http.get(
          Uri.parse(ApiConfig.perfilEnfermero),
          headers: ApiConfig.getHeaders(token: data['token']),
        );

        if (perfilResponse.statusCode == 200) {
          final perfilData = jsonDecode(perfilResponse.body);

          // Guardar sesión completa
          await _guardarSesion(
            token: data['token'],
            rol: 'Enfermero',
            usuarioJson: {
              '_id': perfilData['_id'],
              'nombreEnfermero': perfilData['nombreEnfermero'],
              'emailEnfermero': perfilData['emailEnfermero'],
              'cedulaEnfermero': perfilData['cedulaEnfermero'],
              'celularEnfermero': perfilData['celularEnfermero'],
              'emailAlternativoEnfermero': perfilData['emailAlternativoEnfermero'],
              'avatarEnfermero': perfilData['avatarEnfermero'],
              'fechaNacimientoEnfermero': perfilData['fechaNacimientoEnfermero'],
              'fechaIngresoEnfermero': perfilData['fechaIngresoEnfermero'],
              'rol': data['rol'],
              'estadoEnfermero': true,
              'confirmEmail': true,
              'isOAuth': false,
            },
          );

          return data;
        }

        return data;
      } else {
        final error = jsonDecode(response.body);
        return {'error': error['msg'] ?? 'Error al iniciar sesión'};
      }
    } catch (e) {
      print('Error en loginEnfermero: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

/// Login para Usuario
  /// Backend devuelve: { token, rol, nombreUsuario, telefono, _id, emailUsuario, fotoPerfil }
  static Future<Map<String, dynamic>?> loginUsuario({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUsuario),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({'emailUsuario': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('🔍 RESPUESTA DEL BACKEND:');
        print('   Token: ${data['token']?.substring(0, 20)}...');
        print('   Rol: ${data['rol']}');
        print('   _id: ${data['_id']}');
        print('   usuario._id: ${data['usuario']?['_id']}');
        print('   nombreUsuario: ${data['nombreUsuario']}');
        print('   usuario.nombreUsuario: ${data['usuario']?['nombreUsuario']}');

        // EXTRAER ID CORRECTAMENTE (puede venir en data o en data.usuario)
        final userId = data['_id'] ?? data['usuario']?['_id'] ?? '';
        final userName = data['nombreUsuario'] ?? data['usuario']?['nombreUsuario'] ?? '';
        final userEmail = data['emailUsuario'] ?? data['usuario']?['emailUsuario'] ?? email;
        final userPhone = data['telefono'] ?? data['usuario']?['telefono'];
        final userPhoto = data['fotoPerfil'] ?? data['usuario']?['fotoPerfil'];
        final userRol = data['rol'] ?? data['usuario']?['rol'] ?? 'Usuario';

        print('DATOS EXTRAÍDOS:');
        print('   userId: $userId');
        print('   userName: $userName');
        print('   userEmail: $userEmail');

        if (userId.isEmpty) {
          print('❌ ERROR: No se pudo obtener el ID del usuario');
          return {'error': 'Error al obtener datos del usuario'};
        }

        // Guardar datos en SharedPreferences
        await _guardarSesion(
          token: data['token'],
          rol: userRol,
          usuarioJson: {
            '_id': userId,
            'nombreUsuario': userName,
            'emailUsuario': userEmail,
            'telefono': userPhone,
            'fotoPerfil': userPhoto,
            'rol': userRol,
            'status': true,
            'confirmEmail': true,
            'isOAuth': false,
          },
        );

        print('Sesión guardada correctamente');

        return data;
      } else {
        final error = jsonDecode(response.body);
        return {'error': error['msg'] ?? 'Error al iniciar sesión'};
      }
    } catch (e) {
      print('Error en loginUsuario: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

  // ========== REGISTRO ==========

  /// Registro de Usuario
  static Future<Map<String, dynamic>?> registrarUsuario({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registroUsuario),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          'nombreUsuario': nombre,
          'emailUsuario': email,
          'password': password,
          'telefono': telefono ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        return {'error': error['msg'] ?? 'Error al registrar'};
      }
    } catch (e) {
      print('Error en registrarUsuario: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

  /// Registro de Estudiante (alias de registrarUsuario)
  static Future<Map<String, dynamic>?> registrarEstudiante({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    return registrarUsuario(
      nombre: nombre,
      email: email,
      password: password,
      telefono: telefono,
    );
  }

  // ========== CAMBIO DE CONTRASEÑA OBLIGATORIO ==========

  /// Cambia la contraseña temporal del Enfermero recién creado
  /// Este método se llama cuando requiresPasswordChange = true
  static Future<Map<String, dynamic>?> cambiarPasswordObligatorio({
    required String email,
    required String passwordActual,
    required String passwordNueva,
  }) async {
    try {
      print('Cambiando contraseña obligatoria para: $email');
      
      final token = await getToken();
      
      if (token == null) {
        return {'error': 'No hay sesión activa'};
      }

      final response = await http.post(
        Uri.parse(ApiConfig.cambiarPasswordObligatorioEnfermero),
        headers: ApiConfig.getHeaders(token: token),
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'passwordActual': passwordActual,
          'passwordNueva': passwordNueva,
        }),
      );

      print('📬 Código de estado: ${response.statusCode}');
      print('📝 Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Contraseña cambiada exitosamente');
        return {'msg': data['msg'] ?? 'Contraseña actualizada', 'success': true};
      } else {
        final error = jsonDecode(response.body);
        print('Error: ${error['msg']}');
        return {'error': error['msg'] ?? 'Error al cambiar la contraseña'};
      }
    } catch (e) {
      print('Error en cambiarPasswordObligatorio: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

  // ========== SESIÓN ==========

  /// Guarda la sesión del usuario
  static Future<void> _guardarSesion({
    required String token,
    required String rol,
    required Map<String, dynamic> usuarioJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyRol, rol);
    await prefs.setString(_keyUsuario, jsonEncode(usuarioJson));
  }

  /// Obtiene el token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Obtiene el rol guardado
  static Future<String?> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRol);
  }

  /// Obtiene el usuario actual desde SharedPreferences
  static Future<Usuario?> getUsuarioActual() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString(_keyUsuario);
      final rol = prefs.getString(_keyRol);

      if (usuarioJson != null && rol != null) {
        final Map<String, dynamic> data = jsonDecode(usuarioJson);
        return Usuario.fromJson(data, rol);
      }
      return null;
    } catch (e) {
      print('Error en getUsuarioActual: $e');
      return null;
    }
  }

  /// Verifica si hay una sesión activa
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Cierra la sesión del usuario
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsuario);
    await prefs.remove(_keyRol);
    await prefs.clear();
  }

  /// Actualiza la información del usuario en SharedPreferences
  static Future<void> actualizarUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsuario, jsonEncode(usuario.toJson()));
  }

  // ========== OBTENER PERFIL DESDE EL SERVIDOR ==========

  /// Obtiene el perfil completo del usuario desde el servidor
  static Future<Usuario?> obtenerPerfil() async {
    try {
      final token = await getToken();
      final rol = await getRol();

      if (token == null || rol == null) return null;

      final endpoint = ApiConfig.getPerfilEndpoint(rol);

      final response = await http.get(
        Uri.parse(endpoint),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final usuario = Usuario.fromJson(data, rol);

        // Actualizar en SharedPreferences
        await actualizarUsuario(usuario);

        return usuario;
      }
      return null;
    } catch (e) {
      print('Error en obtenerPerfil: $e');
      return null;
    }
  }

  // ========== CONFIRMAR EMAIL ==========

  /// Confirma el email del Usuario con el token recibido por deep link
  static Future<Map<String, dynamic>?> confirmarEmail(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.confirmarEmail(token)),
        headers: ApiConfig.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Cuenta confirmada exitosamente');
        return data;
      } else {
        print('❌ Error confirmando cuenta: ${data['msg']}');
        return {'error': data['msg'] ?? 'Error al confirmar cuenta'};
      }
    } catch (e) {
      print('❌ Error en confirmarEmail: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

// ========== RECUPERAR CONTRASEÑA ==========

  /// Solicita recuperación de contraseña
  /// Detecta automáticamente el rol según el formato del email
  static Future<Map<String, dynamic>?> recuperarPassword({
    required String email,
  }) async {
    try {
      print('📧 Enviando solicitud de recuperación para: $email');
      
      // NORMALIZAR EMAIL DESDE LA APP
      final emailNormalizado = email.trim().toLowerCase();
      
      // Detectar rol por email
      String endpoint;
      Map<String, String> body;
      
      if (emailNormalizado.endsWith('@epn.edu.ec')) {
        // Email institucional - puede ser Enfermero o admin
        endpoint = ApiConfig.recuperarPasswordEnfermero;
        body = {'emailEnfermero': emailNormalizado}; // ✅ Enviar normalizado
      } else {
        // Email normal - Usuario
        endpoint = ApiConfig.recuperarPasswordUsuario;
        body = {'emailUsuario': emailNormalizado}; // ✅ Enviar normalizado
      }

      final response = await http.post(
        Uri.parse(endpoint),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode(body),
      );

      print('📬 Código de estado: ${response.statusCode}');
      print('📝 Respuesta: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true || !data.containsKey('success')) {
          print('✅ ${data['msg']}');
          return {'msg': data['msg'], 'success': true};
        } else {
          print('⚠️ Respuesta con success=false: ${data['msg']}');
          return {'error': data['msg']};
        }
      } 
      
      // ✅ Si falla con Enfermero y es institucional, intentar como admin
      if (response.statusCode == 404 && emailNormalizado.endsWith('@epn.edu.ec')) {
        print('🔄 Reintentando como administrador...');
        
        final adminResponse = await http.post(
          Uri.parse(ApiConfig.recuperarPasswordAdmin),
          headers: ApiConfig.getHeaders(),
          body: jsonEncode({'email': emailNormalizado}), // ✅ Enviar normalizado
        );
        
        final adminData = jsonDecode(adminResponse.body);
        
        if (adminResponse.statusCode == 200) {
          return {'msg': adminData['msg'], 'success': true};
        }
      }
      
      print('❌ Error en recuperación: ${data['msg']}');
      return {'error': data['msg'] ?? 'Error al procesar la solicitud'};
      
    } catch (e) {
      print('❌ Error en recuperarPassword: $e');
      return {'error': 'Error de conexión. Verifica tu internet.'};
    }
  }

  // ========== COMPROBAR TOKEN ==========

  /// Verifica si el token de recuperación es válido
  static Future<Map<String, dynamic>?> comprobarTokenPassword(
    String token,
  ) async {
    try {
      // Intentar con los 3 roles
      final endpoints = [
        ApiConfig.comprobarTokenUsuario(token),
        ApiConfig.comprobarTokenEnfermero(token),
        ApiConfig.comprobarTokenAdmin(token),
      ];
      
      for (String endpoint in endpoints) {
        try {
          final response = await http.get(
            Uri.parse(endpoint),
            headers: ApiConfig.getHeaders(),
          );

          final data = jsonDecode(response.body);

          if (response.statusCode == 200 && data['success'] == true) {
            print('✅ Token válido en: $endpoint');
            return data;
          }
        } catch (e) {
          continue; // Intentar siguiente endpoint
        }
      }
      
      return {'error': 'Token inválido o expirado'};
    } catch (e) {
      print('❌ Error en comprobarTokenPassword: $e');
      return {'error': 'Error de conexión'};
    }
  }

  // ========== CREAR NUEVA CONTRASEÑA ==========

  /// Crea una nueva contraseña usando el token de recuperación
  static Future<Map<String, dynamic>?> crearNuevaPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Intentar con los 3 roles
      final endpoints = [
        ApiConfig.nuevoPasswordUsuario(token),
        ApiConfig.nuevoPasswordEnfermero(token),
        ApiConfig.nuevoPasswordAdmin(token),
      ];
      
      for (String endpoint in endpoints) {
        try {
          final response = await http.post(
            Uri.parse(endpoint),
            headers: ApiConfig.getHeaders(),
            body: jsonEncode({
              'password': password,
              'confirmpassword': confirmPassword,
            }),
          );

          final data = jsonDecode(response.body);

          if (response.statusCode == 200 && data['success'] == true) {
            print('✅ Contraseña actualizada en: $endpoint');
            return data;
          }
        } catch (e) {
          continue; // Intentar siguiente endpoint
        }
      }
      
      return {'error': 'No se pudo actualizar la contraseña'};
    } catch (e) {
      print('❌ Error en crearNuevaPassword: $e');
      return {'error': 'Error de conexión'};
    }
  }
}