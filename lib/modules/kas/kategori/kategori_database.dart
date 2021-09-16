import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';

class KategoriDatabase {
  final CollectionReference? db;
  KategoriDatabase({
    this.db,
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
