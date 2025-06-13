import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:app_tesis/widget/Alternativas.dart';

class EscuchaSelecciona extends StatefulWidget {
  final Map<String, dynamic> ejercicio;
  final Future<void> Function() cargarSiguienteEjercicio;

  const EscuchaSelecciona({
    Key? key,
    required this.ejercicio,
    required this.cargarSiguienteEjercicio,
  }) : super(key: key);

  @override
  _EscuchaSeleccionaState createState() => _EscuchaSeleccionaState();
}

class _EscuchaSeleccionaState extends State<EscuchaSelecciona> {
  late final FlutterTts _tts;
  bool _isPlaying = false;
  bool _respuestaCorrecta = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts()
      ..setCompletionHandler(() {
        if (mounted) setState(() => _isPlaying = false);
      });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _reproducirSonido() async {
    if (_isPlaying) return;

    if (mounted) setState(() => _isPlaying = true);
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(0.5);
    await _tts.speak(widget.ejercicio["texto_a_leer"] ?? "");
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 300),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.volume_off : Icons.volume_up,
                size: 50,
                color: _isPlaying ? Colors.grey : const Color(0xFF545979),
              ),
              onPressed: _reproducirSonido,
            ),
            const SizedBox(height: 30),
            Alternativas(
              ejercicio: widget.ejercicio,
              onRespuestaCorrecta: _respuestaCorrectaHandler,
            ),
          ],
        ),
      ),
    );
  }
}
