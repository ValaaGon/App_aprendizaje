import 'package:flutter/material.dart';
import 'package:app_tesis/widget/Alternativas.dart';

class ImagenPalabra extends StatefulWidget {
  final Map<String, dynamic> ejercicio;
  final Future<void> Function() cargarSiguienteEjercicio;

  const ImagenPalabra({
    Key? key,
    required this.ejercicio,
    required this.cargarSiguienteEjercicio,
  }) : super(key: key);

  @override
  State<ImagenPalabra> createState() => _ImagenPalabraState();
}

class _ImagenPalabraState extends State<ImagenPalabra> {
  bool _isLoadingImage = true;
  bool _respuestaCorrecta = false;

  @override
  void initState() {
    super.initState();
    _preloadImage();
  }

  Future<void> _preloadImage() async {
    final path = widget.ejercicio["imagen"];
    if (path == null) {
      if (mounted) setState(() => _isLoadingImage = false);
      return;
    }

    try {
      await precacheImage(AssetImage(path), context);
    } catch (e) {
      print("Error al cargar imagen: $path");
    } finally {
      if (mounted) {
        setState(() => _isLoadingImage = false);
      }
    }
  }

  void _respuestaCorrectaHandler() async {
    if (!_respuestaCorrecta && mounted) {
      setState(() => _respuestaCorrecta = true);
      await Future.delayed(const Duration(seconds: 1));
      await widget.cargarSiguienteEjercicio();
      if (mounted) setState(() => _respuestaCorrecta = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              _isLoadingImage
                  ? const SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : (widget.ejercicio["imagen"] != null
                      ? Image.asset(
                          widget.ejercicio["imagen"],
                          width: 200,
                          height: 200,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 80),
                        )
                      : const Icon(Icons.image_not_supported, size: 80)),
              const SizedBox(height: 50),
              if (!_isLoadingImage)
                Column(
                  children: [
                    Alternativas(
                      ejercicio: widget.ejercicio,
                      onRespuestaCorrecta: _respuestaCorrectaHandler,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
