import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';

class KasDatabase {
  final CollectionReference db;
  final Reference storage;
  bool? exist;
  KasDatabase({
    required this.db,
    required this.storage,
  });

  CollectionReference childReference(KasModel model, String collectionName) {
    return db.doc(model.id).collection(collectionName);
  }

  Stream<KasModel> streamDetailKas(KasModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => KasModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<KasModel>> kasStream(MasjidModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<KasModel> list = [];
      query.docs.forEach((element) {
        list.add(KasModel().fromSnapshot(element, model.kasDao!));
      });
      list.add(KasModel().getKasTotal(list));
      print(list.toString());
      return list;
    });
  }

  // Future<bool> checkKas(KasModel model) async {
  //   try {
  //     await db.doc(model.id)
  //   } catch (e) {
  //   }
  // }

  Future store(KasModel model) async {
    return await db.add(model.toSnapshot());
    // await db.add(model.toSnapshotKasTotal());
  }

  Future update(KasModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future updateFTransaksi(TransaksiModel model, KasModel kas) async {
    // DocumentReference kas = db.doc(model.kasID);
    // DocumentSnapshot kass = await transaction.call(kas);
    // return await db.doc(model.id).update(model.toSnapshot());
    // return await firebaseFirestore.runTransaction((transaction) async {
    //   // await db.doc(model.kasID).
    //   return transaction
    //       .update(db.doc(model.kasID), {'saldo': kas.saldo! + model.jumlah!});
    // });
  }

  Future delete(KasModel model) async {
    return await db.doc(model.id).delete();
  }

  Future deleteFromStorage(KasModel model) async {
    print(storage.child(model.id!));
    return storage.child(model.id!).delete();
  }

  // upload(KasModel model, File foto) async {
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
