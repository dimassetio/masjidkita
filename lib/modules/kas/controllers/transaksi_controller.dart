import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/kas/databases/kas_database.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TransaksiController extends GetxController {
  static TransaksiController instance = Get.find();

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  var isSaving = false.obs;

  RxList<TransaksiModel> transaksiList = RxList<TransaksiModel>();
  List<TransaksiModel> get transaksies => transaksiList.value;

  Rx<TransaksiModel> _transaksiModel = TransaksiModel().obs;

  TransaksiModel get transaksi => _transaksiModel.value;

  List<KasModel> fromKases = kasC.kases;

  TextEditingController jumlah = TextEditingController();
  TextEditingController keterangan = TextEditingController();

  String? kategoriID;
  String? kategori;
  String? fromKas;
  String? toKas;
  int? tipeTransaksi;

  @override
  void onInit() {
    super.onInit();
  }

  getTransaksiStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    transaksiList.bindStream(model.transaksiDao!.transaksiStream(model));
  }

  Future delete(TransaksiModel model) async {
    // if (model.url.isEmptyOrNull) {
    //   return await model.delete();
    // } else
    //   return await model.deleteWithDetails();
    return await model.delete();
  }

  // updateKas(KasModel model) async {
  //   await model.sav
  // }

  KasModel kasModel = KasModel();
  KategoriModel kategoriModel = KategoriModel();
  var sumTransaksi = 0.obs;

  saveTransaksi(TransaksiModel model, {String? path}) async {
    isSaving.value = true;
    int sisaSaldo = kasModel.saldo!;
    sumTransaksi.bindStream(masjidC.currMasjid.transaksiDao!
        .getSumTransaksi(masjidC.currMasjid, kasModel));
    // sumTransaksi.value = model.transaksiDao!.getSumTransaksi(model, kasModel);
    int jumlahInt =
        jumlah.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    model.tipeTransaksi = tipeTransaksi;
    model.fromKas = kasModel.id;
    model.kategori = kategoriModel.nama;
    model.kategoriID = kategoriModel.id;
    model.photoUrl = path;
    model.jumlah = jumlahInt;
    model.keterangan = keterangan.text;
    model.toKas = toKas;
    model.tanggal = DateTime.now();
    int? totalNow;

    if (model.tipeTransaksi == 20) {
      jumlahInt = 0 - model.jumlah!;
    }
    totalNow = kasModel.saldoAwal! + sumTransaksi.value + jumlahInt;
    try {
      firebaseFirestore.runTransaction((transaction) async {
        CollectionReference colRef = kasModel.dao!.db;

        transaction.update(colRef.doc(kasModel.id), {'saldo': totalNow});
      });
    } catch (e) {
      print('transaksi error');
    } finally {
      model.save();
      print('transaksi sukses');
    }
    // int jumlahInt =
    //     jumlah.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    // model.tipeTransaksi = tipeTransaksi;
    // model.fromKas = kasModel.id;
    // model.kategori = kategoriModel.nama;
    // model.kategoriID = kategoriModel.id;
    // model.photoUrl = path;
    // model.jumlah = jumlahInt;
    // model.keterangan = keterangan.text;
    // model.toKas = toKas;
    // model.tanggal = DateTime.now();
    // var sumTransaksi = 0.obs;
    // sumTransaksi.bindStream(masjidC.currMasjid.transaksiDao!
    //     .getSumTransaksi(masjidC.currMasjid, kasModel));

    // try {
    //   int sisaSaldo = kasModel.saldo!;

    //   int? totalNow;

    //   if (model.tipeTransaksi == 10) {
    //     totalNow = kasModel.saldoAwal! + sumTransaksi.value + model.jumlah!;
    //     print("COK ${sumTransaksi.value}");
    //   } else if (model.tipeTransaksi == 20) {
    //     totalNow = kasModel.saldoAwal! + sumTransaksi.value - model.jumlah!;
    //   }
    //   firebaseFirestore.runTransaction((transaction) async {
    //     CollectionReference colRef = kasModel.dao!.db;

    //     transaction.update(colRef.doc(kasModel.id), {'saldo': totalNow});
    //   });
    // } catch (e) {
    //   print('transaction error');
    // } finally {
    // File? foto;
    // if (!path.isEmptyOrNull) {
    //   foto = File(path!);
    // }
    //   try {
    //     await model.save();
    //   } on SocketException catch (_) {
    //     showDialog(
    //         context: Get.context!,
    //         builder: (context) => AlertDialog(
    //               title: Text("Connection Error !"),
    //               content: Text("Please connect to the internet."),
    //             ));
    //   } catch (e) {
    //     print(e);
    //     toast("Error Saving Data");
    //   } finally {
    //     toast("Data Berhasil Diperbarui");
    //   }
    // }
    isSaving.value = false;
    Get.back();
  }

  checkControllers(TransaksiModel model, String? foto) {
    if (model.id.isEmptyOrNull) {
      if (jumlah.text.isNotEmpty ||
          keterangan.text.isNotEmpty ||
          kategori.isEmptyOrNull ||
          tipeTransaksi == null ||
          // selectedDate != DateTime.now() ||
          !foto.isEmptyOrNull) return true;
    } else {
      if (keterangan.text != model.keterangan ||
          kategori != model.kategori ||
          tipeTransaksi != model.tipeTransaksi ||
          !foto.isEmptyOrNull) return true;
    }
    return false;
  }

  clear() {
    jumlah.clear();
    // selectedDate = DateTime.now();
    keterangan.clear();
    kategori = null;
    tipeTransaksi = null;
  }
}
