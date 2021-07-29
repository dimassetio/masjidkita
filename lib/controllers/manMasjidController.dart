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
  TextEditingController statusTanah = TextEditingController();
  TextEditingController legalitas = TextEditingController();

  // Rx<ManMasjidModel> keMasjidModel = ManMasjidModel().obs;
  // ManMasjidModel get keMasjid => keMasjidModel.value;
  // set keMasjid(ManMasjidModel value) => this.keMasjidModel.value = value;

  Rx<DetailMasjidModel> deMasjidModel = DetailMasjidModel().obs;
  DetailMasjidModel get deMasjid => deMasjidModel.value;
  set deMasjid(DetailMasjidModel value) => this.deMasjidModel.value = value;

  var haveMasjid = false.obs;
  var myMasjid = false.obs;

  @override
  void onReady() {
    super.onReady();
    // _getManMasjidModel();
    // ever(authController.firebaseUser, _getManMasjidModel);
    // deMasjidModel.bindStream(getDetailMasjids(mID))
    // ever(authController.userModel, _getManMasjidModel);

    nama.addListener(() {
      print(nama.text);
    });
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

  updateDataMasjid() async {
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
    if (statusTanah.text != "") data["statusTanah"] = statusTanah.text;
    if (legalitas.text != "") data["legalitas"] = legalitas.text;
    print("data = $data");
    await firebaseFirestore
        .collection(masjidCollection)
        .doc(deMasjid.id)
        .update(data);
    clearControllers();

    // await _getManMasjidModel(deMasjid);
    // await getDetailMasjid(deMasjid.id);
  }

  // _getManMasjidModel(userModel) async {
  //   try {
  //     keMasjidModel.value = await firebaseFirestore
  //         .collection(masjidCollection)
  //         .doc(authController.user.masjid)
  //         .get()
  //         .then((doc) => ManMasjidModel.fromSnapshot(doc));
  //   } catch (e) {
  //     keMasjidModel.value = ManMasjidModel();
  //   }
  //   _setHaveMasjid();
  // }

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
    statusTanah.clear();
    legalitas.clear();
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
        statusTanah.text != "" ||
        legalitas.text != "") {
      return true;
    } else
      return false;
  }

  PickedFile? pickImage;
  String fileName = '', filePath = '';
  final ImagePicker _picker = ImagePicker();
  String message = "Belum ada gambar";
  var downloadUrl = "".obs;
  final TextEditingController fotoController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  Future getImage(bool isCam) async {
    final XFile? pickImage = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
    if (pickImage != null) {
      fileName = pickImage.name;
      filePath = pickImage.path;
      Reference refFeedBuckets = firebaseStorage
          .ref()
          .child(masjidCollection)
          .child(deMasjid.id!)
          .child("Foto Profil");
      var file = File(filePath);

      TaskSnapshot uploadedFile = await refFeedBuckets.putFile(file);

      if (uploadedFile.state == TaskState.running) toast("Loading Image");

      if (uploadedFile.state == TaskState.success) {
        downloadUrl.value = await refFeedBuckets.getDownloadURL();
        photoUrl.text = downloadUrl.value;
        await firebaseFirestore
            .collection(masjidCollection)
            .doc(deMasjid.id)
            .update({'photoUrl': downloadUrl.value});
      } else {
        print(message);
      }
    }
  }

  // Future getImageCam() async {
  //   final XFile? pickImage =
  //       await _picker.pickImage(source: ImageSource.camera);
  //   if (pickImage != null) {
  //     Reference refFeedBucket =
  //         feedStorage.ref().child('inventaris').child(filePath);
  //     // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
  //     String downloadUrl;
  //     var file = File(filePath);

  //     TaskSnapshot uploadedFile = await refFeedBucket.putFile(file);

  //     if (uploadedFile.state == TaskState.success) {
  //       downloadUrl = await refFeedBucket.getDownloadURL();
  //       inventarisC.fotoController.text = fileName;
  //       inventarisC.urlController.text = downloadUrl;
  //     } else {
  //       print(message);
  //     }
  //   }
  // }
}
