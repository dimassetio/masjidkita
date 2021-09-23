import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/databases/transaksi_database.dart';

class TransaksiModel {
  String? id;
  String? kasID;
  String? kategoriID;
  String? photoUrl;
  DateTime? tanggal;
  int? jumlah;
  String? keterangan;
  String? kategori;
  String? tipeTransaksi;
  TransaksiDatabase? dao;

  int? jenis; //Testing Only
  String? fromKas; //Testing Only

  TransaksiModel({
    this.id,
    this.kasID,
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
      kasID: snapshot.data()?["kasID"],
      kategoriID: snapshot.data()?["kategoriID"],
      photoUrl: snapshot.data()?["photoUrl"],
      tanggal: snapshot.data()?["tanggal"],
      jumlah: snapshot.data()?["jumlah"],
      keterangan: snapshot.data()?["keterangan"],
      kategori: snapshot.data()?["kategori"],
      tipeTransaksi: snapshot.data()?["tipeTransaksi"],
      jenis: snapshot.data()?["jenis"], //testing only
      fromKas: snapshot.data()?["fromKas"], //testing only
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'photoUrl': this.photoUrl,
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
