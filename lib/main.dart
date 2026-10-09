import 'package:flutter/material.dart';
import 'configuracion/tema.dart';
import 'pantallas/pantalla_inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHC Estudiantil',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      home: const PantallaInicio(),
    );
  }
}