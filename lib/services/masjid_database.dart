// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mosq/integrations/firestore.dart';
// import 'package:mosq/models/masjid.dart';
// import 'package:mosq/models/user.dart';

// class MasjidDatabase {
//   static final CollectionReference db =
//       firebaseFirestore.collection(masjidCollection);

//   CollectionReference inventarises(MasjidModel model) {
//     return db.doc(model.id).collection(inventarisCollection);
//   }

//   Future<DocumentSnapshot> getMasjid(UserModel model) async {
//     return await db.doc(model.masjid).get();
//   }

//   Stream<List<MasjidModel>> masjidStream() async* {
//     yield* firebaseFirestore
//         .collection(masjidCollection)
//         // .orderBy('nama')
//         .snapshots()
//         .map((QuerySnapshot query) {
//       List<MasjidModel> list = [];
//       query.docs.forEach((element) {
//         list.add(MasjidModel.fromSnapshot(element));
//       });
//       return list;
//     });
//   }

//   Future store(MasjidModel model) async {
//     DocumentReference result = await db.add({
//       'nama': model.nama,
//     });
//     model.id = result.id;
//     return result;
//   }

//   Future update(MasjidModel model) async {
//     return await db.doc(model.id).set({
//       'nama': model.nama,
//     });
//   }

//   Future delete(MasjidModel model) async {
//     return await db.doc(model.id).delete();
//   }
// }
