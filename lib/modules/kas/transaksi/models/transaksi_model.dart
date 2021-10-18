import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/transaksi/databases/transaksi_database.dart';

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

  TransaksiModel({
    this.id,
    this.toKas,
    this.kategoriID,
    this.photoUrl,
    this.tanggal,
    this.jumlah,
    this.keterangan,
    this.kategori,
    this.tipeTransaksi,
    this.dao,
    this.fromKas,
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
      toKas: snapshot.data()?["kas"]?[1],
      kategoriID: snapshot.data()?["kategoriID"],
      photoUrl: snapshot.data()?["url"],
      tanggal: snapshot.data()?["tanggal"].toDate(),
      jumlah: snapshot.data()?["jumlah"],
      keterangan: snapshot.data()?["keterangan"],
      kategori: snapshot.data()?["kategori"],
      tipeTransaksi: snapshot.data()?["tipeTransaksi"],
      fromKas: snapshot.data()?["kas"][0],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'url': this.photoUrl,
      'toKas': this.toKas,
      'kas': [this.fromKas, this.toKas],
      'kategoriID': this.kategoriID,
      'jumlah': this.jumlah,
      'tanggal': this.tanggal,
      'keterangan': this.keterangan,
      'kategori': this.kategori,
      'tipeTransaksi': this.tipeTransaksi,
      'from_kas': this.fromKas,
    };
  }
}