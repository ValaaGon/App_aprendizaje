import 'package:flutter/material.dart';
import 'package:app_tesis/Pages/Main/Ejercicios/basico/juegos/imagen_palabra.dart';
import 'package:app_tesis/Pages/Main/Ejercicios/basico/juegos/escuha_selecciona.dart';
import 'package:app_tesis/Pages/Main/Ejercicios/basico/juegos/ejercicio_oraciones.dart';
import 'package:app_tesis/Pages/Main/Ejercicios/basico/obtenerEjBasico.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ObtenerEjercicio _obtenerEjercicio = ObtenerEjercicio();
  Map<String, dynamic>? _ejercicioActual;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarSiguienteEjercicio();
  }

  Future<void> _cargarSiguienteEjercicio() async {
    setState(() => _cargando = true);

    final nuevoEjercicio = await _obtenerEjercicio.obtenerEjercicioActual();

    if (nuevoEjercicio.isEmpty) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('¡Nivel completado!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.star_rounded, size: 64, color: Colors.amber),
                SizedBox(height: 12),
                Text('Has completado todos los ejercicios de este nivel.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );

      final siguienteEjercicio =
          await _obtenerEjercicio.obtenerEjercicioActual();
      setState(() {
        _ejercicioActual = siguienteEjercicio;
        _cargando = false;
      });
      return;
    }

    setState(() {
      _ejercicioActual = nuevoEjercicio;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: Color(0xFFFEE1DD),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_ejercicioActual == null || _ejercicioActual!.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFFEE1DD),
        body: Center(child: Text("No hay más ejercicios disponibles.")),
      );
    }

    final nivel = _ejercicioActual!["nivel"] ?? '?';

    return Scaffold(
      backgroundColor: const Color(0xFFFEE1DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF545979),
        title:
            Text('Nivel $nivel', style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: _buildEjercicio(),
    );
  }

  Widget _buildEjercicio() {
    switch (_ejercicioActual!["tipo"]) {
      case "imagen_palabra":
        return ImagenPalabra(
          ejercicio: _ejercicioActual!,
          cargarSiguienteEjercicio: _cargarSiguienteEjercicio,
        );
      case "escucha_selecciona":
        return EscuchaSelecciona(
          ejercicio: _ejercicioActual!,
          cargarSiguienteEjercicio: _cargarSiguienteEjercicio,
        );
      case "oraciones":
        return EjercicioOraciones(
          ejercicio: _ejercicioActual!,
          cargarSiguienteEjercicio: _cargarSiguienteEjercicio,
        );
      default:
        return const Center(child: Text("Tipo de ejercicio no soportado."));
    }
  }
}
