import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfilController extends GetxController {
  static ProfilController instance = Get.find();
  var isSaving = false.obs;

  final ImagePicker _picker = ImagePicker();

  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kodePos = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController provinsi = TextEditingController();
  TextEditingController tahun = TextEditingController();
  TextEditingController luasTanah = TextEditingController();
  TextEditingController luasBangunan = TextEditingController();
  List<String> statusTanahList = ['Wakaf', mk_lbl_lainnya];
  List<String> legalitasList = [
    'Hak Milik',
    'Hak Guna Bangunan',
    mk_lbl_lainnya
  ];

  String? statusTanah;
  String? legalitas;

  var xfoto = XFile("").obs;

  getImage(bool isCam) async {
    var result = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
    if (result is XFile) {
      xfoto.value = result;
    }
  }

  saveMasjid(MasjidModel model) async {
    isSaving.value = true;

    model.alamat = alamat.text;
    model.deskripsi = deskripsi.text;
    model.kecamatan = kecamatan.text;
    model.kodePos = kodePos.text;
    model.kota = kota.text;
    model.legalitas = legalitas;
    model.luasBangunan = luasBangunan.text;
    model.luasTanah = luasTanah.text;
    model.nama = nama.text;
    model.provinsi = provinsi.text;
    model.statusTanah = statusTanah;
    model.tahun = tahun.text;
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
      toast("Error Saving Data");
    } finally {
      toast("Data Berhasil Diperbarui");
      isSaving.value = false;
    }
  }

  checkControllers(MasjidModel model) {
    if (model.id.isEmptyOrNull) {
      return !xfoto.value.path.isEmptyOrNull ||
          nama.text.isEmpty ||
          alamat.text.isEmpty ||
          deskripsi.text.isEmpty ||
          kecamatan.text.isEmpty ||
          kodePos.text.isEmpty ||
          kota.text.isEmpty ||
          provinsi.text.isEmpty ||
          tahun.text.isEmpty ||
          luasTanah.text.isEmpty ||
          luasBangunan.text.isEmpty ||
          legalitas.isEmptyOrNull ||
          statusTanah.isEmptyOrNull;
    } else {
      return !xfoto.value.path.isEmptyOrNull ||
          nama.text != model.nama ||
          alamat.text != model.alamat ||
          deskripsi.text != model.deskripsi ||
          kecamatan.text != model.kecamatan ||
          kodePos.text != model.kodePos ||
          kota.text != model.kota ||
          provinsi.text != model.provinsi ||
          tahun.text != model.tahun ||
          luasTanah.text != model.luasTanah ||
          luasBangunan.text != model.luasBangunan ||
          legalitas != model.legalitas ||
          statusTanah != model.statusTanah;
    }
  }

  void clear() {
    nama.clear();
    alamat.clear();
    deskripsi.clear();
    kecamatan.clear();
    kodePos.clear();
    kota.clear();
    provinsi.clear();
    tahun.clear();
    luasTanah.clear();
    luasBangunan.clear();
    statusTanah = null;
    legalitas = null;
    xfoto.value = XFile("");
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    clear();
  }
}
