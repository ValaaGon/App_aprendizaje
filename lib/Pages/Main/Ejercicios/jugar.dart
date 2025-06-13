import 'package:app_tesis/Pages/Main/Ejercicios/basico/MainPageBasico.dart';
import 'package:app_tesis/widget/Botones.dart';
import 'package:flutter/material.dart';

class Jugar extends StatefulWidget {
  const Jugar({super.key});

  @override
  State<Jugar> createState() => _JugarState();
}

class _JugarState extends State<Jugar> {
  @override
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
            child: SizedBox(
              width: 200,
              height: 50,
              child: Boton(
                texto: 'Comenzar a Jugar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
