import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TakmirController extends GetxController {
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

  static TakmirController instance = Get.find();

  RxList<TakmirModel> takmirList = RxList<TakmirModel>();
  List<TakmirModel> get takmirs => takmirList.value;

  Rx<TakmirModel> _takmirModel = TakmirModel().obs;
  TakmirModel get takmir => _takmirModel.value;
  CollectionReference collections(String masjidID) {
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(masjidID)
        .collection(takmirCollection);
  }

  @override
  void onInit() {
    super.onInit();
    // takmirList.bindStream(takmirStream());
  }

  // Stream<List<TakmirModel>> takmirStream(String masjidID) async* {
  //   yield* collections(masjidID).snapshots().map((QuerySnapshot query) {
  //     List<TakmirModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TakmirModel().fromSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }

  getTakmirStream(MasjidModel model) {
    // takmirList.bindStream(takmirStream(model.id!));
    takmirList.bindStream(model.takmirDao!.takmirStream(model));
  }

  //Single
  Map<String, dynamic> getData(TakmirModel model) {
    return {
      'nama': model.nama,
      'jabatan': model.jabatan,
      'id': model.id,
      'photoUrl': model.photoUrl,
    };
  }

  var uploadPrecentage = 0.0.obs;
  var isLoadingImage = false.obs;

  Future store(TakmirModel model, String masjidID) async {
    var result = await collections(masjidID).add(getData(model));
    return result.id;
  }

  Future updateTakmir(TakmirModel model, String masjidID) async {
    await collections(masjidID).doc(model.id).set(getData(model));
    return model.id;
  }

  Future delete(TakmirModel model) async {
    if (model.photoUrl.isEmptyOrNull) {
      return await model.delete();
    } else
      return await model.deleteWithDetails();
  }

  getImage(bool isCam) async {
    return pickedImage = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
  }

  saveTakmir(TakmirModel model, File? foto) async {
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
  }

  uploadImage(XFile? pickImage, TakmirModel takmir) async {
    if (pickImage != null) {
      Reference pathStorage = firebaseStorage
          .ref()
          .child(masjidCollection)
          .child(authController.user.masjid!)
          .child(takmirCollection)
          .child(takmir.id ?? "");
      var file = File(pickImage.path);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'picked-file-path': pickImage.path,
            'picked-file-name': pickImage.name
          });

      // TaskSnapshot uploadedFile = await pathStorage.putFile(file);

      UploadTask uploadTask = pathStorage.putFile(file, metadata);
      uploadTask.snapshotEvents.listen((event) async {
        print("uploading : ${event.bytesTransferred} / ${event.totalBytes}");
        uploadPrecentage.value = event.bytesTransferred / event.totalBytes;

        if (event.state == TaskState.success) {
          photoUrlC = await pathStorage.getDownloadURL();
          takmir.photoUrl = photoUrlC;
          updateTakmir(takmir, authController.user.masjid!);
          // await collections(authController.user.masjid!)
          //     .doc(deMasjid.id)
          //     .update({'photoUrl': photoUrlC});
          isLoadingImage.value = false;
        } else {}
      });
    } else {
      toast('No Image Picked');
    }
  }

  // checkControllers(TakmirModel data) {
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
    photoUrlC = null;
    jabatan = "";
    photoLocal = null;
    photoPath = "";
  }
}
