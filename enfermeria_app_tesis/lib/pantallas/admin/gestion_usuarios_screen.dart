import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class GestionUsuariosScreen extends StatefulWidget {
  final Usuario usuario;

  const GestionUsuariosScreen({super.key, required this.usuario});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
      ),
      body: const Center(
        child: Text('Pantalla de Gestión de Usuarios'),
      ),
    );
  }
}
