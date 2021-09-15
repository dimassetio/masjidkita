import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';

class InventarisDatabase {
  // static final Reference storage = firebaseStorage
  //     .ref()
  //     .child(masjidCollection)
  //     .child()
  //     .child(inventarisCollection);

  // CollectionReference inventarises(MasjidModel model) {
  //   return MasjidDatabase.db.doc(model.id).collection(inventarisCollection);
  // }

  final CollectionReference db;
  final Reference storage;
  InventarisDatabase({
    required this.db,
    required this.storage,
  });

  Future<DocumentSnapshot> getInventaris(InventarisModel model) async {
    return await db.doc(model.id).get();
  }

  ///Stream
  Stream<InventarisModel> streamDetailInventaris(InventarisModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => InventarisModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<InventarisModel>> inventarisStream(MasjidModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<InventarisModel> retVal = [];
      query.docs.forEach((element) {
        retVal
            .add(InventarisModel().fromSnapshot(element, model.inventarisDao!));
      });
      return retVal;
    });
  }

  //Single
  Map<String, dynamic> getData(InventarisModel model) {
    return {
      'nama': model.nama,
      'kondisi': model.kondisi,
      'harga': model.kondisi,
      'jumlah': model.jumlah,
      'photoUrl': model.photoUrl,
      'hargaTotal': model.calculateTotal(),
    };
  }

  // Future store(InventarisModel model) async {
  //   DocumentReference result = await db.add(getData(model));
  //   model.id = result.id;
  //   return result;
  // }

  Future store(InventarisModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    return result;
  }

  // Future update(InventarisModel model) async {
  //   return await db.doc(model.id).set(getData(model));
  // }

  Future update(InventarisModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(InventarisModel model) async {
    return await db.doc(model.id).delete();
  }

  Future deleteFromStorage(InventarisModel model) async {
    print(storage.child(model.id!));
    if (storage.child(model.id!) == null) {
      print("No such image on storage");
    } else {
      storage.child(model.id!).delete();
    }
  }

  Future upload(InventarisModel model, File foto) async {
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
