import 'package:app_tesis/Pages/Main/Ejercicios/basico/MainPageBasico.dart';
import 'package:app_tesis/widget/Botones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Jugar extends StatefulWidget {
  const Jugar({super.key});

  @override
  State<Jugar> createState() => _JugarState();
}

class _JugarState extends State<Jugar> {
  bool _completo = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _verificarProgreso();
  }

  Future<void> _verificarProgreso() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      if (!mounted) return;

      setState(() {
        _completo = doc.data()?['completo'] == true;
        _cargando = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/main.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Botón centrado
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Boton(
                    texto:
                        _completo ? '¡Nivel completado!' : 'Comenzar a Jugar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      ).then((_) => _verificarProgreso());
                    },
                    enabled: !_completo,
                  ),
                ),
                const SizedBox(height: 16),
                if (_completo)
                  const Text(
                    '¡Felicidades! Has completado todos los niveles.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 19, 18, 18),
                      fontSize: 16,
                      shadows: [],
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
