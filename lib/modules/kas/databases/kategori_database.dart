import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';

class KategoriDatabase {
  final CollectionReference db;
  KategoriDatabase({
    required this.db,
  });

  Stream<KategoriModel> streamDetailKategori(KategoriModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => KategoriModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<KategoriModel>> kategoriStream(MasjidModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<KategoriModel> list = [];
      print("dao = ${model.kategoriDao}");
      query.docs.forEach((element) {
        list.add(KategoriModel().fromSnapshot(element, model.kategoriDao!));
      });
      return list;
    });
  }

  Future store(KategoriModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    return result;
  }

  Future update(KategoriModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(KategoriModel model) async {
    return await db.doc(model.id).delete();
  }

  // upload(KategoriModel model, File foto) async {
  //   var path = storage.child(model.id!);
  //   UploadTask task = path.putFile(foto);
  //   task.snapshotEvents.listen((event) async {
  //     if (event.state == TaskState.success) {
  //       model.photoUrl = await path.getDownloadURL();
  //       update(model);
  //     }
  //   });
  //   return task;
  // }
}
