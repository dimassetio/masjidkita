import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/kas/kategori/kategori_database.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KategoriController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  static KategoriController instance = Get.find();

  RxList<KategoriModel> rxKategories = RxList<KategoriModel>();
  List<KategoriModel> get kategories => rxKategories.value;

  RxList<KategoriModel> _filteredKategories = RxList<KategoriModel>();
  List<KategoriModel> get filteredKategories => _filteredKategories.value;
  KategoriModel? tkategori(String id) =>
      filteredKategories.firstWhere((element) => element.id == id);

  Rx<KategoriModel> _kategoriModel = KategoriModel().obs;
  KategoriModel get kategori => _kategoriModel.value;

  var isSaving = false.obs;

  TextEditingController namaC = TextEditingController();
  List<int> jenisList = [10, 20];
  int? jenis;

  getKategoriStream(MasjidModel model) {
    rxKategories.bindStream(model.kategoriDao!.kategoriStream(model));
  }

  filterKategoriStream(MasjidModel model, FilterKategori? filter) {
    _filteredKategories
        .bindStream(model.kategoriDao!.filterKategoriStream(model, filter));
  }

  Future deleteKategori(KategoriModel model) async {
    return await model.delete();
  }

  saveKategori(KategoriModel model) async {
    isSaving.value = true;
    model.nama = namaC.text;
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

  checkControllers(KategoriModel model) {
    if (model.id.isEmptyOrNull) {
      if (namaC.text.isNotEmpty || jenis != null) return true;
    } else {
      if (namaC.text != model.nama || jenis != model.jenis) return true;
    }
    return false;
  }

  void clear() {
    namaC.clear();
    jenis = null;
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
