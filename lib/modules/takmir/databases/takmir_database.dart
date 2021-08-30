import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';

class TakmirDatabase {
  final CollectionReference db;
  final Reference storage;
  TakmirDatabase({
    required this.db,
    required this.storage,
  });

  static final CollectionReference userDB =
      firebaseFirestore.collection(usersCollection);

  Stream<TakmirModel> streamDetailTakmir(TakmirModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => TakmirModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<TakmirModel>> takmirStream(MasjidModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<TakmirModel> list = [];
      print("dao = ${model.takmirDao}");
      query.docs.forEach((element) {
        list.add(TakmirModel().fromSnapshot(element, model.takmirDao!));
      });
      return list;
    });
  }

  Future store(TakmirModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    await userDB.doc(authController.user.id).update({'takmir': result.id});
    return result;
  }

  Future update(TakmirModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(TakmirModel model) async {
    return await db.doc(model.id).delete();
  }

  upload(TakmirModel model, File foto) async {
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
