import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/profile/models/masjid_model.dart';
import 'package:mosq/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MasjidDatabase {
  static final CollectionReference db =
      firebaseFirestore.collection(masjidCollection);
  static final Reference storage =
      firebaseStorage.ref().child(masjidCollection);

  Reference inventarisStorage(MasjidModel model) {
    return storage.child(model.id ?? "").child(inventarisCollection);
  }

  CollectionReference inventarises(MasjidModel model) {
    return db.doc(model.id).collection(inventarisCollection);
  }

  Future<DocumentSnapshot> getMasjid(UserModel model) async {
    return await db.doc(model.masjid).get();
  }

  Stream<List<MasjidModel>> masjidStream() async* {
    yield* firebaseFirestore
        .collection(masjidCollection)
        // .orderBy('nama')
        .snapshots()
        .map((QuerySnapshot query) {
      List<MasjidModel> list = [];
      query.docs.forEach((element) {
        list.add(MasjidModel.fromSnapshot(element));
      });
      return list;
    });
  }

  Future store(MasjidModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    return result;
  }

  Future update(MasjidModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(MasjidModel model) async {
    return await db.doc(model.id).delete();
  }

  Future upload(MasjidModel model, File foto) {
    var path = storage.child(model.id!);
    return path.putFile(foto);
  }
}
