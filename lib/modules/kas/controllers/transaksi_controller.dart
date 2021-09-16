import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
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
  List<TransaksiModel> get kases => transaksiList.value;

  Rx<TransaksiModel> _transaksiModel = TransaksiModel().obs;

  TransaksiModel get transaksi => _transaksiModel.value;

  late TextEditingController nama;
  late TextEditingController url;
  late TextEditingController jumlah;
  late TextEditingController keterangan;
  late TextEditingController kategori;
  late TextEditingController tipeTransaksi;

  var _date = DateTime.now().obs;
  DateTime get selectedDate => _date.value;
  set selectedDate(DateTime value) => this._date.value = value;

  // late TextEditingController namaKategori;
  // List<String> jenisList = [
  //   'Pemasukan',
  //   'Pengeluaran',
  //   'Mutasi',
  // ];
  // String? jenis;

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

  getTransaksiStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    transaksiList.bindStream(model.transaksiDao!.transaksiStream(model));
  }

  Future delete(TransaksiModel model) async {
    // if (model.photoUrl.isEmptyOrNull) {
    //   return await model.delete();
    // } else
    //   return await model.deleteWithDetails();
    return await model.delete();
  }

  saveTransaksi(TransaksiModel model, {String? path}) async {
    isSaving.value = true;

    int jumlahInt =
        jumlah.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    model.nama = nama.text;
    model.url = url.text;
    model.jumlah = jumlahInt;
    model.tanggal = selectedDate;
    model.keterangan = keterangan.text;
    model.kategori = kategori.text;
    model.tipeTransaksi = tipeTransaksi.text;

    File? foto;
    if (!path.isEmptyOrNull) {
      foto = File(path!);
    }

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

  checkControllers(TransaksiModel model, String? foto) {
    if (model.id.isEmptyOrNull) {
      if (nama.text.isNotEmpty ||
          url.text.isNotEmpty ||
          jumlah.text.isNotEmpty ||
          keterangan.text.isNotEmpty ||
          kategori.text.isNotEmpty ||
          tipeTransaksi.text.isNotEmpty ||
          // selectedDate != DateTime.now() ||
          !foto.isEmptyOrNull) return true;
    } else {
      if (nama.text != model.nama ||
          url.text != model.url ||
          selectedDate != model.tanggal ||
          keterangan.text != model.keterangan ||
          kategori.text != model.kategori ||
          tipeTransaksi.text != model.tipeTransaksi ||
          !foto.isEmptyOrNull) return true;
    }
    return false;
  }

  clear() {
    nama.clear();
    url.clear();
    jumlah.clear();
    selectedDate = DateTime.now();
    keterangan.clear();
    kategori.clear();
    tipeTransaksi.clear();
  }
}
