import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/databases/masjid_database.dart';

class MasjidModel {
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
  MasjidDatabase dao = new MasjidDatabase();

  MasjidModel({
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

  MasjidModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    nama = snapshot.data()?["nama"];
    alamat = snapshot.data()?["alamat"];
    photoUrl = snapshot.data()?["photoUrl"];
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

  save() async {
    if (this.id == null) {
      return await this.dao.store(this);
    } else {
      return await this.dao.update(this);
    }
  }

  delete() async {
    return await this.dao.delete(this);
  }
}
