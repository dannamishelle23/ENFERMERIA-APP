import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class GestionHorariosScreen extends StatefulWidget {
  final Usuario usuario;

  const GestionHorariosScreen({super.key, required this.usuario});

  @override
  State<GestionHorariosScreen> createState() => _GestionHorariosScreenState();
}

class _GestionHorariosScreenState extends State<GestionHorariosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Horarios'),
      ),
      body: const Center(
        child: Text('Pantalla de Gestión de Horarios'),
      ),
    );
  }
}
