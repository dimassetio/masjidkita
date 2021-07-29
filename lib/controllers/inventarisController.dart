import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/services/database.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:nb_utils/nb_utils.dart';

class InventarisController extends GetxController {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController kondisiController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final hargaController = MoneyMaskedTextController(
      precision: 3,
      leftSymbol: 'Rp ',
      decimalSeparator: '.',
      // initialValue: 0,
      thousandSeparator: '.');

  static InventarisController instance = Get.find();

  RxList<InventarisModel> inventarisList = RxList<InventarisModel>();
  List<InventarisModel> get inventariss => inventarisList.value;

  Rx<InventarisModel> _inventarisModel = InventarisModel().obs;
  InventarisModel get inventaris => _inventarisModel.value;

  addInventaris() async {
    String harga = hargaController.text;
    String result = harga.replaceAll('Rp ', '');
    String finalHarga = result.replaceAll('.', '');
    int price = finalHarga.toInt();
    int jumlah = jumlahController.text.toInt();
    int totalPrice = price * jumlah;
    print("Nama = ${namaController.text}");
    DateTime now = DateTime.now();
    // int hargaTotal = jumlah!;
    try {
      await firebaseFirestore.collection("inventaris").add({
        'nama': namaController.text,
        'foto': fotoController.text,
        'url': urlController.text,
        'jumlah': jumlahController.text.toInt(),
        'kondisi': kondisiController.text,
        'createdAt': now,
        'harga': finalHarga.toInt(),
        'hargaTotal': totalPrice,
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
          .collection("inventaris")
          .doc(inventarisID)
          .get()
          .then((doc) => InventarisModel.fromDocumentSnapshot(doc));
    } catch (e) {
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

  updateInventaris(String? nama, String? kondisi, int? jumlah,
      String? inventarisID, String? foto, int? harga) {
    print('controller passed');

    Database()
        .updateInventaris(nama, kondisi, jumlah, inventarisID, foto, harga);
    Get.toNamed(RouteName.kelolamasjid);
  }

  deleteInventaris(
    inventarisID,
  ) {
    try {
      firebaseFirestore.collection("inventaris").doc(inventarisID).delete();
    } finally {
      toast("Successfully Deleted");
    }
    // var imageRef = firebaseStorage.ref().child(
    //     'inventaris/18ae6632-7083-49dd-b0d3-e7a617346b564771009612812182052.jpg');
    // imageRef.delete();
    // print(imageRef);
    // firebaseStorage
    //     .refFromURL("gs://masjidkita-2d58e.appspot.com//Inventaris/${foto}")
    //     .delete();
    // print(foto);
    // Get.back();
    // Get.toNamed(RouteName.inventaris);
  }

  void clear() {
    _inventarisModel.value = InventarisModel();
  }

  @override
  void onInit() {
    super.onInit();
    inventarisList.bindStream(inventarisStream());
  }

  Stream<List<InventarisModel>> inventarisStream() {
    return firebaseFirestore
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
