// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mosq/modules/kas/databases/kategori_database.dart';
// import 'package:mosq/modules/masjid/databases/masjid_database.dart';

// class TransaksiModel {
//   String? id;
//   String? kasID;
//   String? kategoriID;
//   String? judul;
//   String? url;
//   Timestamp? tanggal;
//   int? jumlah;
//   String? keterangan;
//   String? tipeTransaksi;
//   TransaksiDatabase? dao;

//   TransaksiModel({
//     this.id,
//     this.kasID,
//     this.kategoriID,
//     this.judul,
//     this.url,
//     this.tanggal,
//     this.jumlah,
//     this.keterangan,
//     this.tipeTransaksi,
//     this.dao,
//   });


//   save() async {
//     if (this.id == null) {
//       return await this.dao!.store(this);
//     } else {
//       return await this.dao!.update(this);
//     }
//   }

//   saveWithDetails(File foto) async {
//     if (this.id == null) {
//       await this.dao!.store(this);
//     } else {
//       await this.dao!.update(this);
//     }
//     return await this.dao!.upload(this, foto);
//   }

//   delete() async {
//     return await this.dao!.delete(this);
//   }

//   deleteWithDetails() async {
//     await this.dao!.deleteFromStorage(this);
//     return await this.dao!.delete(this);
//   }

//   // calculateTotal() {
//   //   return harga! * jumlah!;
//   // }

//   TransaksiModel fromSnapshot(
//       DocumentSnapshot snapshot, TransaksiDatabase dao) {
//     return TransaksiModel(
//     id = snapshot.id,
//     judul = snapshot.data()?["judul"],
//     url = snapshot.data()?["url"],
//     tanggal = snapshot.data()?["tanggal"],
//     jumlah = snapshot.data()?["jumlah"],
//     keterangan = snapshot.data()?["keterangan"],
//     tipeTransaksi = snapshot.data()?["tipeTransaksi"]
//     );
//   }

//   Map<String, dynamic> toSnapshot() {
//     return {
//       'id': this.id,
//       'judul': this.judul,
//       'foto': this.foto,
//       'url': this.url,
//       'jumlah': this.jumlah,
//       'kondisi': this.kondisi,
//       'harga': this.harga,
//       'hargaTotal': this.hargaTotal
//     };
//   }
// }