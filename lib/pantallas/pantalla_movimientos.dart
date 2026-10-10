import 'package:flutter/material.dart';
import '../configuracion/constantes.dart';
import '../configuracion/rutas.dart';
import '../servicios/servicio_acceso.dart';

class PantallaMovimientos extends StatefulWidget {
  const PantallaMovimientos({super.key});

  @override
  State<PantallaMovimientos> createState() => _PantallaMovimientosState();
}

class _PantallaMovimientosState extends State<PantallaMovimientos> {
  String? _nombre;

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  // Protección de la ruta: si no hay sesión válida, vuelve al login
  Future<void> _verificarSesion() async {
    String? nombre;
    try {
      nombre = await ServicioAcceso.obtenerNombreSesion();
    } on ErrorAcceso {
      nombre = null;
    }

    if (!mounted) return;
    if (nombre == null) {
      Navigator.pushReplacementNamed(context, Rutas.login);
      return;
    }
    setState(() => _nombre = nombre);
  }

  Future<void> _cerrarSesion() async {
    await ServicioAcceso.cerrarSesion();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Rutas.inicio, (ruta) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Mientras se verifica la sesión no se muestra contenido privado
    if (_nombre == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colores.verdeOscuro)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis movimientos'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colores.azulOscuro,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout, color: Colores.verdeOscuro),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $_nombre',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colores.azulOscuro,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aquí aparecerán tus ingresos y gastos.',
              style: TextStyle(fontSize: 16, color: Colores.grisAzulado),
            ),
          ],
        ),
      ),
    );
  }
}