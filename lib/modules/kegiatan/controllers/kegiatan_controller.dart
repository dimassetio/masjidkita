import 'dart:io';

import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/models/user.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KegiatanController extends GetxController {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController deskripsiC = TextEditingController();

  static KegiatanController instance = Get.find();

  RxList<KegiatanModel> rxKegiatans = RxList<KegiatanModel>();
  List<KegiatanModel> get kegiatans => rxKegiatans.value;

  Rx<KegiatanModel> _kegiatanModel = KegiatanModel().obs;
  KegiatanModel get kegiatan => _kegiatanModel.value;

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  var xfoto = XFile("").obs;
  var isSaving = false.obs;

  var _date = DateTime.now().obs;
  DateTime get selectedDate => _date.value;
  set selectedDate(DateTime value) => this._date.value = value;

  getKegiatanStream(MasjidModel model) {
    rxKegiatans.bindStream(model.kegiatanDao!.kegiatanStream(model));
  }

  Future deleteKegiatan(KegiatanModel model) async {
    if (model.photoUrl.isEmptyOrNull) {
      return await model.delete();
    } else
      return await model.deleteWithDetails();
  }

  getImage(bool isCam) async {
    var result = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
    if (result is XFile) {
      xfoto.value = result;
    }
  }

  saveKegiatan(KegiatanModel model) async {
    isSaving.value = true;
    model.nama = namaC.text;
    model.deskripsi = deskripsiC.text;
    model.tanggal = selectedDate;
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
    }
    isSaving.value = false;
    Get.back();
  }

  clear() {
    namaC.clear();
    deskripsiC.clear();
    xfoto.value = XFile("");
    selectedDate = DateTime.now();
  }

  checkControllers() {
    // if (namaController.text != kegiatan.nama ||
    //     namaController.text != kegiatan.nama ||
    //     deskripsiController.text != kegiatan.deskripsi) {
    //   return true;
    // } else
    //   return false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
