import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class MisTutoriasScreen extends StatefulWidget {
  final Usuario usuario;

  const MisTutoriasScreen({super.key, required this.usuario});

  @override
  State<MisTutoriasScreen> createState() => _MisTutoriasScreenState();
}

class _MisTutoriasScreenState extends State<MisTutoriasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tutorías'),
      ),
      body: const Center(
        child: Text('Pantalla de Mis Tutorías'),
      ),
    );
  }
}
