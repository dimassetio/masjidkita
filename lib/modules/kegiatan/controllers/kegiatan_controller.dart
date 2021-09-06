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
  final TextEditingController tempatC = TextEditingController();

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
    model.tempat = tempatC.text;
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
    tempatC.clear();
    xfoto.value = XFile("");
    selectedDate = DateTime.now();
  }

  checkControllers(KegiatanModel model) {
    if (model.id.isEmptyOrNull) {
      if (namaC.text.isNotEmpty ||
          tempatC.text.isNotEmpty ||
          deskripsiC.text.isNotEmpty ||
          // selectedDate != DateTime.now() ||
          !xfoto.value.path.isEmptyOrNull) return true;
    } else {
      if (namaC.text != model.nama ||
          tempatC.text != model.tempat ||
          deskripsiC.text != model.deskripsi ||
          selectedDate != model.tanggal ||
          !xfoto.value.path.isEmptyOrNull) return true;
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
