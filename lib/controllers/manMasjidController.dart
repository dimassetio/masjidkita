import 'dart:collection';
import 'dart:io';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/models/manMasjid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/firestore.dart';
// import 'package:masjidkita/models/user.dart';
import 'package:masjidkita/routes/route_name.dart';
// import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
// import 'package:masjidkita/screens/utils/widgets/AddOrJoin.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class ManMasjidController extends GetxController {
  static ManMasjidController instance = Get.find();

  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController photoUrl = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kodePos = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController provinsi = TextEditingController();
  TextEditingController tahun = TextEditingController();
  TextEditingController luasTanah = TextEditingController();
  TextEditingController luasBangunan = TextEditingController();
  // TextEditingController statusTanah = TextEditingController();
  // TextEditingController legalitas = TextEditingController();
  String? legalitas;
  String? statusTanah;

  // Rx<ManMasjidModel> keMasjidModel = ManMasjidModel().obs;
  // ManMasjidModel get keMasjid => keMasjidModel.value;
  // set keMasjid(ManMasjidModel value) => this.keMasjidModel.value = value;

  Rx<DetailMasjidModel> deMasjidModel = DetailMasjidModel().obs;
  DetailMasjidModel get deMasjid => deMasjidModel.value;
  set deMasjid(DetailMasjidModel value) => this.deMasjidModel.value = value;

  var haveMasjid = false.obs;
  var myMasjid = false.obs;
  var isSaving = false.obs;

  @override
  void onReady() {
    super.onReady();
    // _getManMasjidModel();
    // ever(authController.firebaseUser, _getManMasjidModel);
    // deMasjidModel.bindStream(getDetailMasjids(mID))
    // ever(authController.userModel, _getManMasjidModel);
  }

  testdata() {
    // clear();
    // return _getManMasjidModel(authController.user);
    // _setHaveMasjid();
  }

  gotoDetail(mID) async {
    try {
      deMasjidModel.bindStream(streamDetailMasjid(mID));
    } finally {
      await isMyMasjid(mID);
      await Get.toNamed(RouteName.detail);
    }
  }

  // _setHaveMasjid() {
  //   if (keMasjid.nama == null) {
  //     haveMasjid.value = false;
  //   } else {
  //     haveMasjid.value = true;
  //   }
  //   // print(haveMasjid.value);
  // }

  addMasjidToFirestore(String userId) async {
    await firebaseFirestore.collection(masjidCollection).doc(userId).set({
      "nama": nama.text.trim(),
      "id": userId,
      "alamat": alamat.text.trim(),
      "photoUrl": "",
    });
    await firebaseFirestore.collection(usersCollection).doc(userId).update({
      "masjid": userId,
    });
    // await _getManMasjidModel(authController.user);
    clearControllers();
  }

  Future updateDataMasjid() async {
    Map<String, dynamic> data = new HashMap();
    if (nama.text != "") data['nama'] = nama.text;
    if (alamat.text != "") data["alamat"] = alamat.text;
    if (photoUrl.text != "") data["photoUrl"] = photoUrl.text;
    if (deskripsi.text != "") data["deskripsi"] = deskripsi.text;
    if (kecamatan.text != "") data["kecamatan"] = kecamatan.text;
    if (kodePos.text != "") data["kodePos"] = kodePos.text;
    if (kota.text != "") data["kota"] = kota.text;
    if (provinsi.text != "") data["provinsi"] = provinsi.text;
    if (tahun.text != "") data["tahun"] = tahun.text;
    if (luasTanah.text != "") data["luasTanah"] = luasTanah.text;
    if (luasBangunan.text != "") data["luasBangunan"] = luasBangunan.text;
    if (statusTanah != null) data["statusTanah"] = statusTanah;
    if (legalitas != null) data["legalitas"] = legalitas;
    print("data = $data");
    isSaving.value = true;
    try {
      await firebaseFirestore
          .collection(masjidCollection)
          .doc(deMasjid.id)
          .update(data);
    } on SocketException catch (_) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: Text("Connection Error !"),
                content: Text("Please connect to the internet."),
              ));
      toast("value");
    } catch (e) {
      print(e);
      toast("Error Saving Data");
    } finally {
      clearControllers();
      toast("Data Berhasil Diperbarui");
      isSaving.value = false;
    }

    // await _getManMasjidModel(deMasjid);
    // await getDetailMasjid(deMasjid.id);
  }

  // getDetailMasjid(mID) async {
  //   try {
  //     // print(mID);
  //     deMasjidModel.value = await firebaseFirestore
  //         .collection(masjidCollection)
  //         .doc(mID)
  //         .get()
  //         .then((doc) => DetailMasjidModel.fromSnapshot(doc));
  //   } catch (e) {
  //     deMasjidModel.value = DetailMasjidModel();
  //   }
  //   await isMyMasjid(deMasjid.id!);
  //   print(myMasjid.value);
  // }

  Stream<DetailMasjidModel> streamDetailMasjid(mID) {
    // try {
    // print(mID);
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(mID)
        .snapshots()
        .map((event) => DetailMasjidModel.fromSnapshot(event));
    // } catch (e) {
    //   return keMasjidModel.value = ManMasjidModel();
    // }
    // await isMyMasjid();
    // print(myMasjid.value);
  }

  isMyMasjid(String mID) {
    print("user ${authController.user.masjid}");
    print("masjid $mID");
    authController.user.masjid != null
        ? mID == authController.user.masjid
            ? myMasjid.value = true
            : myMasjid.value = false
        : myMasjid.value = false;
  }

  clearControllers() {
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
    // photo_url.clear();
  }

  checkControllers() {
    if (nama.text != "" ||
        alamat.text != "" ||
        deskripsi.text != "" ||
        kecamatan.text != "" ||
        kodePos.text != "" ||
        kota.text != "" ||
        provinsi.text != "" ||
        tahun.text != "" ||
        luasTanah.text != "" ||
        luasBangunan.text != "" ||
        statusTanah != null ||
        legalitas != null) {
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
  var uploadPrecentage = 0.0.obs;
  XFile? pickedImage;

  uploadImage(bool isCam) async {
    pickedImage = await manMasjidC.getImage(isCam);
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
          .child(deMasjid.id!)
          .child("Foto Profil");
      var file = File(filePath);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'picked-file-path': filePath,
            'picked-file-name': fileName
          });

      // TaskSnapshot uploadedFile = await refFeedBuckets.putFile(file);

      UploadTask uploadTask = refFeedBuckets.putFile(file, metadata);
      uploadTask.snapshotEvents.listen((event) async {
        print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
        uploadPrecentage.value = event.bytesTransferred / event.totalBytes;
        // if (event.state == TaskState.running) {

        // }
        if (event.state == TaskState.success) {
          downloadUrl.value = await refFeedBuckets.getDownloadURL();
          photoUrl.text = downloadUrl.value;
          await firebaseFirestore
              .collection(masjidCollection)
              .doc(deMasjid.id)
              .update({'photoUrl': downloadUrl.value});
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
}
