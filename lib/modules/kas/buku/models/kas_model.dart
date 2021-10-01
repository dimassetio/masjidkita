import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/buku/databases/kas_database.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/modules/kas/periode/periode_database.dart';
import 'package:mosq/modules/kas/periode/periode_model.dart';

class KasModel {
  String? id;
  String? nama;
  int? saldoAwal;
  int? saldo;
  String? deskripsi;
  KasDatabase? dao;
  DateTime? tanggalAwal;
  DateTime? tanggalAkhir;
  PeriodeDatabase? periodeDao;

  KasModel(
      {this.id,
      this.nama,
      this.saldoAwal,
      this.saldo,
      this.deskripsi,
      this.tanggalAwal,
      this.tanggalAkhir,
      this.dao}) {
    if (dao != null) {
      periodeDao = PeriodeDatabase(db: dao!.db.doc(id).collection('periode'));
    }
  }

  save() async {
    if (this.id == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  getPeriodeDao() {
    if (this.id != null && this.id != '') {
      this.periodeDao =
          PeriodeDatabase(db: this.dao!.db.doc(id).collection('periode'));
    }
  }

  saveToKas() async {
    if (this.id != null) {
      return await this.dao!.updateFTransaksi(TransaksiModel(), this);
    }
  }

  saveWithDetails(PeriodeModel periode) async {
    if (this.id == null) {
      await this.dao!.store(this);
      this.getPeriodeDao();
      periode.dao = this.periodeDao;
      await periode.save();
    } else {
      await this.dao!.update(this);
    }
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  deleteWithDetails() async {
    await this.dao!.deleteFromStorage(this);
    return await this.dao!.delete(this);
  }

  find() async {
    return await this.dao!.findDetail(this);
  }

  addPeriode(PeriodeModel periode) {
    this.saldoAwal = periode.saldoAwal;
    this.tanggalAwal = periode.tanggalAwal;
    this.tanggalAkhir = periode.tanggalAkhir;
    return this;
  }

  KasModel getKasTotal(List<KasModel> kases) {
    int result = 0;
    for (var kas in kases) {
      result = result + kas.saldo!;
    }
    return KasModel(
        id: 'KasTotal',
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
