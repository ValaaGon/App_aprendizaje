import 'package:app_tesis/app/auth_services.dart';
import 'package:app_tesis/widget/TextFormField.dart';
import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = authService.value.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (_newPassController.text.isNotEmpty &&
        _currentPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu contraseña actual')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Actualizar nombre
      await authService.value.updateUsername(
        username: _nameController.text.trim(),
      );

      // Actualizar contraseña si se proporcionó
      if (_newPassController.text.isNotEmpty) {
        await authService.value.resetPassword(
          pass: _currentPassController.text.trim(),
          newPass: _newPassController.text.trim(),
          email: _emailController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/perfil.png',
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                // Campo nombre
                CustomTextFormField(
                  controller: _nameController,
                  label: 'Nombre',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  prefixIcon: Icons.email,
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: _currentPassController,
                  label: 'Contraseña actual',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: _newPassController,
                  label: 'Nueva contraseña',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 30),
                // Botón guardar
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Guardar cambios'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
