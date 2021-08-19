import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:get/get.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InventarisController extends GetxController {
  var isSaving = false.obs;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController kondisiController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  // var hargaController = MoneyMaskedTextController(
  //     precision: 3,
  //     leftSymbol: 'Rp',
  //     decimalSeparator: '.',
  //     // initialValue: 0,
  //     thousandSeparator: '.');

  var hargaController = TextEditingController();

  static InventarisController instance = Get.find();

  RxList<InventarisModel> inventarisList = RxList<InventarisModel>();
  List<InventarisModel> get inventariss => inventarisList.value;

  Rx<InventarisModel> _inventarisModel = InventarisModel().obs;
  InventarisModel get inventaris => _inventarisModel.value;

  addInventaris(String userId) async {
    Map<String, dynamic> data = new HashMap();
    DateTime now = DateTime.now();
    String harga = hargaController.text;
    String result = harga.replaceAll('Rp', '');
    String finalHarga = result.replaceAll('.', '');
    int price = finalHarga.toInt();
    int jumlah = jumlahController.text.toInt();
    int totalPrice = price * jumlah;
    if (namaController.text != "") data['nama'] = namaController.text;
    if (jumlahController.text != "") data["jumlah"] = jumlah;
    if (kondisiController.text != "") data["kondisi"] = kondisiController.text;
    if (urlController.text != "") data["url"] = urlController.text;
    if (hargaController.text != "") data["harga"] = price;
    if (fotoController.text != "") data["foto"] = fotoController.text;
    data["hargaTotal"] = totalPrice;
    data["updatedAt"] = now;
    String? docID = Get.parameters['id'];

    try {
      docID == null
          ? await firebaseFirestore
              .collection(masjidCollection)
              .doc(userId)
              .collection(inventarisCollection)
              .add(data)
          : await firebaseFirestore
              .collection(masjidCollection)
              .doc(userId)
              .collection(inventarisCollection)
              .doc(docID)
              .update(data);
    } catch (e) {
      print(e);
      rethrow;
    }
    clearController();
    Get.back(); // Get.toNamed(RouteName.kelolamasjid);
  }

  clearController() {
    namaController.clear();
    fotoController.clear();
    urlController.clear();
    jumlahController.clear();
    kondisiController.clear();
    hargaController.clear();
  }

  tesBind() {
    inventarisList.bindStream(inventarisStream());
  }

  set inventaris(InventarisModel value) => this._inventarisModel.value = value;

  // void getInventaris(inventarisID) async {
  //   inventaris = await Database().getInventaris(inventarisID);
  //   // inventarisList.bindStream(Database().inventarisStream());
  // }
  getInventarisModel(inventarisID) async {
    try {
      // print(mID);
      _inventarisModel.value = await firebaseFirestore
          .collection(masjidCollection)
          .doc(manMasjidC.deMasjid.id)
          .collection(inventarisCollection)
          .doc(inventarisID)
          .get()
          .then((doc) => InventarisModel.fromDocumentSnapshot(doc));
    } catch (e) {
      print(inventarisID);
      print(e);
      _inventarisModel.value = InventarisModel();
    }
  }
  // Future<InventarisModel> getInventaris(String inventarisID) async {
  //   DocumentSnapshot doc = await firebaseFirestore
  //       .collection("inventaris")
  //       .doc(inventarisID)
  //       .get();
  //   return InventarisModel.fromDocumentSnapshot(doc);
  //   // try {
  //   //   DocumentSnapshot doc = await firebaseFirestore
  //   //       .collection("inventaris")
  //   //       .doc(inventarisID)
  //   //       .get();
  //   //   return InventarisModel.fromDocumentSnapshot();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  // }

  updateInventaris() async {
    Map<String, dynamic> data = new HashMap();
    DateTime now = DateTime.now();
    String harga = hargaController.text;
    String result = harga.replaceAll('Rp', '');
    String finalHarga = result.replaceAll('.', '');
    int price = finalHarga.toInt();
    int jumlah = jumlahController.text.toInt();
    int totalPrice = price * jumlah;
    if (namaController.text != "") data['nama'] = namaController.text;
    if (jumlahController.text != "") data["jumlah"] = jumlah;
    if (kondisiController.text != "") data["kondisi"] = kondisiController.text;
    if (urlController.text != "") data["url"] = urlController.text;
    if (hargaController.text != "") data["harga"] = price;
    if (fotoController.text != "") data["foto"] = fotoController.text;
    data["hargaTotal"] = totalPrice;
    data["updatedAt"] = now;
    // await firebaseFirestore
    //     .collection(masjidCollection)
    //     .doc(manMasjidC.deMasjid.id)
    //     .collection(inventarisCollection)
    //     .doc(inventaris.inventarisID)
    //     .update(data);
    // clearControllers();

    isSaving.value = true;
    try {
      await firebaseFirestore
          .collection(masjidCollection)
          .doc(manMasjidC.deMasjid.id)
          .collection(inventarisCollection)
          .doc(inventaris.inventarisID)
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

    // Get.back();
  }

  deleteInventaris(inventarisID, url) async {
    try {
      firebaseFirestore
          .collection(masjidCollection)
          .doc(manMasjidC.deMasjid.id)
          .collection(inventarisCollection)
          .doc(inventarisID)
          .delete();
      firebaseStorage.refFromURL(url).delete();
    } finally {
      toast("Successfully Deleted");
    }
    // var imageRef = firebaseStorage.ref().child(
    //     'inventaris/18ae6632-7083-49dd-b0d3-e7a617346b564771009612812182052.jpg');
    // imageRef.delete();
    // print(imageRef);
    // firebaseStorage
    //     .refFromURL("gs://mosq-2d58e.appspot.com//Inventaris/${foto}")
    //     .delete();
    // print(foto);
    // Get.back();
    // Get.toNamed(RouteName.inventaris);
  }

  clearControllers() {
    namaController.clear();
    jumlahController.clear();
    kondisiController.clear();
    fotoController.clear();
    hargaController.clear();
    // photo_url.clear();
  }

  void clear() {
    _inventarisModel.value = InventarisModel();
  }

  checkControllers() {
    if (namaController.text != inventaris.nama ||
        jumlahController.text != inventaris.jumlah.toString() ||
        kondisiController.text != inventaris.kondisi ||
        // fotoController.text != inventaris.foto ||
        // urlController.text != inventaris.url ||
        hargaController.text != inventaris.harga.toString()) {
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
          .child(inventarisCollection)
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
    inventarisList.bindStream(inventarisStream());
  }

  Stream<List<InventarisModel>> inventarisStream() {
    return firebaseFirestore
        .collection(masjidCollection)
        .doc(manMasjidC.deMasjid.id)
        .collection("inventaris")
        .snapshots()
        .map((QuerySnapshot query) {
      List<InventarisModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(InventarisModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}
