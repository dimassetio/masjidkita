import 'dart:io';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masjidkita/constants/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/inventarisController.dart';

// ignore: must_be_immutable
class AddInventarisPage extends StatelessWidget {
  PickedFile? pickImage;
  String fileName = '', filePath = '';
  final ImagePicker _picker = ImagePicker();
  String message = "Belum ada gambar";

  // Future getImage() async {
  //   pickImage = await ImagePicker().getImage(source: ImageSource.gallery);
  //   // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
  //   if (pickImage != null) {
  //     fileName = pickImage!.path.split('/').last;
  //     filePath = pickImage!.path;
  //     // Reference reference = firebaseStorage.ref('Inventaris/' + fileName);
  //     var file = File(filePath);

  //     var snapshot =
  //         await firebaseStorage.ref().child('Inventaris').child(fileName);
  //     // .putFile(file);
  //     snapshot.putFile(file);
  //     var url =
  //         await snapshot.child('inventaris').child(fileName).getDownloadURL();
  //     fotoController.text = fileName;
  //     urlController.text = url;
  //   } else {
  //     print(message);
  //   }
  // }

  Future getImage() async {
    final FirebaseStorage feedStorage = FirebaseStorage.instanceFor();
    // final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.gallery);
    // pickImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickImage != null) {
      Reference refFeedBucket =
          feedStorage.ref().child('inventaris').child(filePath);
      // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
      String downloadUrl;
      var file = File(filePath);

      TaskSnapshot uploadedFile = await refFeedBucket.putFile(file);

      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await refFeedBucket.getDownloadURL();
        inventarisC.fotoController.text = fileName;
        inventarisC.urlController.text = downloadUrl;
      } else {
        print(message);
      }
    }
  }

  Future getImageCam() async {
    final FirebaseStorage feedStorage = FirebaseStorage.instanceFor();
    pickImage = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickImage != null) {
      Reference refFeedBucket =
          feedStorage.ref().child('inventaris').child(filePath);
      // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
      String downloadUrl;
      var file = File(filePath);

      TaskSnapshot uploadedFile = await refFeedBucket.putFile(file);

      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await refFeedBucket.getDownloadURL();
        inventarisC.fotoController.text = fileName;
        inventarisC.urlController.text = downloadUrl;
      } else {
        print(message);
      }
    }
    // if (pickImage != null) {
    //   fileName = pickImage!.path.split('/').last;
    //   filePath = pickImage!.path;
    //   // Reference reference = firebaseStorage.ref('Inventaris/' + fileName);
    //   var file = File(filePath);

    //   var snapshot =
    //       await firebaseStorage.ref().child('Inventaris').child(fileName);
    //   // .putFile(file);
    //   snapshot.putFile(file);
    //   var url =
    //       await snapshot.child('inventaris').child(fileName).getDownloadURL();
    //   fotoController.text = fileName;
    //   urlController.text = url;
    // } else {
    //   print(message);
    // }
  }

  // Future getImageCam() async {
  //   pickImage = await ImagePicker().getImage(source: ImageSource.camera);
  //   if (pickImage != null) {
  //     fileName = pickImage!.path.split('/').last;
  //     filePath = pickImage!.path;
  //     var file = File(filePath);
  //     var snapshot =
  //         await firebaseStorage.ref().child('Inventaris/' + fileName);
  //     // .putFile(file);

  //     snapshot.putFile(file);
  //     var url =
  //         await snapshot.child('inventaris').child(fileName).getDownloadURL();
  //     fotoController.text = fileName;
  //     urlController.text = url;
  //   } else {
  //     print(message);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Get.put(InventarisController());
    final InventarisController inventarisController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: text('Tambah Inventaris'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: inventarisC.namaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nama Barang',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: inventarisC.kondisiController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Kondisi barang',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: inventarisC.hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Masukkan Harga barang (satuan)',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: inventarisC.jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Masukkan Jumlah barang',
                ),
              ),
            ),
            TextField(
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              // style: GoogleFonts.poppins(),
              enabled: false,
              controller: inventarisC.fotoController,
              decoration: InputDecoration(hintText: message),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Icon(Icons.photo_album), value: "gallery"),
                    PopupMenuItem(child: Icon(Icons.camera), value: "cam")
                  ],
                  onSelected: (value) async {
                    if (value == "gallery") {
                      getImage();
                    } else {
                      getImageCam();
                    }
                  },
                  child: Text("Pilih gambar"),
                  offset: Offset(0, 25),
                ),
              ),
            ),
            Opacity(
              opacity: 0.0,
              child: TextField(
                focusNode: FocusNode(),
                enableInteractiveSelection: false,
                // style: GoogleFonts.poppins(),
                enabled: false,
                controller: inventarisC.urlController,
              ),
            ),
            ElevatedButton(
                    onPressed: () {
                      inventarisController.addInventaris();
                    },
                    child: Text("Tambahkan"))
                .center()
          ],
        ),
      ),
    );
  }
}
