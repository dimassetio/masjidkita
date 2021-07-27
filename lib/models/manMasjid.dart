import 'package:cloud_firestore/cloud_firestore.dart';

class ManMasjidModel {
  static const ID = "id";
  static const NAMA = "nama";
  static const ALAMAT = "alamat";
  static const PHOTOURL = "photo_url";

  String? id;
  String? nama;
  String? alamat;
  String? photoUrl;
  String? deskripsi;
  String? kecamatan;
  String? kodePos;
  String? kota;
  String? provinsi;
  String? tahun;
  String? luasTanah;
  String? luasBangunan;
  String? statusTanah;
  String? legalitas;

  ManMasjidModel({
    this.id,
    this.nama,
    this.alamat,
    this.photoUrl,
    this.deskripsi,
    this.kecamatan,
    this.kodePos,
    this.kota,
    this.provinsi,
    this.tahun,
    this.luasTanah,
    this.luasBangunan,
    this.statusTanah,
    this.legalitas,
  });

  ManMasjidModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    nama = snapshot.data()?[NAMA];
    alamat = snapshot.data()?[ALAMAT];
    photoUrl = snapshot.data()?[PHOTOURL];
    deskripsi = snapshot.data()?["deskripsi"];
    kecamatan = snapshot.data()?["kecamatan"];
    kodePos = snapshot.data()?["kodePos"];
    kota = snapshot.data()?["kota"];
    provinsi = snapshot.data()?["provinsi"];
    tahun = snapshot.data()?["tahun"];
    luasTanah = snapshot.data()?["luasTanah"];
    luasBangunan = snapshot.data()?["luasBangunan"];
    statusTanah = snapshot.data()?["statusTanah"];
    legalitas = snapshot.data()?["legalitas"];
  }
}

class DetailMasjidModel {
  static const ID = "id";
  static const NAMA = "nama";
  static const ALAMAT = "alamat";
  static const LASTLOGIN = "last_login";
  static const PHOTOURL = "photo_url";

  String? id;
  String? nama;
  String? alamat;
  String? photoUrl;
  String? deskripsi;
  String? kecamatan;
  String? kodePos;
  String? kota;
  String? provinsi;
  String? tahun;
  String? luasTanah;
  String? luasBangunan;
  String? statusTanah;
  String? legalitas;

  DetailMasjidModel({
    this.id,
    this.nama,
    this.alamat,
    this.photoUrl,
    this.deskripsi,
    this.kecamatan,
    this.kodePos,
    this.kota,
    this.provinsi,
    this.tahun,
    this.luasTanah,
    this.luasBangunan,
    this.statusTanah,
    this.legalitas,
  });

  DetailMasjidModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    nama = snapshot.data()?[NAMA];
    alamat = snapshot.data()?[ALAMAT];
    photoUrl = snapshot.data()?[PHOTOURL];
    deskripsi = snapshot.data()?["deskripsi"];
    kecamatan = snapshot.data()?["kecamatan"];
    kodePos = snapshot.data()?["kodePos"];
    kota = snapshot.data()?["kota"];
    provinsi = snapshot.data()?["provinsi"];
    tahun = snapshot.data()?["tahun"];
    luasTanah = snapshot.data()?["luasTanah"];
    luasBangunan = snapshot.data()?["luasBangunan"];
    statusTanah = snapshot.data()?["statusTanah"];
    legalitas = snapshot.data()?["legalitas"];
  }
}

class ListMasjidModel {
  String? nama;
  String? alamat;
  String? id;
  // Timestamp dateCreated;

  ListMasjidModel({
    this.nama,
    this.alamat,
  });

  ListMasjidModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    id = documentSnapshot.id;
    nama = documentSnapshot.data()?["nama"];
    alamat = documentSnapshot.data()?["alamat"];
  }
}

class FavoritMasjidModel {
  String? nama;
  String? alamat;
  String? id;
  // Timestamp dateCreated;

  FavoritMasjidModel({
    this.nama,
    this.alamat,
  });

  FavoritMasjidModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    id = documentSnapshot.id;
    nama = documentSnapshot.data()?["nama"];
    alamat = documentSnapshot.data()?["alamat"];
  }
}
