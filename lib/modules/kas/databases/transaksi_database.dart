import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/modules/kas/databases/kas_database.dart';
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
      query.docs.forEach((element) {
        list.add(TransaksiModel().fromSnapshot(element, model.transaksiDao!));
      });
      print("List Transaksi $list");
      return list;
    });
  }

  Stream<int> getSumTransaksi(MasjidModel model, KasModel kas) async* {
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
      print("Total = $total");
      return total;
    });
  }

  // Future<bool> checkTransaksi(TransaksiModel model) async {
  //   try {
  //     await db.doc(model.id)
  //   } catch (e) {
  //   }
  // }

  Future store(TransaksiModel model) async {
    // firebaseFirestore.runTransaction((transaction) async {
    //   DocumentReference fromKas =
    //       firebaseFirestore.collection('kas').doc(model.fromKas);
    //   DocumentSnapshot dataKas = await transaction.get(fromKas);
    //   int jumlah = dataKas.data()?['saldo'] - model.jumlah!;
    //   transaction.update(fromKas, {'saldo': 25000});
    // });
    return await db.add(model.toSnapshot());
    // await db.add(model.toSnapshotTransaksiTotal());
  }

  Future update(TransaksiModel model) async {
    return await db.doc(model.fromKas).update(model.toSnapshot());
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
