import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/kas/databases/kas_database.dart';
import 'package:mosq/modules/kas/kategori/kategori_database.dart';

class KategoriModel {
  String? id;
  String? nama;
  String? jenis;
  KategoriDatabase? dao;

  KategoriModel({this.id, this.nama, this.jenis, this.dao});

  save() async {
    if (this.id == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  // saveWithDetails(File foto) async {
  //   if (this.id == null) {
  //     await this.dao!.store(this);
  //   } else {
  //     await this.dao!.update(this);
  //   }
  //   // return await this.dao!.upload(this, foto);
  // }

  delete() async {
    return await this.dao!.delete(this);
  }

  // deleteWithDetails() async {
  //   await this.dao!.deleteFromStorage(this);
  //   return await this.dao!.delete(this);
  // }

  KategoriModel fromSnapshot(DocumentSnapshot snapshot, KategoriDatabase? dao) {
    return KategoriModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      jenis: snapshot.data()?["jenis"],
      // photoUrl: snapshot.data()?["photoUrl"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'jenis': this.jenis,
      // 'photoUrl': this.photoUrl,
    };
  }
}
