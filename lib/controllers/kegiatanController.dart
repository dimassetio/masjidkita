import 'package:masjidkita/models/kegiatan.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:masjidkita/models/user.dart';
import 'package:masjidkita/services/database.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:nb_utils/nb_utils.dart';

class KegiatanController extends GetxController {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  static KegiatanController instance = Get.find();

  RxList<KegiatanModel> kegiatanList = RxList<KegiatanModel>();
  List<KegiatanModel> get kegiatans => kegiatanList.value;

  Rx<KegiatanModel> _kegiatanModel = KegiatanModel().obs;
  KegiatanModel get kegiatan => _kegiatanModel.value;

  addKegiatan(String userId) async {
    DateTime now = DateTime.now();
    // int hargaTotal = jumlah!;
    try {
      await firebaseFirestore
          .collection(masjidCollection)
          .doc(manMasjidC.deMasjid.id)
          .collection(kegiatanCollection)
          .add({
        'nama': namaController.text,
        'foto': fotoController.text,
        'url': urlController.text,
        'deskripsi': deskripsiController.text,
        'tanggal': tanggalController.text,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
    clearController();
    Get.back(); // Get.toNamed(RouteName.kelolamasjid);
  }

  // Future getImage(bool isCam) async {
  //   final XFile? pickImage = await _picker.pickImage(
  //       source: isCam ? ImageSource.camera : ImageSource.gallery);
  //     String downloadUrl, fileName, filePath;
  //   if (pickImage != null) {
  //     fileName = pickImage.name;
  //     filePath = pickImage.path;
  //     Reference refFeedBuckets = firebaseStorage
  //         .ref()
  //         .child(masjidCollection)
  //         .child(deMasjid.id!)
  //         .child("Foto Profil");
  //     var file = File(filePath);

  //     TaskSnapshot uploadedFile = await refFeedBuckets.putFile(file);

  //     if (uploadedFile.state == TaskState.running) toast("Loading Image");

  //     if (uploadedFile.state == TaskState.success) {
  //       downloadUrl.value = await refFeedBuckets.getDownloadURL();
  //       photoUrl.text = downloadUrl.value;
  //       await firebaseFirestore
  //           .collection(masjidCollection)
  //           .doc(deMasjid.id)
  //           .update({'photoUrl': downloadUrl.value});
  //     } else {
  //       print(message);
  //     }
  //   }
  // }

  clearController() {
    namaController.clear();
    fotoController.clear();
    urlController.clear();
    deskripsiController.clear();
    tanggalController.clear();
  }

  tesBind() {
    kegiatanList.bindStream(kegiatanStream());
  }

  set kegiatan(KegiatanModel value) => this._kegiatanModel.value = value;

  // void getKegiatan(KegiatanID) async {
  //   Kegiatan = await Database().getKegiatan(KegiatanID);
  //   // KegiatanList.bindStream(Database().KegiatanStream());
  // }
  getKegiatanModel(kegiatanID) async {
    try {
      // print(mID);
      _kegiatanModel.value = await firebaseFirestore
          .collection(masjidCollection)
          .doc(manMasjidC.deMasjid.id)
          .collection(kegiatanCollection)
          .doc(kegiatanID)
          .get()
          .then((doc) => KegiatanModel.fromDocumentSnapshot(doc));
    } catch (e) {
      _kegiatanModel.value = KegiatanModel();
    }
  }
  // Future<KegiatanModel> getKegiatan(String KegiatanID) async {
  //   DocumentSnapshot doc = await firebaseFirestore
  //       .collection("Kegiatan")
  //       .doc(KegiatanID)
  //       .get();
  //   return KegiatanModel.fromDocumentSnapshot(doc);
  //   // try {
  //   //   DocumentSnapshot doc = await firebaseFirestore
  //   //       .collection("Kegiatan")
  //   //       .doc(KegiatanID)
  //   //       .get();
  //   //   return KegiatanModel.fromDocumentSnapshot();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  // }

  updateKegiatan() async {
    Map<String, dynamic> data = new HashMap();
    if (namaController.text != "") data['nama'] = namaController.text;
    if (fotoController.text != "") data["foto"] = fotoController.text;
    if (urlController.text != "") data["url"] = urlController.text;
    if (deskripsiController.text != "")
      data["deskripsi"] = deskripsiController.text;
    if (tanggalController.text != "") data["tanggal"] = tanggalController.text;

    await firebaseFirestore
        .collection(masjidCollection)
        .doc(manMasjidC.deMasjid.id)
        .collection(kegiatanCollection)
        .doc(kegiatan.kegiatanID)
        .update(data);
    clearControllers();

    // String harga = hargaController.text;
    // String result = harga.replaceAll('Rp ', '');
    // String finalHarga = result.replaceAll('.', '');
    // int price = finalHarga.toInt();
    // int jumlah = jumlahController.text.toInt();
    // int totalPrice = price * jumlah;
    // DateTime now = DateTime.now();

    // try {
    //   await firebaseFirestore
    //       .collection("masjid")
    //       .doc(userId)
    //       .collection("Kegiatan")
    //       .doc(Kegiatan.KegiatanID)
    //       .update({
    //     'nama': namaController.text,
    //     'foto': fotoController.text,
    //     'url': urlController.text,
    //     'jumlah': jumlahController.text.toInt(),
    //     'kondisi': kondisiController.text,
    //     'createdAt': now,
    //     'harga': finalHarga.toInt(),
    //     'hargaTotal': totalPrice,
    //   });
    // } catch (e) {
    //   print(e);
    //   rethrow;
    // }
    // clearController();
    // Get.back();
  }

  deleteKegiatan(
    KegiatanID,
  ) {
    try {
      firebaseFirestore.collection("Kegiatan").doc(KegiatanID).delete();
    } finally {
      toast("Successfully Deleted");
    }
    // var imageRef = firebaseStorage.ref().child(
    //     'Kegiatan/18ae6632-7083-49dd-b0d3-e7a617346b564771009612812182052.jpg');
    // imageRef.delete();
    // print(imageRef);
    // firebaseStorage
    //     .refFromURL("gs://masjidkita-2d58e.appspot.com//Kegiatan/${foto}")
    //     .delete();
    // print(foto);
    // Get.back();
    // Get.toNamed(RouteName.Kegiatan);
  }

  clearControllers() {
    namaController.clear();
    fotoController.clear();
    urlController.clear();
    deskripsiController.clear();
    tanggalController.clear();
    // photo_url.clear();
  }

  void clear() {
    _kegiatanModel.value = KegiatanModel();
  }

  @override
  void onInit() {
    super.onInit();
    kegiatanList.bindStream(kegiatanStream());
  }

  Stream<List<KegiatanModel>> kegiatanStream() {
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(manMasjidC.deMasjid.id)
        .collection(kegiatanCollection)
        .snapshots()
        .map((QuerySnapshot query) {
      List<KegiatanModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(KegiatanModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}
