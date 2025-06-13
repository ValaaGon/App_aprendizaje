import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ObtenerEjercicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _random = Random();

  final List<String> ordenTipos = ['Imagen', 'Sonido', 'oraciones'];

  Future<Map<String, dynamic>> obtenerEjercicioActual() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final userRef = _db.collection('usuarios').doc(user.uid);
    final userDoc = await userRef.get();
    if (!userDoc.exists) return {};

    final datos = userDoc.data()!;
    int nivel = datos['nivel'] ?? 1;
    final aprendidos = List<String>.from(datos['ejercicios_aprendidos'] ?? []);
    final repetidos = List<String>.from(datos['ejercicios_repetidos'] ?? []);

    for (final tipo in ordenTipos) {
      List<QueryDocumentSnapshot> disponibles = [];

      if (nivel < 3) {
        final snapshot =
            await _db.collection(tipo).where('nivel', isEqualTo: nivel).get();

        disponibles = snapshot.docs.where((doc) {
          return !aprendidos.contains(doc.id);
        }).toList();
      } else {
        for (int buscarNivel = 1; buscarNivel <= 3; buscarNivel++) {
          final snapshot = await _db
              .collection(tipo)
              .where('nivel', isEqualTo: buscarNivel)
              .get();

          final docs = snapshot.docs.where((doc) {
            final id = doc.id;
            final yaAprendido = aprendidos.contains(id);
            final yaRepetido = repetidos.contains(id);

            if (!yaAprendido) return true; // primera vez
            if (yaAprendido && !yaRepetido) return true;
            return false;
          }).toList();

          disponibles.addAll(docs);
        }
      }

      if (disponibles.isNotEmpty) {
        final ejercicio = disponibles[_random.nextInt(disponibles.length)];
        final ejercicioMap = _formatearEjercicio(ejercicio, tipo);
        ejercicioMap['nivel'] = nivel;
        return ejercicioMap;
      }
    }

    if (nivel < 3) {
      await userRef.update({'nivel': nivel + 1});
    }

    return {};
  }

  Future<void> marcarAprendido(String idEjercicio) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await _db.collection('usuarios').doc(user.uid).get();
    final datos = userDoc.data()!;
    final nivel = datos['nivel'] ?? 1;
    final aprendidos = List<String>.from(datos['ejercicios_aprendidos'] ?? []);

    if (nivel == 3 && aprendidos.contains(idEjercicio)) {
      await _db.collection('usuarios').doc(user.uid).update({
        'ejercicios_repetidos': FieldValue.arrayUnion([idEjercicio])
      });
    } else {
      await _db.collection('usuarios').doc(user.uid).update({
        'ejercicios_aprendidos': FieldValue.arrayUnion([idEjercicio])
      });
    }
  }

  Map<String, dynamic> _formatearEjercicio(DocumentSnapshot doc, String tipo) {
    switch (tipo) {
      case "Sonido":
        return {
          "id": doc.id,
          "tipo": "escucha_selecciona",
          "texto_a_leer": doc["oracion"] ?? "",
          "respuesta_correcta": doc["correcta"] ?? "",
          "opciones": List<String>.from(doc["alternativas"] ?? [])..shuffle(),
        };
      case "Imagen":
        final correcta = doc["correcta"];
        return {
          "id": doc.id,
          "tipo": "imagen_palabra",
          "imagen": "assets/$correcta.jpg",
          "opciones": List<String>.from(doc["palabra"] ?? [])..shuffle(),
          "respuesta_correcta": correcta,
        };
      case "oraciones":
        return {
          "id": doc.id,
          "tipo": "oraciones",
          "oracion": doc["oracion"] ?? "",
          "respuesta_correcta": doc["correcta"] ?? "",
          "alternativas": List<String>.from(doc["alternativas"] ?? [])
            ..shuffle(),
        };
      default:
        return {};
    }
  }
}
