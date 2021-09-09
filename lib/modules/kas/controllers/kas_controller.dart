import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KasController extends GetxController {
  static KasController instance = Get.find();

  var isSaving = false.obs;

  RxList<KasModel> kasList = RxList<KasModel>();
  List<KasModel> get kases => kasList.value;

  RxList<KategoriModel> kategoriList = RxList<KategoriModel>();
  List<KategoriModel> get kategories => kategoriList.value;
  Rx<KategoriModel> _kategoriModel = KategoriModel().obs;
  KategoriModel get kategori => _kategoriModel.value;

  Rx<KasModel> _kasModel = KasModel().obs;

  KasModel get kas => _kasModel.value;

  late TextEditingController nama;
  late TextEditingController saldoAwal;
  late TextEditingController saldo;
  late TextEditingController deskripsi;

  late TextEditingController namaKategori;
  List<String> jenisList = [
    'Pemasukan',
    'Pengeluaran',
    'Mutasi',
  ];
  String? jenis;

  @override
  void onInit() {
    super.onInit();
    // kasList.bindStream(kasStream());
  }

  // Stream<List<kasModel>> kasStream(String masjidID) async* {
  //   yield* collections(masjidID).snapshots().map((QuerySnapshot query) {
  //     List<kasModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(kasModel().fromSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }

  getKasStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    kasList.bindStream(model.kasDao!.kasStream(model));
  }

  Future delete(KasModel model) async {
    // if (model.photoUrl.isEmptyOrNull) {
    //   return await model.delete();
    // } else
    //   return await model.deleteWithDetails();
    return await model.delete();
  }

  saveKas(KasModel model) async {
    isSaving.value = true;

    int saldoAwalInt =
        saldoAwal.text.replaceAll('Rp', '').replaceAll('.', '').toInt();
    int saldoInt = saldo.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    model.nama = nama.text;
    model.saldoAwal = saldoAwalInt;
    model.saldo = saldoInt;
    model.deskripsi = deskripsi.text;
    try {
      await model.save();
    } on SocketException catch (_) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: Text("Connection Error !"),
                content: Text("Please connect to the internet."),
              ));
    } catch (e) {
      print(e);
      toast("Error Saving Data");
    } finally {
      toast("Data Berhasil Diperbarui");
    }
    isSaving.value = false;
    Get.back();
  }

  saveKategori(KategoriModel model) async {
    isSaving.value = true;
    model.nama = namaKategori.text;
    model.jenis = jenis;
    try {
      await model.save();
    } on SocketException catch (_) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: Text("Connection Error !"),
                content: Text("Please connect to the internet."),
              ));
    } catch (e) {
      print(e);
      toast("Error Saving Data");
    } finally {
      toast("Data Berhasil Diperbarui");
    }
    isSaving.value = false;
    Get.back();
  }

  checkControllers(var model) {
    if (model is KasModel) {
      if (model.id.isEmptyOrNull) {
        if (nama.text.isNotEmpty ||
            deskripsi.text.isNotEmpty ||
            saldoAwal.text.isNotEmpty ||
            saldo.text.isNotEmpty) return true;
      } else {
        if (nama.text != model.nama || deskripsi.text != model.deskripsi)
          return true;
      }
    } else if (model is KategoriModel) {
      if (model.id.isEmptyOrNull) {
        if (namaKategori.text.isNotEmpty || !jenis.isEmptyOrNull) return true;
      } else {
        if (nama.text != model.nama || jenis != model.jenis) return true;
      }
    }
    return false;
  }

  clear() {
    nama.clear();
    saldoAwal.clear();
    saldo.clear();
    deskripsi.clear();
    namaKategori.clear();
    jenis = null;
  }
}
