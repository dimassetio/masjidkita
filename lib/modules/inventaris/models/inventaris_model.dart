import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/inventaris/databases/inventaris_database.dart';

class InventarisModel {
  String? id;
  String? nama;
  String? photoUrl;
  int? jumlah;
  String? kondisi;
  int? harga;
  int? hargaTotal;
  // InventarisDatabase dao = new InventarisDatabase(
  //     collections: MasjidDatabase.db, storage: MasjidDatabase.storage);
  InventarisDatabase? dao;

  InventarisModel({
    this.id,
    this.nama,
    this.photoUrl,
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
      'photoUrl': 'photoUrl',
      'hargaTotal': 'HargaTotal',
    };
    return lang[attribute];
  }

  save() async {
    if (this.id == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  saveWithDetails(File fotos) async {
    if (this.id == null) {
      await this.dao!.store(this);
    } else {
      await this.dao!.update(this);
    }
    return await this.dao!.upload(this, fotos);
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  deleteWithDetails() async {
    await this.dao!.deleteFromStorage(this);
    return await this.dao!.delete(this);
  }

  calculateTotal() {
    return harga! * jumlah!;
  }

  InventarisModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    id = documentSnapshot.id;
    nama = documentSnapshot.data()?["nama"];
    photoUrl = documentSnapshot.data()?["photoUrl"];
    jumlah = documentSnapshot.data()?["jumlah"];
    kondisi = documentSnapshot.data()?["kondisi"];
    harga = documentSnapshot.data()?["harga"];
    hargaTotal = documentSnapshot.data()?["hargaTotal"];
  }

  InventarisModel fromSnapshot(
      DocumentSnapshot snapshot, InventarisDatabase dao) {
    return InventarisModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      photoUrl: snapshot.data()?["photoUrl"],
      jumlah: snapshot.data()?["jumlah"],
      kondisi: snapshot.data()?["kondisi"],
      harga: snapshot.data()?["harga"],
      hargaTotal: snapshot.data()?["hargaTotal"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'photoUrl': this.photoUrl,
      'jumlah': this.jumlah,
      'kondisi': this.kondisi,
      'harga': this.harga,
      'hargaTotal': this.hargaTotal
    };
  }
}

// class ListInventarisModel {
//   String? id;
//   String? nama;
//   
//   String? photoUrl;
//   int? jumlah;
//   String? kondisi;
//   int? harga;
//   int? hargaTotal;

//   ListInventarisModel({
//     // @required this.id,
//     this.nama,
//     this.foto,
//     this.photoUrl,
//     this.jumlah,
//     this.kondisi,
//     this.harga,
//     this.hargaTotal,
//   });

//   ListInventarisModel.fromDocumentSnapshot(
//     DocumentSnapshot documentSnapshot,
//   ) {
//     id = documentSnapshot.id;
//     nama = documentSnapshot["nama"];
//     foto = documentSnapshot["foto"];
//     photoUrl = documentSnapshot["photoUrl"];
//     jumlah = documentSnapshot["jumlah"];
//     kondisi = documentSnapshot["kondisi"];
//     harga = documentSnapshot["harga"];
//     hargaTotal = documentSnapshot["hargaTotal"];
//   }
// }
