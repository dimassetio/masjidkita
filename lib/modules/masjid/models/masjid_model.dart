import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/inventaris/databases/inventaris_database.dart';
import 'package:mosq/modules/kas/databases/kas_database.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/kas/databases/transaksi_database.dart';
import 'package:mosq/modules/kegiatan/databases/kegiatan_database.dart';
import 'package:mosq/modules/masjid/databases/masjid_database.dart';
import 'package:mosq/modules/takmir/databases/takmir_database.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';

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
  InventarisDatabase? inventarisDao;
  TakmirDatabase? takmirDao;
  KasDatabase? kasDao;
  KegiatanDatabase? kegiatanDao;
  TransaksiDatabase? transaksiDao;

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
  }) {
    inventarisDao = InventarisDatabase(
        db: dao.childReference(this, inventarisCollection),
        storage: dao.childStorage(this, inventarisCollection));
    kasDao = KasDatabase(
        db: dao.childReference(this, kasCollection),
        storage: dao.childStorage(this, kasCollection));
    takmirDao = TakmirDatabase(
        db: dao.childReference(this, takmirCollection),
        storage: dao.childStorage(this, takmirCollection));
    kegiatanDao = KegiatanDatabase(
        db: dao.childReference(this, kegiatanCollection),
        storage: dao.childStorage(this, kegiatanCollection));
    transaksiDao = TransaksiDatabase(
        db: dao.childReference(this, transaksiCollection),
        storage: dao.childStorage(this, transaksiCollection));
  }

  MasjidModel fromSnapshot(DocumentSnapshot snapshot) {
    return MasjidModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      alamat: snapshot.data()?["alamat"],
      photoUrl: snapshot.data()?["photoUrl"],
      deskripsi: snapshot.data()?["deskripsi"],
      kecamatan: snapshot.data()?["kecamatan"],
      kodePos: snapshot.data()?["kodePos"],
      kota: snapshot.data()?["kota"],
      provinsi: snapshot.data()?["provinsi"],
      tahun: snapshot.data()?["tahun"],
      luasTanah: snapshot.data()?["luasTanah"],
      luasBangunan: snapshot.data()?["luasBangunan"],
      statusTanah: snapshot.data()?["statusTanah"],
      legalitas: snapshot.data()?["legalitas"],
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'alamat': this.alamat,
      'photoUrl': this.photoUrl,
      'deskripsi': this.deskripsi,
      'kecamatan': this.kecamatan,
      'kodePos': this.kodePos,
      'kota': this.kota,
      'provinsi': this.provinsi,
      'tahun': this.tahun,
      'luasTanah': this.luasTanah,
      'luasBangunan': this.luasBangunan,
      'statusTanah': this.statusTanah,
      'legalitas': this.legalitas
    };
  }

  save() async {
    if (this.id == null) {
      return await this.dao.store(this);
    } else {
      return await this.dao.update(this);
    }
  }

  saveWithDetails(File foto) async {
    if (this.id == null) {
      await this.dao.store(this);
    } else {
      await this.dao.update(this);
    }
    return await this.dao.upload(this, foto);
  }

  delete() async {
    return await this.dao.delete(this);
  }

  Stream<List<TakmirModel>> get takmirs {
    return takmirDao!.takmirStream(this);
  }
}
