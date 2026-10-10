import 'package:flutter/material.dart';
import '../configuracion/constantes.dart';

class CampoTexto extends StatefulWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final IconData icono;
  final bool esContrasena;
  final bool habilitado;
  final TextInputType tipoTeclado;

  const CampoTexto({
    super.key,
    required this.controlador,
    required this.etiqueta,
    required this.icono,
    this.esContrasena = false,
    this.habilitado = true,
    this.tipoTeclado = TextInputType.text,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool _oculto = true;

  OutlineInputBorder _borde(Color color, [double grosor = 1.5]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: color, width: grosor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controlador,
      enabled: widget.habilitado,
      keyboardType: widget.tipoTeclado,
      obscureText: widget.esContrasena && _oculto,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        labelStyle: const TextStyle(color: Colores.grisAzulado),
        floatingLabelStyle: const TextStyle(color: Colores.verdeOscuro),
        prefixIcon: Icon(widget.icono, color: Colores.verdeOscuro),
        suffixIcon: widget.esContrasena
            ? IconButton(
          icon: Icon(
            _oculto ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colores.grisAzulado,
          ),
          onPressed: () => setState(() => _oculto = !_oculto),
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: _borde(Colores.verdeClaro),
        enabledBorder: _borde(Colores.verdeClaro),
        focusedBorder: _borde(Colores.verdeOscuro, 2),
      ),
    );
  }
}