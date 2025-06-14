import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ObtenerEjercicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<String> ordenTipos = ['Imagen', 'Sonido', 'oraciones']..shuffle();

  Future<Map<String, dynamic>> obtenerEjercicioActual() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final userRef = _db.collection('usuarios').doc(user.uid);
    final userDoc = await userRef.get();
    if (!userDoc.exists) return {};

    final datos = userDoc.data()!;
    int nivel = datos['nivel'] ?? 1;
    int contador = datos['contador'] ?? 0;

    if (contador >= 4) {
      if (nivel < 3) {
        await userRef.update({
          'nivel': nivel + 1,
          'contador': 0,
          'ejercicios_aprendidos': [],
          'ejercicios_repetidos': [],
        });
        return {'subioNivel': true};
      } else {
        await userRef.update({'contador': 0});
        return {'completo': true};
      }
    }

    final List<QueryDocumentSnapshot> candidatos = [];

    for (final tipo in ordenTipos) {
      if (nivel < 3) {
        final snapshot =
            await _db.collection(tipo).where('nivel', isEqualTo: nivel).get();

        for (final doc in snapshot.docs) {
          final id = doc.id;
          final aprendidos =
              List<String>.from(datos['ejercicios_aprendidos'] ?? []);
          if (!aprendidos.contains(id)) {
            candidatos.add(doc);
          }
        }
      } else {
        for (int n = 1; n <= 2; n++) {
          final snapshot =
              await _db.collection(tipo).where('nivel', isEqualTo: n).get();
          candidatos.addAll(snapshot.docs);
        }
      }
    }

    if (candidatos.isEmpty) return {};

    candidatos.shuffle();
    final ejercicioSeleccionado = candidatos.first;

    final tipoSeleccionado = ordenTipos.firstWhere(
      (tipo) => ejercicioSeleccionado.reference.parent.id == tipo,
      orElse: () => '',
    );

    final ejercicioMap =
        _formatearEjercicio(ejercicioSeleccionado, tipoSeleccionado);
    ejercicioMap['nivel'] = nivel;

    return ejercicioMap;
  }

  Future<void> marcarAprendido(String idEjercicio) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = _db.collection('usuarios').doc(user.uid);
    final userDoc = await userRef.get();
    final datos = userDoc.data()!;
    final nivel = datos['nivel'] ?? 1;
    final aprendidos = List<String>.from(datos['ejercicios_aprendidos'] ?? []);
    int contador = datos['contador'] ?? 0;

    if (nivel == 3 && aprendidos.contains(idEjercicio)) {
      await userRef.update({
        'ejercicios_repetidos': FieldValue.arrayUnion([idEjercicio]),
        'contador': contador + 1,
      });
    } else {
      await userRef.update({
        'ejercicios_aprendidos': FieldValue.arrayUnion([idEjercicio]),
        'contador': contador + 1,
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
