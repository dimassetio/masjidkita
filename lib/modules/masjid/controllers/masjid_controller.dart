import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class MasjidController extends GetxController {
  static MasjidController instance = Get.find();

  RxList<MasjidModel> listMasjid = RxList<MasjidModel>();
  List<MasjidModel> get masjids => listMasjid.value;

  RxList<MasjidModel> favoritMasjid = RxList<MasjidModel>();
  List<MasjidModel> get favMasjids => favoritMasjid.value;

  RxList<MasjidModel> resultsList = RxList<MasjidModel>();
  List<MasjidModel> get filteredMasjid => resultsList.value;

  TextEditingController searchController = TextEditingController();

  var isSearching = false.obs;
  final box = GetStorage();

  var idFavorit = [
    "Null Safety",
  ].obs;

  var emptyValue = false.obs;
  var myMasjid = false.obs;
  var isSaving = false.obs;

  List<String> get idFav => idFavorit;

  @override
  void onInit() async {
    super.onInit();
    // getInitialMasjid();
    listMasjid.bindStream(MasjidModel().dao.masjidStream());
    searchController.addListener(_onSearchChanged);
    readStr();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.clear();
  }

  clearController() {
    searchController.clear();
  }

  _onSearchChanged() {
    if (searchController.text == "") {
      isSearching.value = false;
    } else {
      isSearching.value = true;
    }
    searchResultsList();
  }

  searchResultsList() {
    List<MasjidModel> showResults = [];

    if (searchController.text != "") {
      for (var masjidSnapshot in masjids) {
        var nama = masjidSnapshot.nama!.toLowerCase();
        var alamat = masjidSnapshot.alamat!.toLowerCase();

        if (alamat.contains(searchController.text.toLowerCase()) ||
            nama.contains(searchController.text.toLowerCase())) {
          showResults.add(masjidSnapshot);
          emptyValue.value = false;
        } else {
          emptyValue.value = true;
        }
        // if (nama.contains(searchController.text.toLowerCase())) {
        //   showResults.add(masjidSnapshot);
        // }
      }
    } else {
      // showResults = masjids;
    }

    resultsList.value = showResults;
  }

  isMyFav(id) {
    return idFavorit.contains(id);
  }

  addFav(id) {
    idFavorit.contains(id) ? idFavorit.remove(id) : idFavorit.add(id);
    addStr();
    print(idFav);
  }

  addStr() {
    box.write('favMasjid', idFavorit);
    refreshFav();
  }

  deleteStr() {
    box.remove('favMasjid');
  }

  readStr() {
    var r = box.read('favMasjid');
    if (r != null) {
      idFavorit.value = List.from(r);
    }
    // print(r);
    // print([idFav, "p"]);
    refreshFav();
  }

  refreshFav() {
    // idFavorit.value = [];
    // print(idFav);
    favoritMasjid.bindStream(masjidFavoritStream());
  }

  Stream<List<MasjidModel>> masjidFavoritStream() {
    return firebaseFirestore
        .collection(masjidCollection)
        .where("id", whereIn: idFav)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MasjidModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(MasjidModel.fromSnapshot(element));
      });
      return retVal;
    });
  }

  // FROM MANMASJID

  gotoDetail(MasjidModel dataMasjid) async {
    try {
      takmirC.getTakmirStream(dataMasjid.id!);
    } catch (e) {
      toast(e.toString());
    } finally {
      await isMyMasjid(dataMasjid);
      await Get.toNamed(RouteName.detail, arguments: dataMasjid);
    }
  }

  Future saveMasjid(MasjidModel model, File? foto) async {
    isSaving.value = true;
    try {
      foto == null ? await model.save() : await model.saveWithDetails(foto);
      uploadToStorage();
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
      isSaving.value = false;
    }
  }

  isMyMasjid(
    MasjidModel masjid,
  ) {
    print("user ${authController.user.masjid}");
    print("masjid ${masjid.id}");
    authController.user.masjid != null
        ? masjid.id == authController.user.masjid
            ? myMasjid.value = true
            : myMasjid.value = false
        : myMasjid.value = false;
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
    pickedImage = await getImage(isCam);
    // await uploadToStorage(pickedImage);
  }

  getImage(bool isCam) async {
    return pickedImage = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
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
  }
}
