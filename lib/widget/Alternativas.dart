import 'package:app_tesis/Pages/Main/Ejercicios/basico/obtenerEjBasico.dart';
import 'package:flutter/material.dart';

class Alternativas extends StatefulWidget {
  final Map<String, dynamic> ejercicio;
  final VoidCallback onRespuestaCorrecta;

  const Alternativas({
    Key? key,
    required this.ejercicio,
    required this.onRespuestaCorrecta,
  }) : super(key: key);

  @override
  State<Alternativas> createState() => _AlternativasState();
}

class _AlternativasState extends State<Alternativas> {
  String? _respuestaSeleccionada;
  bool _respuestaCorrecta = false;

  Future<void> _verificarRespuesta(String seleccion) async {
    final correcta = widget.ejercicio['respuesta_correcta'];
    final id = widget.ejercicio['id'];

    setState(() {
      _respuestaSeleccionada = seleccion;
      _respuestaCorrecta = (seleccion == correcta);
    });

    if (_respuestaCorrecta) {
      await ObtenerEjercicio().marcarAprendido(id);
      await Future.delayed(const Duration(milliseconds: 800));
      widget.onRespuestaCorrecta();
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _respuestaSeleccionada = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrecto. Intenta otra vez.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final opciones =
        widget.ejercicio['opciones'] ?? widget.ejercicio['alternativas'] ?? [];

    return Container(
      color: const Color(0xFFFEE1DD),
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: opciones.map<Widget>((opcion) {
          final estaSeleccionado = _respuestaSeleccionada == opcion;

          Color backgroundColor;
          if (estaSeleccionado) {
            backgroundColor = _respuestaCorrecta ? Colors.green : Colors.red;
          } else {
            backgroundColor = const Color(0xFFCEA0AA); // rosado original
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 240,
              child: InkWell(
                onTap: _respuestaSeleccionada == null
                    ? () => _verificarRespuesta(opcion)
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    opcion,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
