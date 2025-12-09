import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class VerDisponibilidadEnfermerosScreen extends StatefulWidget {
  final Usuario usuario;

  const VerDisponibilidadEnfermerosScreen({super.key, required this.usuario});

  @override
  State<VerDisponibilidadEnfermerosScreen> createState() =>
      _VerDisponibilidadEnfermerosScreenState();
}

class _VerDisponibilidadEnfermerosScreenState
    extends State<VerDisponibilidadEnfermerosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disponibilidad de Enfermeros'),
      ),
      body: const Center(
        child: Text('Pantalla de Ver Disponibilidad de Enfermeros'),
      ),
    );
  }
}
