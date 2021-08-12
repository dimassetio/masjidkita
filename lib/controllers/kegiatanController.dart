import 'package:mosq/models/kegiatan.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/models/user.dart';
import 'package:mosq/services/database.dart';
import 'package:get/get.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KegiatanController extends GetxController {
  var isSaving = false.obs;
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
    // DateTime now = DateTime.now();
    // // int hargaTotal = jumlah!;
    // try {
    //   await firebaseFirestore
    //       .collection(masjidCollection)
    //       .doc(manMasjidC.deMasjid.id)
    //       .collection(kegiatanCollection)
    //       .add({
    //     'nama': namaController.text,
    //     'foto': fotoController.text,
    //     'url': urlController.text,
    //     'deskripsi': deskripsiController.text,
    //     'tanggal': tanggalController.text,
    //   });
    // } catch (e) {
    //   print(e);
    //   rethrow;
    // }
    // clearController();
    // Get.back(); // Get.toNamed(RouteName.kelolamasjid);

    Map<String, dynamic> data = new HashMap();
    DateTime now = DateTime.now();
    if (namaController.text != "") data['nama'] = namaController.text;
    if (deskripsiController.text != "")
      data["deskripsi"] = deskripsiController.text;
    if (tanggalController.text != "") data["tanggal"] = tanggalController.text;
    if (urlController.text != "") data["url"] = urlController.text;
    if (fotoController.text != "") data["foto"] = fotoController.text;
    data["updatedAt"] = now;
    String? docID = Get.parameters['id'];

    try {
      docID == null
          ? await firebaseFirestore
              .collection(masjidCollection)
              .doc(userId)
              .collection(kegiatanCollection)
              .add(data)
          : await firebaseFirestore
              .collection(masjidCollection)
              .doc(userId)
              .collection(kegiatanCollection)
              .doc(docID)
              .update(data);
    } catch (e) {
      print(e);
      rethrow;
    }
    clearController();
    Get.back(); // Get.toNamed(Ro
  }

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
    //     .refFromURL("gs://mosq-2d58e.appspot.com//Kegiatan/${foto}")
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

  checkControllers() {
    if (namaController.text != kegiatan.nama ||
            namaController.text != kegiatan.nama ||
            deskripsiController.text != kegiatan.deskripsi
        // fotoController.text != kegiatan.foto ||
        // urlController.text != kegiatan.url ||
        ) {
      return true;
    } else
      return false;
  }

  PickedFile? pickImage;
  String fileName = '', filePath = '';
  final ImagePicker _picker = ImagePicker();
  String message = "Belum ada gambar";
  var downloadUrl = "".obs;
  var isLoadingImage = false.obs;
  PickedFile? pickedFile;
  XFile? pickedImage;
  var uploadPrecentage = 0.0.obs;

  uploadImage(bool isCam) async {
    pickedImage = await inventarisC.getImage(isCam);
    await uploadToStorage(pickedImage);
  }

  Future getImage(bool isCam) async {
    return pickedImage = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
  }

  Future uploadToStorage(XFile? pickImage) async {
    if (pickImage != null) {
      fileName = pickImage.name;
      filePath = pickImage.path;
      Reference refFeedBuckets = firebaseStorage
          .ref()
          .child(masjidCollection)
          .child(manMasjidC.deMasjid.id!)
          .child(kegiatanCollection)
          .child(fileName);
      var file = File(filePath);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'picked-file-path': filePath,
            'picked-file-name': fileName
          });

      UploadTask uploadTask = refFeedBuckets.putFile(file, metadata);
      uploadTask.snapshotEvents.listen((event) async {
        print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
        uploadPrecentage.value = event.bytesTransferred / event.totalBytes;

        if (event.state == TaskState.success) {
          downloadUrl.value = await refFeedBuckets.getDownloadURL();
          urlController.text = downloadUrl.value;
          fotoController.text = fileName;
          // await firebaseFirestore
          //     .collection(masjidCollection)
          //     .doc(manMasjidC.deMasjid.id)
          //     .collection(inventarisCollection)
          //     .doc(inventarisC.inventaris.inventarisID)
          //     .update({'url': downloadUrl.value});
          isLoadingImage.value = false;
          Get.back();
        } else {
          isLoadingImage.value = true;
        }
      });
    } else {
      toast('error upload data');
    }
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
