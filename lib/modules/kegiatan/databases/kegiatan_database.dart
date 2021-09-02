import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';

class KegiatanDatabase {
  final CollectionReference db;
  final Reference storage;
  KegiatanDatabase({
    required this.db,
    required this.storage,
  });

  static final CollectionReference userDB =
      firebaseFirestore.collection(usersCollection);

  Stream<KegiatanModel> streamDetailKegiatan(KegiatanModel model) {
    return db
        .doc(model.id)
        .snapshots()
        .map((event) => KegiatanModel().fromSnapshot(event, model.dao!));
  }

  Stream<List<KegiatanModel>> kegiatanStream(MasjidModel model) async* {
    yield* db.snapshots().map((QuerySnapshot query) {
      List<KegiatanModel> list = [];
      print("dao = ${model.kegiatanDao}");
      query.docs.forEach((element) {
        list.add(KegiatanModel().fromSnapshot(element, model.kegiatanDao!));
      });
      return list;
    });
  }

  Future store(KegiatanModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    await userDB.doc(authController.user.id).update({'kegiatan': result.id});
    return result;
  }

  Future update(KegiatanModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
  }

  Future delete(KegiatanModel model) async {
    return await db.doc(model.id).delete();
  }

  Future deleteFromStorage(KegiatanModel model) async {
    print(storage.child(model.id!));
    return storage.child(model.id!).delete();
  }

  upload(KegiatanModel model, File foto) async {
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
