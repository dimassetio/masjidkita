import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/periode/periode_model.dart';

class PeriodeDatabase {
  final CollectionReference db;
  PeriodeDatabase({
    required this.db,
  });

  Stream<PeriodeModel> streamDetailPeriode(PeriodeModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => PeriodeModel().fromSnapshot(event, model.dao!));
  }

  Future<PeriodeModel> getLatestPeriode(KasModel model) async {
    return await db
        .orderBy('tanggalAwal', descending: true)
        .snapshots()
        .first
        .then((value) =>
            PeriodeModel().fromSnapshot(value.docs[0], model.periodeDao!));
  }

  // Stream<List<PeriodeModel>> filterPeriodeStream(
  //     MasjidModel model, FilterPeriode? filter) async* {
  //   yield* db.filtering(filter).snapshots().map((QuerySnapshot query) {
  //     List<PeriodeModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(PeriodeModel().fromSnapshot(element, model.periodeDao!));
  //     });
  //     return retVal;
  //   });
  // }

  Stream<List<PeriodeModel>> periodeStream(KasModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<PeriodeModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(PeriodeModel().fromSnapshot(element, model.periodeDao));
      });
      return retVal;
    });
  }

  Future store(PeriodeModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    return result;
  }

  Future update(PeriodeModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(PeriodeModel model) async {
    return await db.doc(model.id).delete();
  }
}
