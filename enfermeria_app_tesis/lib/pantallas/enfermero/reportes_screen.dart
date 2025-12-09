import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class ReportesScreen extends StatefulWidget {
  final Usuario usuario;

  const ReportesScreen({super.key, required this.usuario});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: const Center(
        child: Text('Pantalla de Reportes (Enfermero)'),
      ),
    );
  }
}
