import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MasjidDatabase {
  static final CollectionReference db =
      firebaseFirestore.collection(masjidCollection);
  static final Reference storage =
      firebaseStorage.ref().child(masjidCollection);

  static final CollectionReference userDB =
      firebaseFirestore.collection(usersCollection);

  CollectionReference inventarises(MasjidModel model) {
    return db.doc(model.id).collection(inventarisCollection);
  }

  CollectionReference takmirs(MasjidModel model) {
    return db.doc(model.id).collection(takmirCollection);
  }

  Reference takmirStorage(MasjidModel model) {
    return storage.child(model.id ?? "");
  }

  Stream<MasjidModel> streamDetailMasjid(MasjidModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => MasjidModel().fromSnapshot(event));
  }

  Stream<List<MasjidModel>> masjidStream() async* {
    yield* firebaseFirestore
        .collection(masjidCollection)
        // .orderBy('nama')
        .snapshots()
        .map((QuerySnapshot query) {
      List<MasjidModel> list = [];
      query.docs.forEach((element) {
        list.add(MasjidModel().fromSnapshot(element));
      });
      return list;
    });
  }

  Future store(MasjidModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    await userDB.doc(authController.user.id).update({'masjid': result.id});
    return result;
  }

  Future update(MasjidModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(MasjidModel model) async {
    return await db.doc(model.id).delete();
  }

  upload(MasjidModel model, File foto) async {
    var path = storage.child(model.id!).child('Foto Profil');
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
