import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/kas/databases/kas_database.dart';
import 'package:mosq/modules/kas/databases/kategori_database.dart';

class KasModel {
  String? id;
  String? nama;
  int? saldoAwal;
  int? saldo;
  String? deskripsi;
  KasDatabase? dao;
  KategoriDatabase? kategoriDao;

  KasModel(
      {this.id,
      this.nama,
      this.saldoAwal,
      this.saldo,
      this.deskripsi,
      this.dao}) {
    if (dao != null) {
      kategoriDao =
          KategoriDatabase(db: dao!.childReference(this, kategoriCollection));
    }
  }

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
    // return await this.dao!.upload(this, foto);
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  deleteWithDetails() async {
    await this.dao!.deleteFromStorage(this);
    return await this.dao!.delete(this);
  }

  KasModel getKasTotal(List<KasModel> kases) {
    int result = 0;
    for (var kas in kases) {
      result = result + kas.saldo!;
    }
    return KasModel(
        nama: "Kas Total",
        saldo: result,
        deskripsi: "Akumulasi dari keseluruhan Buku Kas");
  }

  KasModel fromSnapshot(DocumentSnapshot snapshot, KasDatabase dao) {
    return KasModel(
      id: snapshot.id,
      nama: snapshot.data()?["nama"],
      saldoAwal: snapshot.data()?["saldoAwal"],
      saldo: snapshot.data()?["saldo"],
      deskripsi: snapshot.data()?["deskripsi"],
      // photoUrl: snapshot.data()?["photoUrl"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'nama': this.nama,
      'saldoAwal': this.saldoAwal,
      'saldo': this.saldo,
      'deskripsi': this.deskripsi,
      // 'photoUrl': this.photoUrl,
    };
  }

  Map<String, dynamic> toSnapshotKasTotal() {
    return {
      'id': "kasTotal",
      'nama': "Kas Total",
      'saldoAwal': this.saldoAwal,
      'saldo': this.saldo,
      'deskripsi': "Akumulasi dari keseluruhan Buku Kas",
      // 'photoUrl': this.photoUrl,
    };
  }
}

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
