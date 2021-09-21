import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/kategori/kategori_database.dart';

class KategoriModel {
  String? id;
  String? nama;
  int? jenis;
  KategoriDatabase? dao;

  KategoriModel({this.id, this.nama, this.jenis, this.dao});

  save() async {
    if (this.id == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  KategoriModel fromSnapshot(DocumentSnapshot snapshot, KategoriDatabase? dao) {
    return KategoriModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      jenis: snapshot.data()?["jenis"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'jenis': this.jenis,
    };
  }
}
