import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/takmir/databases/takmir_database.dart';

class TakmirModel {
  String? id;
  String? nama;
  String? photoUrl;
  String? jabatan;
  TakmirDatabase? dao;

  TakmirModel({this.id, this.nama, this.photoUrl, this.jabatan, this.dao});

  save() async {
    if (this.id == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  saveWithDetails(File foto) async {
    if (this.id == null) {
      await this.dao!.store(this);
    } else {
      await this.dao!.update(this);
    }
    return await this.dao!.upload(this, foto);
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  deleteWithDetails() async {
    await this.dao!.deleteFromStorage(this);
    return await this.dao!.delete(this);
  }

  TakmirModel fromSnapshot(DocumentSnapshot snapshot, TakmirDatabase dao) {
    return TakmirModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      jabatan: snapshot.data()?["jabatan"],
      photoUrl: snapshot.data()?["photoUrl"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'jabatan': this.jabatan,
      'photoUrl': this.photoUrl,
    };
  }
}
