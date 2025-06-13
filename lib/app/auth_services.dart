import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get userStream => firebaseAuth.authStateChanges();

  // Iniciar sesión con email y password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Crear cuenta y registrar usuario en Firestore con datos iniciales
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firestore.collection('usuarios').doc(cred.user!.uid).set({
      'nivel': 1,
      'email': email,
      'ejercicios_completados': [],
      'ejercicios_repetidos': [],
      'idEjercicioActual': '',
    });

    return cred;
  }

  // Enviar correo para restablecer contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Actualizar nombre de usuario (displayName)
  Future<void> updateUsername({
    required String username,
  }) async {
    await currentUser!.updateDisplayName(username);
    await currentUser!.reload();
  }

  // Eliminar cuenta después de reautenticación
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  // Cambiar contraseña después de reautenticación
  Future<void> resetPassword({
    required String pass,
    required String newPass,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: pass,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPass);
  }

  // Actualizar email y contraseña después de reautenticación
  Future<void> updateEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: currentUser!.email!,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updateEmail(newEmail);
  }
}
