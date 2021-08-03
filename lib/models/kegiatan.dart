import 'package:cloud_firestore/cloud_firestore.dart';

class KegiatanModel {
  String? kegiatanID;
  String? nama;
  String? foto;
  String? url;
  String? deskripsi;
  // DateTime? tanggal;

  KegiatanModel({
    // @required this.inventarisID,
    this.nama,
    this.foto,
    this.url,
    this.deskripsi,
    // this.tanggal
  });

  KegiatanModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    kegiatanID = documentSnapshot.id;
    nama = documentSnapshot.data()?["nama"];
    foto = documentSnapshot.data()?["foto"];
    url = documentSnapshot.data()?["url"];
    deskripsi = documentSnapshot.data()?["deskripsi"];
    // tanggal = documentSnapshot.data()?["tanggal"];
  }
}

class ListKegiatanModel {
  String? kegiatanID;
  String? nama;
  String? foto;
  String? url;
  String? deskripsi;
  // DateTime? tanggal;

  ListKegiatanModel({
    // @required this.KegiatanID,
    this.kegiatanID,
    this.nama,
    this.foto,
    this.url,
    this.deskripsi,
    // this.tanggal,
  });

  ListKegiatanModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    kegiatanID = documentSnapshot.id;
    nama = documentSnapshot["nama"];
    foto = documentSnapshot["foto"];
    url = documentSnapshot["url"];
    deskripsi = documentSnapshot["deskripsi"];
    // tanggal = documentSnapshot["tanggal"];
  }
}
