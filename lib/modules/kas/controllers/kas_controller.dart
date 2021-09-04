import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KasController extends GetxController {
  String? photoUrlC;

  XFile? photoLocal;
  var rxPhotoPath = "".obs;
  String get photoPath => rxPhotoPath.value;
  set photoPath(String value) => this.rxPhotoPath.value = value;

  var rxjabatan = "".obs;
  String get jabatan => rxjabatan.value;
  set jabatan(String value) => this.rxjabatan.value = value;
  XFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

  static KasController instance = Get.find();

  RxList<KasModel> kasList = RxList<KasModel>();
  List<KasModel> get kases => kasList.value;

  RxList<KategoriModel> kategoriList = RxList<KategoriModel>();
  List<KategoriModel> get kategories => kategoriList.value;
  Rx<KategoriModel> _kategoriModel = KategoriModel().obs;
  KategoriModel get kategori => _kategoriModel.value;

  Rx<KasModel> _kasModel = KasModel().obs;

  KasModel get kas => _kasModel.value;
  CollectionReference collections(String masjidID) {
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(masjidID)
        .collection(kasCollection);
  }

  CollectionReference collectionsKategori(String masjidID) {
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(masjidID)
        .collection(kategoriCollection);
  }

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

  getKasStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    kasList.bindStream(model.kasDao!.kasStream(model));
  }

  //Single
  Map<String, dynamic> getData(KasModel model) {
    return {
      'id': model.id,
      'nama': model.nama,
      'saldoAwal': model.saldoAwal,
      // 'photoUrl': model.photoUrl,
    };
  }

  var uploadPrecentage = 0.0.obs;
  var isLoadingImage = false.obs;

  Future store(KasModel model, String masjidID) async {
    var result = await collections(masjidID).add(getData(model));
    return result.id;
  }

  Future updatekas(KasModel model, String masjidID) async {
    await collections(masjidID).doc(model.id).set(getData(model));
    return model.id;
  }

  Future delete(KasModel model) async {
    // if (model.photoUrl.isEmptyOrNull) {
    //   return await model.delete();
    // } else
    //   return await model.deleteWithDetails();
    return await model.delete();
  }

  getImage(bool isCam) async {
    return pickedImage = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
  }

  saveKas(KasModel model) async {
    try {
      // var result =
      //     foto == null ? await model.save() : await model.saveWithDetails(foto);
      // if (result is UploadTask) {
      //   UploadTask task = result;
      //   task.snapshotEvents.listen((event) async {
      //     print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
      //   });
      // }
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
  }

  saveKategori(KategoriModel model) async {
    try {
      // var result =
      //     foto == null ? await model.save() : await model.saveWithDetails(foto);
      // if (result is UploadTask) {
      //   UploadTask task = result;
      //   task.snapshotEvents.listen((event) async {
      //     print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
      //   });
      // }
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
  }

  // saveKas(KasModel model, File? foto) async {
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
  // }

  // uploadImage(XFile? pickImage, kasModel kas) async {
  //   if (pickImage != null) {
  //     Reference pathStorage = firebaseStorage
  //         .ref()
  //         .child(masjidCollection)
  //         .child(authController.user.masjid!)
  //         .child(kasCollection)
  //         .child(kas.id ?? "");
  //     var file = File(pickImage.path);
  //     final metadata = SettableMetadata(
  //         contentType: 'image/jpeg',
  //         customMetadata: {
  //           'picked-file-path': pickImage.path,
  //           'picked-file-name': pickImage.name
  //         });

  //     // TaskSnapshot uploadedFile = await pathStorage.putFile(file);

  //     UploadTask uploadTask = pathStorage.putFile(file, metadata);
  //     uploadTask.snapshotEvents.listen((event) async {
  //       print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
  //       uploadPrecentage.value = event.bytesTransferred / event.totalBytes;

  //       if (event.state == TaskState.success) {
  //         photoUrlC = await pathStorage.getDownloadURL();
  //         kas.photoUrl = photoUrlC;
  //         updatekas(kas, authController.user.masjid!);
  //         // await collections(authController.user.masjid!)
  //         //     .doc(deMasjid.id)
  //         //     .update({'photoUrl': photoUrlC});
  //         isLoadingImage.value = false;
  //       } else {}
  //     });
  //   } else {
  //     toast('No Image Picked');
  //   }
  // }

  // checkControllers(kasModel data) {
  //   if (namaC.text != data.nama ||
  //       jabatanC.text != data.jabatan ||
  //       photoLocal != null) {
  //     return true;
  //   } else
  //     return false;
  // }

  clearControllers() {
    // namaC.clear();
    // jabatanC.clear();
    // photoUrlC = null;
    // jabatan = "";
    // photoLocal = null;
    // photoPath = "";
  }
}
