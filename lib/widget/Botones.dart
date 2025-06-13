import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const Boton({
    Key? key,
    required this.texto,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCEA0AA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.black45,
        minimumSize: const Size(double.infinity, 45),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
