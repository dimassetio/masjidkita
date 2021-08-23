import 'dart:collection';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/models/masjid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/routes/route_name.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManMasjidController extends GetxController {
  static ManMasjidController instance = Get.find();

  // TextEditingController nama = TextEditingController();
  // TextEditingController alamat = TextEditingController();
  // TextEditingController photoUrl = TextEditingController();
  // TextEditingController deskripsi = TextEditingController();
  // TextEditingController kecamatan = TextEditingController();
  // TextEditingController kodePos = TextEditingController();
  // TextEditingController kota = TextEditingController();
  // TextEditingController provinsi = TextEditingController();
  // TextEditingController tahun = TextEditingController();
  // TextEditingController luasTanah = TextEditingController();
  // TextEditingController luasBangunan = TextEditingController();

  String? legalitas;
  String? statusTanah;

  // Rx<ManMasjidModel> keMasjidModel = ManMasjidModel().obs;
  // ManMasjidModel get keMasjid => keMasjidModel.value;
  // set keMasjid(ManMasjidModel value) => this.keMasjidModel.value = value;

  Rx<MasjidModel> deMasjidModel = MasjidModel().obs;
  MasjidModel get deMasjid => deMasjidModel.value;
  set deMasjid(MasjidModel value) => this.deMasjidModel.value = value;

  var myMasjid = false.obs;
  var isSaving = false.obs;

  var numFormat = NumberFormat.decimalPattern("id");
  decFormat(int value) {
    var formatted = NumberFormat.decimalPattern("id").format(value);
    var back = formatted.toInt();
    print(back);

    return NumberFormat.decimalPattern("id").format(value);
  }

  currFormat(int value) {
    return NumberFormat.simpleCurrency(
      locale: "id",
      // decimalDigits: 0,
    ).format(value);
  }

  removeFormat(String text) {
    return text.replaceAll('.', '');
  }

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

  gotoDetail(MasjidModel dataMasjid) async {
    try {
      // deMasjidModel.bindStream(streamDetailMasjid(mID));
      deMasjid = dataMasjid;
      takmirC.getTakmirStream(dataMasjid.id!);
    } catch (e) {
      toast(e.toString());
    } finally {
      await isMyMasjid(deMasjid.id!);
      await Get.toNamed(RouteName.detail);
    }
  }

  Map<String, dynamic> getData(MasjidModel model) {
    return {
      'id': model.id,
      'nama': model.nama,
      'alamat': model.alamat,
      'photoUrl': model.photoUrl,
      'deskripsi': model.deskripsi,
      'kecamatan': model.kecamatan,
      'kodePos': model.kodePos,
      'kota': model.kota,
      'provinsi': model.provinsi,
      'tahun': model.tahun,
      'luasTanah': model.luasTanah,
      'luasBangunan': model.luasBangunan,
      'statusTanah': model.statusTanah,
      'legalitas': model.legalitas,
    };
  }

  addMasjidToFirestore(MasjidModel data) async {
    await firebaseFirestore
        .collection(masjidCollection)
        .doc(authController.user.id)
        .set(getData(data));
    await firebaseFirestore
        .collection(usersCollection)
        .doc(authController.user.id)
        .update({
      "masjid": authController.user.id,
    });
    listMasjidC.addFav(authController.user.id);
  }

  var count = 0.obs;

  Future updateDataMasjid(MasjidModel model) async {
    isSaving.value = true;
    print(Get.parameters['id']);
    String? docID = Get.parameters['id'];
    print(getData(model));
    try {
      docID == null
          ? await addMasjidToFirestore(model)
          : await firebaseFirestore
              .collection(masjidCollection)
              .doc(docID)
              .update(getData(model));
      uploadToStorage();
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
  }

  // getDetailMasjid(mID) async {
  //   try {
  //     // print(mID);
  //     deMasjidModel.value = await firebaseFirestore
  //         .collection(masjidCollection)
  //         .doc(mID)
  //         .get()
  //         .then((doc) => MasjidModel.fromSnapshot(doc));
  //   } catch (e) {
  //     deMasjidModel.value = MasjidModel();
  //   }
  //   await isMyMasjid(deMasjid.id!);
  //   print(myMasjid.value);
  // }

  Stream<MasjidModel> streamDetailMasjid(mID) {
    // try {
    // print(mID);
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(mID)
        .snapshots()
        .map((event) => MasjidModel.fromSnapshot(event));
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
    // nama.clear();
    // alamat.clear();
    // deskripsi.clear();
    // kecamatan.clear();
    // kodePos.clear();
    // kota.clear();
    // provinsi.clear();
    // tahun.clear();
    // luasTanah.clear();
    // luasBangunan.clear();
    statusTanah = null;
    legalitas = null;
    // photo_url.clear();
  }

  checkControllers() {
    if (
        // nama.text != deMasjid.nama ||
        //   alamat.text != deMasjid.alamat ||
        //   deskripsi.text != deMasjid.deskripsi ||
        //   kecamatan.text != deMasjid.kecamatan ||
        //   kodePos.text != deMasjid.kodePos ||
        //   kota.text != deMasjid.kota ||
        //   provinsi.text != deMasjid.provinsi ||
        //   tahun.text != deMasjid.tahun ||
        //   luasTanah.text != deMasjid.luasTanah ||
        //   luasBangunan.text != deMasjid.luasBangunan ||
        statusTanah != null || legalitas != null) {
      return true;
    } else
      return false;
  }

  PickedFile? pickImage;
  String fileName = '', filePath = '';
  String message = "Belum ada gambar";
  var downloadUrl = "".obs;
  var isLoadingImage = false.obs;
  PickedFile? pickedFile;
  var uploadPrecentage = 0.0.obs;
  XFile? pickedImage;
  var photoPath = "".obs;

  final ImagePicker _picker = ImagePicker();

  uploadImage(bool isCam) async {
    pickedImage = await manMasjidC.getImage(isCam);
    // await uploadToStorage(pickedImage);
  }

  Future getImage(bool isCam) async {
    pickedImage = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
    if (pickedImage != null) {
      photoPath.value = pickedImage!.path;
    }
  }

  Future uploadToStorage() async {
    if (pickedImage != null) {
      fileName = pickedImage!.name;
      filePath = pickedImage!.path;
      Reference refFeedBuckets = firebaseStorage
          .ref()
          .child(masjidCollection)
          .child(authController.user.id!)
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
          // photoUrl.text = downloadUrl.value;
          await firebaseFirestore
              .collection(masjidCollection)
              .doc(authController.user.id)
              .update({'photoUrl': downloadUrl.value});
          isLoadingImage.value = false;
          print('$downloadUrl sss');
        } else {
          isLoadingImage.value = true;
        }
      });
    }
    // else {
    // toast('No Image Picked');
    // }
  }

  deleteMasjid(masjidID) async {
    try {
      await firebaseFirestore
          .collection(masjidCollection)
          .doc(masjidID)
          .delete();
    } catch (e) {
      return e.toString();
    }
    return 'Success deleted';
  }
}
