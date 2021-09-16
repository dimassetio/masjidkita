import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/kas/models/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';

class KategoriController extends GetxController {
  static KategoriController instance = Get.find();

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  var isSaving = false.obs;

  RxList<KategoriModel> kategoriList = RxList<KategoriModel>();
  List<KategoriModel> get kategories => kategoriList.value;
  Rx<KategoriModel> _kategoriModel = KategoriModel().obs;
  KategoriModel get kategori => _kategoriModel.value;

  late TextEditingController nama;

  List<String> jenisList = [
    'Pemasukan',
    'Pengeluaran',
  ];
  String? jenis;

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

  getKategoriStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    kategoriList.bindStream(model.kategoriDao!.kategoriStream(model));
  }

  Future delete(KategoriModel model) async {
    return await model.delete();
  }

  saveKategori(KategoriModel model, {String? path}) async {
    isSaving.value = true;

    model.nama = nama.text;
    model.jenis = jenis;

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

  checkControllers(KategoriModel model) {
    if (model.id.isEmptyOrNull) {
      if (nama.text.isNotEmpty || !jenis.isEmptyOrNull) return true;
    } else {
      if (nama.text != model.nama || jenis != model.jenis) return true;
    }
    return false;
  }

  clear() {
    nama.clear();
    jenis = null;
  }
}
