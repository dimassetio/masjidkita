import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KategoriController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  static KategoriController instance = Get.find();

  RxList<KategoriModel> rxKategoris = RxList<KategoriModel>();
  List<KategoriModel> get kategoris => rxKategoris.value;

  Rx<KategoriModel> _kategoriModel = KategoriModel().obs;
  KategoriModel get kategori => _kategoriModel.value;

  List<String> jabatanList = [
    'Ketua',
    'Sekretaris',
    'Bendahara',
    mk_lbl_lainnya
  ];
  var isOtherJabatan = false.obs;
  String? jabatan;
  late TextEditingController namaC;
  late TextEditingController jabatanC;
  XFile? pickedImage;
  var isSaving = false.obs;

  // checkControllers(KategoriModel model, String? foto) {
  //   if (model.id.isEmptyOrNull) {
  //     if (namaC.text.isNotEmpty ||
  //         !jabatan.isEmptyOrNull ||
  //         jabatanC.text.isNotEmpty ||
  //         !foto.isEmptyOrNull) return true;
  //   } else {
  //     if (namaC.text != model.nama ||
  //         !foto.isEmptyOrNull ||
  //         jabatan != model.jabatan && jabatanC.text != model.jabatan) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  getKategoriStream(MasjidModel model) {
    rxKategoris.bindStream(model.kategoriDao!.kategoriStream(model));
  }

  Future deleteKategori(KategoriModel model) async {
    return await model.delete();
  }

  // saveKategori(KategoriModel model, {String? path}) async {
  //   isSaving.value = true;
  //   model.nama = namaC.text;
  //   model.jabatan = jabatan == "Lainnya" ? jabatanC.text : jabatan;
  //   File? foto;
  //   // if (xfoto.value.path.isNotEmpty) {
  //   //   foto = File(xfoto.value.path);
  //   // }
  //   if (!path.isEmptyOrNull) {
  //     foto = File(path!);
  //   }
  //   try {
  //     var result =
  //         foto == null ? await model.save() : await model.saveWithDetails(foto);
  //     if (result is UploadTask) {
  //       UploadTask task = result;
  //       task.snapshotEvents.listen((event) async {
  //         print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     showDialog(
  //         context: Get.context!,
  //         builder: (context) => AlertDialog(
  //               title: Text("Connection Error !"),
  //               content: Text("Please connect to the internet."),
  //             ));
  //   } catch (e) {
  //     print(e);
  //     toast("Error Saving Data");
  //   } finally {
  //     toast("Data Berhasil Diperbarui");
  //   }
  //   isSaving.value = false;
  //   Get.back();
  // }

  void clear() {
    namaC.clear();
    jabatanC.clear();
    jabatan = null;
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
