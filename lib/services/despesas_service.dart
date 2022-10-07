import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services.dart';

class DespesasService {
  AuthService authService = AuthService();
  final List<Map<String, dynamic>> despesas = [];

  DespesasService();

  getDespesas() async {
    var db = FirebaseFirestore.instance;

    await db.collection("profiles").get().then((event) async {
      for (var doc in event.docs) {
        if (doc.data()['email'] == authService.usuario?.email) {
          await db
              .collection('profiles')
              .doc(doc.id)
              .collection('despesas')
              .get()
              .then((value) {
            for (var doc in value.docs) {
              despesas.add(doc.data());
            }
          });
        }
      }
    });
    return despesas;
  }

  setDespesa(
    BuildContext context, {
    required Map<String, dynamic> despesa,
  }) async {
    var db = FirebaseFirestore.instance;

    await db.collection("profiles").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()['email'] == authService.usuario?.email) {
          db
              .collection('profiles')
              .doc(doc.id)
              .collection('despesas')
              .add(despesa);
        }
      }
    });
  }
}
