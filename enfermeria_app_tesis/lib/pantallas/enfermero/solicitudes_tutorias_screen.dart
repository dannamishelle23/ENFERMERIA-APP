import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class SolicitudesTutoriasScreen extends StatefulWidget {
  final Usuario usuario;

  const SolicitudesTutoriasScreen({super.key, required this.usuario});

  @override
  State<SolicitudesTutoriasScreen> createState() =>
      _SolicitudesTutoriasScreenState();
}

class _SolicitudesTutoriasScreenState extends State<SolicitudesTutoriasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Tutorías'),
      ),
      body: const Center(
        child: Text('Pantalla de Solicitudes de Tutorías'),
      ),
    );
  }
}
