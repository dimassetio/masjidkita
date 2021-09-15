import 'dart:io';

import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KegiatanController extends GetxController {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController deskripsiC = TextEditingController();
  final TextEditingController tempatC = TextEditingController();

  static KegiatanController instance = Get.find();

  RxList<KegiatanModel> rxKegiatans = RxList<KegiatanModel>();
  List<KegiatanModel> get kegiatans => rxKegiatans.value;

  Rx<KegiatanModel> _kegiatanModel = KegiatanModel().obs;
  KegiatanModel get kegiatan => _kegiatanModel.value;

  var isSaving = false.obs;

  var _date = DateTime.now().obs;
  DateTime get selectedDate => _date.value;
  set selectedDate(DateTime value) => this._date.value = value;

  getKegiatanStream(MasjidModel model) {
    rxKegiatans.bindStream(model.kegiatanDao!.kegiatanStream(model));
  }

  Future deleteKegiatan(KegiatanModel model) async {
    // Get.back();
    try {
      if (model.photoUrl.isEmptyOrNull) {
        await model.delete();
      } else
        await model.deleteWithDetails();
    } catch (e) {
      toast('Error Delete Data');
    } finally {
      Get.back();
    }
  }

  saveKegiatan(KegiatanModel model, {String? path}) async {
    isSaving.value = true;
    model.nama = namaC.text;
    model.deskripsi = deskripsiC.text;
    model.tempat = tempatC.text;
    model.tanggal = selectedDate;
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
    tempatC.clear();

    selectedDate = DateTime.now();
  }

  checkControllers(KegiatanModel model, String? path) {
    if (model.id.isEmptyOrNull) {
      if (namaC.text.isNotEmpty ||
          tempatC.text.isNotEmpty ||
          deskripsiC.text.isNotEmpty ||
          // selectedDate != DateTime.now() ||
          !path.isEmptyOrNull) return true;
    } else {
      if (namaC.text != model.nama ||
          tempatC.text != model.tempat ||
          deskripsiC.text != model.deskripsi ||
          selectedDate != model.tanggal ||
          !path.isEmptyOrNull) return true;
    }
    return false;
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
