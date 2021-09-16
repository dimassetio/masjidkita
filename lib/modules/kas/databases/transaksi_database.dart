import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';

class TransaksiDatabase {
  final CollectionReference db;
  final Reference storage;
  TransaksiDatabase({
    required this.db,
    required this.storage,
  });

  CollectionReference childReference(
      TransaksiModel model, String collectionName) {
    return db.doc(model.id).collection(collectionName);
  }

  Stream<TransaksiModel> streamDetailTransaksi(TransaksiModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => TransaksiModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<TransaksiModel>> transaksiStream(MasjidModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<TransaksiModel> list = [];
      print("dao = ${model.transaksiDao}");
      query.docs.forEach((element) {
        list.add(TransaksiModel().fromSnapshot(element, model.transaksiDao!));
      });
      return list;
    });
  }

  // Future<bool> checkTransaksi(TransaksiModel model) async {
  //   try {
  //     await db.doc(model.id)
  //   } catch (e) {
  //   }
  // }

  Future store(TransaksiModel model) async {
    return await db.add(model.toSnapshot());
    // await db.add(model.toSnapshotTransaksiTotal());
  }

  Future update(TransaksiModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(TransaksiModel model) async {
    return await db.doc(model.id).delete();
  }

  Future deleteFromStorage(TransaksiModel model) async {
    print(storage.child(model.id!));
    return storage.child(model.id!).delete();
  }

  upload(TransaksiModel model, File foto) async {
    var path = storage.child(model.id!);
    UploadTask task = path.putFile(foto);
    task.snapshotEvents.listen((event) async {
      if (event.state == TaskState.success) {
        model.photoUrl = await path.getDownloadURL();
        update(model);
      }
    });
    return task;
  }
}
