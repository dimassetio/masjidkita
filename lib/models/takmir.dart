import 'package:cloud_firestore/cloud_firestore.dart';

class TakmirModel {
  String? id;
  String? nama;
  String? photoUrl;
  String? jabatan;

  TakmirModel({
    this.id,
    this.nama,
    this.photoUrl,
    this.jabatan,
  });

  TakmirModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    nama = snapshot.data()?["nama"];
    photoUrl = snapshot.data()?["photoUrl"];
    jabatan = snapshot.data()?["jabatan"];
  }
}
