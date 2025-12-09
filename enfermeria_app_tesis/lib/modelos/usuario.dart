import '../config/api_config.dart';

class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String rol; // 'Administrador', 'Enfermero', 'Usuario'
  final String? fotoPerfil;
  final bool status;
  final bool confirmEmail;

  // Campos específicos según el rol
  final String? cedula; // Solo enfermeros
  final String? telefono; // usuarios
  final String? celular; // Enfermeros
  final String? emailAlternativo; // Enfermeros
  final DateTime? fechaNacimiento; // Enfermeros
  final DateTime? fechaIngreso; // Enfermeros

  // OAuth 
  final bool isOAuth;
  final String? oauthProvider;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.fotoPerfil,
    required this.status,
    required this.confirmEmail,
    this.cedula,
    this.telefono,
    this.celular,
    this.emailAlternativo,
    this.fechaNacimiento,
    this.fechaIngreso,
    this.isOAuth = false,
    this.oauthProvider,
  });

  // Convierte JSON del backend a objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json, String rol) {
    print('Usuario.fromJson llamado');
    print('   Rol recibido: $rol');
    print('   JSON keys: ${json.keys.join(", ")}');
    print('   _id: ${json['_id']}');
    print('   id: ${json['id']}');
    
    switch (rol) {
      case 'Administrador':
        final id = json['_id'] ?? json['id'] ?? '';
        print('Admin ID extraído: $id');
        return Usuario(
          id: id,
          nombre: json['nombreAdministrador'] ?? '',
          email: json['email'] ?? '',
          rol: 'Administrador',
          fotoPerfil: json['fotoPerfilAdmin'],
          status: json['status'] ?? true,
          confirmEmail: json['confirmEmail'] ?? true,
          isOAuth: json['isOAuth'] ?? false,
          oauthProvider: json['oauthProvider'],
        );

      case 'Enfermero':
        final id = json['_id'] ?? json['id'] ?? '';
        print('Enfermero ID extraído: $id');
        return Usuario(
          id: id,
          nombre: json['nombreEnfermero'] ?? '',
          email: json['emailEnfermero'] ?? '',
          rol: 'enfermero',
          fotoPerfil: json['avatarenfermero'],
          status: json['estadoenfermero'] ?? true,
          confirmEmail: json['confirmEmail'] ?? true,
          cedula: json['cedulaenfermero'],
          celular: json['celularenfermero'],
          emailAlternativo: json['emailAlternativoenfermero'],
          fechaNacimiento: json['fechaNacimientoEnfermero'] != null
              ? DateTime.parse(json['fechaNacimientoenfermero'])
              : null,
          fechaIngreso: json['fechaIngresoenfermero'] != null
              ? DateTime.parse(json['fechaIngresoenfermero'])
              : null,
          isOAuth: json['isOAuth'] ?? false,
          oauthProvider: json['oauthProvider'],
        );

      case 'Usuario':
      default:
        final id = json['_id'] ?? json['id'] ?? '';
        print('✅ usuario ID extraído: $id');
        
        if (id.isEmpty) {
          print('⚠️ ADVERTENCIA: ID de usuario está vacío');
          print('   JSON completo: $json');
        }
        
        return Usuario(
          id: id,
          nombre: json['nombreusuario'] ?? '',
          email: json['emailusuario'] ?? '',
          rol: 'usuario',
          fotoPerfil: json['fotoPerfil'],
          status: json['status'] ?? true,
          confirmEmail: json['confirmEmail'] ?? false,
          telefono: json['telefono'],
          isOAuth: json['isOAuth'] ?? false,
          oauthProvider: json['oauthProvider'],
        );
    }
  }

  // Convierte el objeto Usuario a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'fotoPerfil': fotoPerfil,
      'status': status,
      'confirmEmail': confirmEmail,
      'isOAuth': isOAuth,
      'oauthProvider': oauthProvider,
    };

    if (cedula != null) data['cedula'] = cedula;
    if (telefono != null) data['telefono'] = telefono;
    if (celular != null) data['celular'] = celular;
    if (emailAlternativo != null) data['emailAlternativo'] = emailAlternativo;
    if (fechaNacimiento != null) {
      data['fechaNacimiento'] = fechaNacimiento!.toIso8601String();
    }
    if (fechaIngreso != null) {
      data['fechaIngreso'] = fechaIngreso!.toIso8601String();
    }

    return data;
  }

  // Crea una copia del usuario con campos modificados
  Usuario copyWith({
    String? id,
    String? nombre,
    String? email,
    String? rol,
    String? fotoPerfil,
    bool? status,
    bool? confirmEmail,
    String? cedula,
    String? telefono,
    String? celular,
    String? emailAlternativo,
    DateTime? fechaNacimiento,
    DateTime? fechaIngreso,
    bool? isOAuth,
    String? oauthProvider,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      status: status ?? this.status,
      confirmEmail: confirmEmail ?? this.confirmEmail,
      cedula: cedula ?? this.cedula,
      telefono: telefono ?? this.telefono,
      celular: celular ?? this.celular,
      emailAlternativo: emailAlternativo ?? this.emailAlternativo,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      isOAuth: isOAuth ?? this.isOAuth,
      oauthProvider: oauthProvider ?? this.oauthProvider,
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nombre: $nombre, email: $email, rol: $rol}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Métodos útiles
  bool get esAdministrador => rol == 'Administrador';
  bool get esEnfermero => rol == 'enfermero';
  bool get esUsuario => rol == 'usuario';
  bool get esEstudiante => rol == 'estudiante';
  bool get esDocente => rol == 'docente';
  bool get esOAuth => isOAuth;

  String get nombreCompleto => nombre;
  
  String get fotoPerfilUrl {
    final placeholder =
        'https://cdn-icons-png.flaticon.com/512/4715/4715329.png';
    if (fotoPerfil == null || fotoPerfil!.trim().isEmpty) return placeholder;
    final f = fotoPerfil!.trim();
    if (f.startsWith('http')) return f;
    // si viene una ruta relativa (p.ej. /uploads/...), la normalizamos con baseUrl
    var base = ApiConfig.baseUrl;
    // baseUrl contiene '/api' al final; si la ruta ya incluye '/api' o '/uploads' manejamos sin duplicar
    if (f.startsWith('/')) {
      // quitar '/api' si base termina en '/api' para apuntar al host
      if (base.endsWith('/api')) {
        base = base.replaceFirst('/api', '');
      }
      return base + f;
    }
    // caso: ruta sin slash inicial
    if (base.endsWith('/')) {
      return base + f;
    }
    return '$base/$f';
  }
}