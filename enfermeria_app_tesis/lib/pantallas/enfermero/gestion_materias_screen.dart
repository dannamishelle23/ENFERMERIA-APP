import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class GestionMateriasScreen extends StatefulWidget {
  final Usuario usuario;

  const GestionMateriasScreen({super.key, required this.usuario});

  @override
  State<GestionMateriasScreen> createState() => _GestionMateriasScreenState();
}

class _GestionMateriasScreenState extends State<GestionMateriasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias'),
      ),
      body: const Center(
        child: Text('Pantalla de Gestión de Materias (Enfermero)'),
      ),
    );
  }
}
