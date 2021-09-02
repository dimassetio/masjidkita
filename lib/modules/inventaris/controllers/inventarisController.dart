import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:get/get.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InventarisController extends GetxController {
  // var hargaController = TextEditingController();

  static InventarisController instance = Get.find();

  RxList<InventarisModel> inventarisList = RxList<InventarisModel>();
  List<InventarisModel> get inventariss => inventarisList.value;

  Rx<InventarisModel> _inventarisModel = InventarisModel().obs;
  InventarisModel get inventaris => _inventarisModel.value;
  set inventaris(InventarisModel value) => this._inventarisModel.value = value;

  var isSaving = false.obs;
  late TextEditingController nama;
  late TextEditingController jumlah;
  late TextEditingController kondisi;
  late TextEditingController harga;
  // var harga = TextEditingController();
  var xfoto = XFile("").obs;

  @override
  void onInit() {
    super.onInit();
    // inventarisList.bindStream(InventarisModel().dao.inventarisStream());
  }

  getInventarisStream(MasjidModel model) {
    inventarisList.bindStream(model.inventarisDao!.inventarisStream(model));
  }

  Future delete(InventarisModel model) async {
    if (model.url.isEmptyOrNull) {
      return await model.delete();
    } else
      return await model.deleteWithDetails();
  }

  final ImagePicker _picker = ImagePicker();

  getImage(bool isCam) async {
    var result = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
    if (result is XFile) {
      xfoto.value = result;
    }
  }

  saveInventaris(InventarisModel model) async {
    int jumlahBarang = jumlah.text.toInt();
    int hargaBarang =
        harga.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    model.nama = nama.text;
    model.kondisi = kondisi.text;
    model.harga = hargaBarang;
    model.jumlah = jumlahBarang;
    model.hargaTotal = hargaBarang * jumlahBarang;

    File? foto;
    if (xfoto.value.path.isNotEmpty) {
      foto = File(xfoto.value.path);
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
    }
  }

  checkControllers(InventarisModel model) {
    if (model.inventarisID.isEmptyOrNull) {
      if (nama.text.isNotEmpty ||
          jumlah.text.isNotEmpty ||
          harga.text.isNotEmpty ||
          kondisi.text.isNotEmpty ||
          !xfoto.value.path.isEmptyOrNull) return true;
    } else {
      if (nama.text != model.nama ||
          harga.text != currencyFormatter(model.harga) ||
          jumlah.text != model.jumlah.toString() ||
          kondisi.text != model.kondisi ||
          !xfoto.value.path.isEmptyOrNull) return true;
    }
    return false;
  }

  clear() {
    nama.clear();
    jumlah.clear();
    harga.clear();
    kondisi.clear();
    xfoto.value = XFile("");
  }
}
