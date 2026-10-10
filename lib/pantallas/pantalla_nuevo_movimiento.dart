import 'package:flutter/material.dart';
import '../configuracion/constantes.dart';
import '../configuracion/rutas.dart';
import '../modelos/movimiento.dart';
import '../servicios/servicio_acceso.dart';
import '../servicios/servicio_movimientos.dart';
import '../widgets/boton_pildora.dart';
import '../widgets/campo_texto.dart';
import '../widgets/mensajes.dart';

class PantallaNuevoMovimiento extends StatefulWidget {
  const PantallaNuevoMovimiento({super.key});

  @override
  State<PantallaNuevoMovimiento> createState() => _PantallaNuevoMovimientoState();
}

class _PantallaNuevoMovimientoState extends State<PantallaNuevoMovimiento> {
  final _concepto = TextEditingController();
  final _monto = TextEditingController();
  final _fechaTexto = TextEditingController();
  DateTime? _fecha;
  bool _cargando = false;

  @override
  void dispose() {
    _concepto.dispose();
    _monto.dispose();
    _fechaTexto.dispose();
    super.dispose();
  }

  // Sin restricción: se puede elegir cualquier fecha
  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (elegida != null) {
      setState(() {
        _fecha = elegida;
        _fechaTexto.text = Movimiento.formatearFecha(elegida);
      });
    }
  }

  Future<void> _guardar() async {
    final concepto = _concepto.text.trim();
    final textoMonto = _monto.text.trim().replaceAll(',', '.');

    if (concepto.isEmpty || textoMonto.isEmpty || _fecha == null) {
      mostrarMensaje(context, 'Completa todos los campos', esError: true);
      return;
    }
    final monto = double.tryParse(textoMonto);
    if (monto == null || monto <= 0) {
      mostrarMensaje(context, 'Escribe un monto mayor a 0', esError: true);
      return;
    }

    setState(() => _cargando = true);
    try {
      await ServicioMovimientos.crear(concepto, monto, _fecha!);
      if (!mounted) return;
      mostrarMensaje(context, 'Movimiento guardado');
      Navigator.pop(context, true); // true = se creó algo, hay que refrescar la lista
    } on SesionExpirada {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Rutas.login, (ruta) => false);
    } on ErrorAcceso catch (e) {
      if (!mounted) return;
      mostrarMensaje(context, e.mensaje, esError: true);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colores.azulOscuro,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Nuevo movimiento',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colores.azulOscuro,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Se guardará como pendiente.',
                style: TextStyle(fontSize: 16, color: Colores.grisAzulado),
              ),
              const SizedBox(height: 32),
              CampoTexto(
                controlador: _concepto,
                etiqueta: 'Concepto',
                icono: Icons.description_outlined,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controlador: _monto,
                etiqueta: 'Monto (Bs)',
                icono: Icons.attach_money,
                tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controlador: _fechaTexto,
                etiqueta: 'Fecha',
                icono: Icons.calendar_today_outlined,
                soloLectura: true,
                alTocar: _elegirFecha,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 58,
                child: _cargando
                    ? const Center(
                  child: CircularProgressIndicator(color: Colores.verdeOscuro),
                )
                    : BotonPildora(
                  texto: 'Guardar',
                  icono: Icons.check,
                  alPresionar: _guardar,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}