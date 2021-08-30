import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/modules/profile/databases/masjid_database.dart';
import 'package:mosq/modules/profile/models/masjid_model.dart';

class InventarisDatabase {
  // static final Reference storage = firebaseStorage
  //     .ref()
  //     .child(masjidCollection)
  //     .child()
  //     .child(inventarisCollection);

  // CollectionReference inventarises(MasjidModel model) {
  //   return MasjidDatabase.db.doc(model.id).collection(inventarisCollection);
  // }

  final CollectionReference collections;
  final Reference storage;
  InventarisDatabase({
    required this.collections,
    required this.storage,
  });

  Future<DocumentSnapshot> getInventaris(InventarisModel model) async {
    return await collections.doc(model.inventarisID).get();
  }

  ///Stream
  Stream<List<InventarisModel>> inventarisStream() {
    return collections.snapshots().map((QuerySnapshot query) {
      List<InventarisModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(InventarisModel.fromDocumentSnapshot(element));
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
      'foto': model.foto,
      'url': model.url,
      'hargaTotal': model.calculateTotal(),
    };
  }

  // Future store(InventarisModel model) async {
  //   DocumentReference result = await collections.add(getData(model));
  //   model.inventarisID = result.id;
  //   return result;
  // }

  Future store(InventarisModel model) async {
    DocumentReference result = await collections.add(model.toSnapshot());
    model.inventarisID = result.id;
    return result;
  }

  // Future update(InventarisModel model) async {
  //   return await collections.doc(model.inventarisID).set(getData(model));
  // }

  Future update(InventarisModel model) async {
    return await collections.doc(model.inventarisID).update(model.toSnapshot());
  }

  Future delete(InventarisModel model) async {
    return await collections.doc(model.inventarisID).delete();
  }

  Future upload(InventarisModel model, File foto) {
    var path = storage.child(model.inventarisID!);
    return path.putFile(foto);
  }
}
