import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/inventaris/databases/inventaris_database.dart';
import 'package:mosq/modules/masjid/databases/masjid_database.dart';

class InventarisModel {
  String? inventarisID;
  String? nama;
  String? foto;
  String? url;
  int? jumlah;
  String? kondisi;
  int? harga;
  int? hargaTotal;
  // InventarisDatabase dao = new InventarisDatabase(
  //     collections: MasjidDatabase.db, storage: MasjidDatabase.storage);
  InventarisDatabase? dao;

  InventarisModel({
    this.inventarisID,
    this.nama,
    this.foto,
    this.url,
    this.jumlah,
    this.kondisi,
    this.harga,
    this.hargaTotal,
    this.dao,
  });

  static attributeName(String attribute) {
    var lang = {
      'nama': 'Nama',
      'kondisi': 'kondisi',
      'harga': 'Harga',
      'jumlah': 'Jumlah',
      'foto': 'Foto',
      'url': 'Url',
      'hargaTotal': 'HargaTotal',
    };
    return lang[attribute];
  }

  save() async {
    if (this.inventarisID == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  calculateTotal() {
    return harga! * jumlah!;
  }

  InventarisModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    inventarisID = documentSnapshot.id;
    nama = documentSnapshot.data()?["nama"];
    foto = documentSnapshot.data()?["foto"];
    url = documentSnapshot.data()?["url"];
    jumlah = documentSnapshot.data()?["jumlah"];
    kondisi = documentSnapshot.data()?["kondisi"];
    harga = documentSnapshot.data()?["harga"];
    hargaTotal = documentSnapshot.data()?["hargaTotal"];
  }

  InventarisModel fromSnapshot(
      DocumentSnapshot snapshot, InventarisDatabase dao) {
    return InventarisModel(
      inventarisID: snapshot.id,
      nama: snapshot.data()?["nama"],
      foto: snapshot.data()?["foto"],
      url: snapshot.data()?["url"],
      jumlah: snapshot.data()?["jumlah"],
      kondisi: snapshot.data()?["kondisi"],
      harga: snapshot.data()?["harga"],
      hargaTotal: snapshot.data()?["hargaTotal"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'inventarisID': this.inventarisID,
      'nama': this.nama,
      'foto': this.foto,
      'url': this.url,
      'jumlah': this.jumlah,
      'kondisi': this.kondisi,
      'harga': this.harga,
      'hargaTotal': this.hargaTotal
    };
  }
}

// class ListInventarisModel {
//   String? inventarisID;
//   String? nama;
//   String? foto;
//   String? url;
//   int? jumlah;
//   String? kondisi;
//   int? harga;
//   int? hargaTotal;

//   ListInventarisModel({
//     // @required this.inventarisID,
//     this.nama,
//     this.foto,
//     this.url,
//     this.jumlah,
//     this.kondisi,
//     this.harga,
//     this.hargaTotal,
//   });

//   ListInventarisModel.fromDocumentSnapshot(
//     DocumentSnapshot documentSnapshot,
//   ) {
//     inventarisID = documentSnapshot.id;
//     nama = documentSnapshot["nama"];
//     foto = documentSnapshot["foto"];
//     url = documentSnapshot["url"];
//     jumlah = documentSnapshot["jumlah"];
//     kondisi = documentSnapshot["kondisi"];
//     harga = documentSnapshot["harga"];
//     hargaTotal = documentSnapshot["hargaTotal"];
//   }
// }
