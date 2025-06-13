import 'package:flutter/material.dart';
import 'package:app_tesis/widget/Alternativas.dart';

class EjercicioOraciones extends StatefulWidget {
  final Map<String, dynamic> ejercicio;
  final Future<void> Function() cargarSiguienteEjercicio;

  const EjercicioOraciones({
    Key? key,
    required this.ejercicio,
    required this.cargarSiguienteEjercicio,
  }) : super(key: key);

  @override
  State<EjercicioOraciones> createState() => _EjercicioOracionesState();
}

class _EjercicioOracionesState extends State<EjercicioOraciones> {
  bool _respuestaCorrecta = false;

  void _activarBotonSiguiente() async {
    if (!_respuestaCorrecta && mounted) {
      setState(() => _respuestaCorrecta = true);
      await Future.delayed(const Duration(seconds: 1));
      await widget.cargarSiguienteEjercicio();
      if (mounted) setState(() => _respuestaCorrecta = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final oracion = widget.ejercicio["oracion"] as String;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Selecciona la palabra correcta:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Text(
                oracion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 40),
              Alternativas(
                ejercicio: widget.ejercicio,
                onRespuestaCorrecta: _activarBotonSiguiente,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
