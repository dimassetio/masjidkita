import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kegiatan/databases/kegiatan_database.dart';

class KegiatanModel {
  String? id;
  String? nama;
  String? photoUrl;
  String? deskripsi;
  DateTime? tanggal;
  KegiatanDatabase? dao;

  KegiatanModel({
    this.id,
    this.nama,
    this.photoUrl,
    this.deskripsi,
    this.tanggal,
    this.dao,
  });

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

  KegiatanModel fromSnapshot(DocumentSnapshot snapshot, KegiatanDatabase dao) {
    return KegiatanModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      deskripsi: snapshot.data()?["deskripsi"],
      photoUrl: snapshot.data()?["photoUrl"],
      tanggal: snapshot.data()?["tanggal"].toDate(),
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'deskripsi': this.deskripsi,
      'photoUrl': this.photoUrl,
      'tanggal': this.tanggal,
    };
  }
}
