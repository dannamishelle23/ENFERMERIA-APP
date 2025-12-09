import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class HistorialTutoriasAdminScreen extends StatefulWidget {
  final Usuario usuario;

  const HistorialTutoriasAdminScreen({super.key, required this.usuario});

  @override
  State<HistorialTutoriasAdminScreen> createState() =>
      _HistorialTutoriasAdminScreenState();
}

class _HistorialTutoriasAdminScreenState
    extends State<HistorialTutoriasAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Tutorías'),
      ),
      body: const Center(
        child: Text('Pantalla de Historial de Tutorías (Admin)'),
      ),
    );
  }
}
