import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mobx/mobx.dart';
// import 'package:mosq/integrations/controllers.dart';
// import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:mosq/modules/kas/buku/databases/kas_database.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/transaksi/models/filter_model.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
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

  Stream<List<TransaksiModel>> transaksiStream(MasjidModel model,
      {FilterModel? filter}) async* {
    Query ref = db;
    if (filter != null) {
      ref = db.where(
        filter.field,
        isEqualTo: filter.value,
      );
    }
    yield* ref
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<TransaksiModel> list = [];
      query.docs.forEach((element) {
        list.add(TransaksiModel().fromSnapshot(element, model.transaksiDao!));
      });
      return list;
    });
  }

  Stream<int> getSumTransaksi(KasModel kas) async* {
    yield* db
        .where('from_kas', isEqualTo: kas.id)
        .snapshots()
        .map((QuerySnapshot query) {
      int total = 0;
      query.docs.forEach((element) {
        if (element.data()["tipeTransaksi"] == 10) {
          total = total + element.data()["jumlah"] as int;
        } else if (element.data()["tipeTransaksi"] == 20) {
          total = total - element.data()["jumlah"] as int;
        } else {
          print('Jenis e error bro');
        }
      });
      return total;
    });
  }

  Future calculateTransaksi(KasModel kas) async {
    var tes = db.where('from_kas', isEqualTo: kas.id).get().then((value) {
      int total = 0;
      // int totalTo = 0;
      value.docs.forEach((element) {
        if (element.data()["tipeTransaksi"] == 10) {
          total = total + element.data()["jumlah"] as int;
        } else if (element.data()["tipeTransaksi"] == 20) {
          total = total - element.data()["jumlah"] as int;
        } else if (element.data()["tipeTransaksi"] == 30) {
          total = total - element.data()["jumlah"] as int;
          // totalTo = totalTo + element.data()["jumlah"] as int;
        } else {
          print('Jenis e error bro');
        }
      });
      return total;
    });
    var tess = db.where('toKas', isEqualTo: kas.id).get().then((value) {
      int total = 0;
      // int totalTo = 0;
      value.docs.forEach((element) {
        if (element.data()["tipeTransaksi"] == 10) {
          total = total + element.data()["jumlah"] as int;
        } else if (element.data()["tipeTransaksi"] == 20) {
          total = total - element.data()["jumlah"] as int;
        } else if (element.data()["tipeTransaksi"] == 30) {
          total = total + element.data()["jumlah"] as int;
          // totalTo = totalTo + element.data()["jumlah"] as int;
        } else {
          print('Jenis e error bro');
        }
      });
      return total;
    });
    return await tes + await tess;
  }

  // Future<bool> checkTransaksi(TransaksiModel model) async {
  //   try {
  //     await db.doc(model.id)
  //   } catch (e) {
  //   }
  // }

  Future store(TransaksiModel model) async {
    DocumentReference result = await db.add(model.toSnapshot());
    model.id = result.id;
    return result;
  }

  Future update(TransaksiModel model) async {
    return await db.doc(model.id).update(model.toSnapshot());
    // return await firebaseFirestore.runTransaction((transaction) async {
    //   db.doc(kas.)
    // });
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
