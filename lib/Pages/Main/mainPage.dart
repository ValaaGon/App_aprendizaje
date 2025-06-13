import 'package:app_tesis/Pages/Login/login.dart';
import 'package:app_tesis/Pages/Main/Ejercicios/jugar.dart';
import 'package:app_tesis/Pages/Main/perfil.dart';
import 'package:app_tesis/app/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  final List<Widget> _screens = [
    const Jugar(),
    const Perfil(),
  ];

  void popPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await authService.value.signOut();
      popPage();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF545879),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bienvenido, ${user?.displayName ?? 'Usuario'}',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 237, 240, 241),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Cerrar sesión',
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  _signOut();
                }
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Jugar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: const Color(0xFFb9d9e4),
        unselectedItemColor: const Color(0xFF9eb1cf),
        backgroundColor: const Color(0xFF545979),
      ),
    );
  }
}
