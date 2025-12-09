import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class ReportesAdminScreen extends StatefulWidget {
  final Usuario usuario;

  const ReportesAdminScreen({super.key, required this.usuario});

  @override
  State<ReportesAdminScreen> createState() => _ReportesAdminScreenState();
}

class _ReportesAdminScreenState extends State<ReportesAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: const Center(
        child: Text('Pantalla de Reportes (Admin)'),
      ),
    );
  }
}
