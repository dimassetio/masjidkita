import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/kas/models/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';

class KategoriDatabase {
  final CollectionReference? db;
  final Reference storage;
  KategoriDatabase({
    this.db,
    required this.storage,
  });

  Stream<KategoriModel> streamDetailKategori(KategoriModel model) {
    return db!
        .doc(model.id)
        .snapshots()
        .map((event) => KategoriModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<KategoriModel>> kategoriStream(MasjidModel model) async* {
    yield* db!.snapshots().map((QuerySnapshot query) {
      List<KategoriModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(KategoriModel().fromSnapshot(element, model.kategoriDao!));
      });
      return retVal;
    });
  }

  Future store(KategoriModel model) async {
    DocumentReference result = await db!.add(model.toSnapshot());
    model.id = result.id;
    return result;
  }

  Future update(KategoriModel model) async {
    return await db!.doc(model.id).update(model.toSnapshot());
  }

  Future delete(KategoriModel model) async {
    return await db!.doc(model.id).delete();
  }
}
