import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/databases/transaksi_database.dart';

class TransaksiModel {
  String? id;
  int? tipeTransaksi;
  String? kategoriID;
  String? kategori;
  String? keterangan;
  int? jumlah;
  String? fromKas;
  String? toKas;
  String? photoUrl;
  DateTime? tanggal;
  TransaksiDatabase? dao;

  int? jenis; //Testing Only
<<<<<<< HEAD
  String? fromKas; //Testing Only

  TransaksiModel({
    this.id,
    this.kasID,
=======

  TransaksiModel({
    this.id,
    this.toKas,
>>>>>>> 7abc64ae864a26fedee5a063ddc69227b92d807e
    this.kategoriID,
    this.photoUrl,
    this.tanggal,
    this.jumlah,
    this.keterangan,
    this.kategori,
    this.tipeTransaksi,
    this.dao,
    this.fromKas, //Testing Only
    this.jenis, //Testing Only
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

  // calculateTotal() {
  //   return harga! * jumlah!;
  // }

  TransaksiModel fromSnapshot(
      DocumentSnapshot snapshot, TransaksiDatabase dao) {
    return TransaksiModel(
      id: snapshot.id,
      toKas: snapshot.data()?["toKas"],
      kategoriID: snapshot.data()?["kategoriID"],
      photoUrl: snapshot.data()?["url"],
      tanggal: snapshot.data()?["tanggal"],
      jumlah: snapshot.data()?["jumlah"],
      keterangan: snapshot.data()?["keterangan"],
      kategori: snapshot.data()?["kategori"],
      tipeTransaksi: snapshot.data()?["tipeTransaksi"],
<<<<<<< HEAD
      jenis: snapshot.data()?["jenis"], //testing only
      fromKas: snapshot.data()?["fromKas"], //testing only
=======
      fromKas: snapshot.data()?["fromKas"],
>>>>>>> 7abc64ae864a26fedee5a063ddc69227b92d807e
      dao: dao,
      jenis: snapshot.data()?["jenis"], //testing only
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'url': this.photoUrl,
<<<<<<< HEAD
      'kasID': this.kasID,
=======
      'toKas': this.toKas,
>>>>>>> 7abc64ae864a26fedee5a063ddc69227b92d807e
      'kategoriID': this.kategoriID,
      'jumlah': this.jumlah,
      'tanggal': this.tanggal,
      'keterangan': this.keterangan,
      'kategori': this.kategori,
      'tipeTransaksi': this.tipeTransaksi,
      'jenis': this.jenis,
      'from_kas': this.fromKas,
    };
  }
}
