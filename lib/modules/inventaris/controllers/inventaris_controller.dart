import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InventarisController extends GetxController {
  // var hargaController = TextEditingController();

  static InventarisController instance = Get.find();

  RxList<InventarisModel> inventarisList = RxList<InventarisModel>();
  List<InventarisModel> get inventarises => inventarisList.value;

  Rx<InventarisModel> _inventarisModel = InventarisModel().obs;
  InventarisModel get inventaris => _inventarisModel.value;
  set inventaris(InventarisModel value) => this._inventarisModel.value = value;

  var isSaving = false.obs;
  late TextEditingController nama;
  late TextEditingController jumlah;
  late TextEditingController kondisi;
  late TextEditingController harga;
  // var harga = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // inventarisList.bindStream(InventarisModel().dao.inventarisStream());
  }

  getInventarisStream(MasjidModel model) {
    inventarisList.bindStream(model.inventarisDao!.inventarisStream(model));
  }

  Future delete(InventarisModel model) async {
    if (model.photoUrl.isEmptyOrNull) {
      return await model.delete();
    } else
      return await model.deleteWithDetails();
  }

  saveInventaris(InventarisModel model, {String? path}) async {
    isSaving.value = true;
    int jumlahBarang = jumlah.text.toInt();
    int hargaBarang =
        harga.text.replaceAll('Rp', '').replaceAll('.', '').toInt();
    model.nama = nama.text;
    model.kondisi = kondisi.text;
    model.harga = hargaBarang;
    model.jumlah = jumlahBarang;
    model.hargaTotal = hargaBarang * jumlahBarang;

    File? foto;
    if (!path.isEmptyOrNull) {
      foto = File(path!);
    }

    try {
      var result =
          foto == null ? await model.save() : await model.saveWithDetails(foto);
      if (result is UploadTask) {
        UploadTask task = result;
        task.snapshotEvents.listen((event) async {
          print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
        });
      }
    } on SocketException catch (_) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: Text("Connection Error !"),
                content: Text("Please connect to the internet."),
              ));
    } catch (e) {
      print(e);
      toast("Error saving data");
    } finally {
      toast("Data berhasil diperbarui");
      isSaving.value = false;
      Get.back();
    }
  }

  checkControllers(InventarisModel model, String? foto) {
    if (model.id.isEmptyOrNull) {
      if (nama.text.isNotEmpty ||
          jumlah.text.isNotEmpty ||
          harga.text.isNotEmpty ||
          kondisi.text.isNotEmpty ||
          !foto.isEmptyOrNull) return true;
    } else {
      if (nama.text != model.nama ||
          harga.text != currencyFormatter(model.harga) ||
          jumlah.text != model.jumlah.toString() ||
          kondisi.text != model.kondisi ||
          !foto.isEmptyOrNull) return true;
    }
    return false;
  }

  clear() {
    nama.clear();
    jumlah.clear();
    harga.clear();
    kondisi.clear();
  }
}
