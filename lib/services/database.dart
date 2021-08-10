// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/models/inventaris.dart';
// import 'package:path/path.dart';

class Database {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _inventarisCollection =
      firebaseFirestore.collection('inventaris');

  Future<void> addInventaris(String? nama, String? kondisi, int? jumlah,
      String? foto, int? harga, String? url) async {
    DateTime now = DateTime.now();
    int hargaTotal = harga! * jumlah!;
    print(harga);
    try {
      await firebaseFirestore.collection("inventaris").add({
        'nama': nama,
        'foto': foto,
        'url': url,
        'jumlah': jumlah,
        'kondisi': kondisi,
        'createdAt': now,
        'harga': harga,
        'hargaTotal': hargaTotal,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateInventaris(String? nama, String? kondisi, int? jumlah,
      String? foto, String? inventarisID, int? harga) async {
    DateTime now = DateTime.now();
    try {
      await firebaseFirestore
          .collection("inventaris")
          .doc(inventarisID)
          .update({
        'nama': nama,
        'foto': foto,
        'jumlah': jumlah,
        'kondisi': kondisi,
        'harga': harga,
        'updatedAt': now,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<InventarisModel>> inventarisStream() {
    return firebaseFirestore
        .collection("inventaris")
        .snapshots()
        .map((QuerySnapshot query) {
      List<InventarisModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(InventarisModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  // Stream<List<TakmirModel>> takmirStream(String mID) {
  //   return _firestore
  //       .collection("masjid")
  //       .doc(mID)
  //       .collection("takmir")
  //       .orderBy("createdAt")
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<TakmirModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TakmirModel.fromDocumentSnapshot(element));
  //     });
  //     print(mID);
  //     return retVal;
  //   });
  // }

  deleteInventaris(
    inventarisID,
    // foto
  ) {
    firebaseFirestore.collection("inventaris").doc(inventarisID).delete();
    // var imageRef = firebaseStorage.ref().child(
    //     'inventaris/18ae6632-7083-49dd-b0d3-e7a617346b564771009612812182052.jpg');
    // imageRef.delete();
    // print(imageRef);
    // firebaseStorage
    //     .refFromURL("gs://mosq-2d58e.appspot.com//Inventaris/${foto}")
    //     .delete();
    // print(foto);
  }

  // deleteTakmir(tID, mID) {
  //   _firestore
  //       .collection("masjid")
  //       .doc(mID)
  //       .collection("takmir")
  //       .doc(tID)
  //       .delete();
  // }

  // getInventaris() async {
  //   DocumentSnapshot snapshot;
  //   final data = await firebaseFirestore
  //       .collection("inventaris")
  //       .doc('inventarisID')
  //       .get();
  //   snapshot = data;
  // try {
  //   DocumentSnapshot _doc = await firebaseFirestore
  //       .collection("inventaris")
  //       .doc(inventarisID)
  //       .get();
  //   InventarisModel.fromDocumentSnapshot(documentSnapshot: _doc);
  // } catch (e) {
  //   print(e);
  // }
  // }

  Future<InventarisModel> getInventaris(String inventarisID) async {
    DocumentSnapshot doc = await firebaseFirestore
        .collection("inventaris")
        .doc(inventarisID)
        .get();
    return InventarisModel.fromDocumentSnapshot(doc);
    // try {
    //   DocumentSnapshot doc = await firebaseFirestore
    //       .collection("inventaris")
    //       .doc(inventarisID)
    //       .get();
    //   return InventarisModel.fromDocumentSnapshot();
    // } catch (e) {
    //   print(e);
    // }
  }

  // Stream<QuerySnapshot> getInventaris() {
  //   CollectionReference inventarisCollection =
  //       _inventarisCollection.doc(inventarisID).collection('inventaris');

  //   return inventarisCollection.snapshots();
  // }

  // static Future<String> uploadImage(File imageFile) async {
  //   String fileName = basename(imageFile.path);

  //   StorageReference ref = firebaseStorage.ref().child(fileName);
  //   StorageUploadTask task = ref.putFile(imageFile);
  //   StorageTaskSnapshot snapshot = await task.onComplete;

  //   return await snapshot.ref.getDownloadURL();
  // }
}
