import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/models/masjid.dart';
import 'package:mosq/services/masjid_database.dart';

class InventarisDatabase {
  // static final CollectionReference db = MasjidDatabase().inventarises();
  // CollectionReference inventarises(MasjidModel model) {
  //   return MasjidDatabase.db.doc(model.id).collection(inventarisCollection);
  // }

  final CollectionReference collections;
  InventarisDatabase({
    required this.collections,
  });

  ///Stream
  Stream<QuerySnapshot> get get {
    return collections.snapshots();
  }

  // Future<DocumentSnapshot> getInventaris(MasjidModel model) async {
  //   return await MasjidDatabase().doc(model.id).get();
  // }

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

  Future store(InventarisModel model) async {
    DocumentReference result = await collections.add(getData(model));
    model.inventarisID = result.id;
    return result;
  }

  Future update(InventarisModel model) async {
    return await collections.doc(model.inventarisID).set(getData(model));
  }

  Future delete(InventarisModel model) async {
    return await collections.doc(model.inventarisID).delete();
  }
}
