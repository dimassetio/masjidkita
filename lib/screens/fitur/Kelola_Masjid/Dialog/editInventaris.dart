import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masjidkita/constants/firebase.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: must_be_immutable
class InventarisEdit extends StatelessWidget {
  PickedFile? pickImage;
  String fileName = '', filePath = '';
  final ImagePicker _picker = ImagePicker();
  String message = "Belum ada gambar";

  Future getImage() async {
    final FirebaseStorage feedStorage = FirebaseStorage.instanceFor();
    // final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.gallery);
    // pickImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickImage != null) {
      // fileName = pickImage.name.split('/').last;
      fileName = pickImage.name;
      filePath = pickImage.path;
      String files = pickImage.path;
      Reference refFeedBucket =
          feedStorage.ref().child('inventaris').child(files);
      Reference refFeedBuckets =
          firebaseStorage.ref().child('inventaris').child(files);
      // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
      String downloadUrl;
      var file = File(files);

      TaskSnapshot uploadedFile = await refFeedBuckets.putFile(file);

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
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.camera);
    // pickImage = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickImage != null) {
      fileName = pickImage.name;
      filePath = pickImage.path;
      String files = pickImage.path;
      Reference refFeedBucket =
          feedStorage.ref().child('inventaris').child(files);
      Reference refFeedBuckets =
          firebaseStorage.ref().child('inventaris').child(files);
      // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
      String downloadUrl;
      var file = File(files);

      TaskSnapshot uploadedFile = await refFeedBuckets.putFile(file);

      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await refFeedBucket.getDownloadURL();
        inventarisC.fotoController.text = fileName;
        inventarisC.urlController.text = downloadUrl;
      } else {
        print(message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(InventarisController());
    return Scaffold(
      appBar: AppBar(
        title: text('Edit Inventaris'),
      ),
      body: Container(
        child:
            //   Obx(
            // () => inventarisC.inventaris.inventarisID == null
            //     ? Center(child: text("Tidak ada"))
            //     :
            SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  initialValue: inventarisC.inventaris.nama,
                  onChanged: (newValue) {
                    inventarisC.namaController.text = newValue;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nama barang',
                    hintText: '${inventarisC.inventaris.nama}',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  initialValue: inventarisC.inventaris.kondisi,
                  onChanged: (newValue) {
                    inventarisC.kondisiController.text = newValue;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Kondisi',
                    hintText: '${inventarisC.inventaris.kondisi}',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  onChanged: (newValue) {
                    inventarisC.hargaController.text = newValue;
                  },
                  initialValue: inventarisC.inventaris.harga.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Harga satuan',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  onChanged: (newValue) {
                    inventarisC.jumlahController.text = newValue;
                  },
                  initialValue: inventarisC.inventaris.jumlah.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Jumlah barang',
                    hintText: '${inventarisC.inventaris.jumlah}',
                  ),
                ),
              ),
              TextFormField(
                initialValue: inventarisC.inventaris.foto,
                onChanged: (newValue) {
                  inventarisC.fotoController.text = newValue;
                },
                focusNode: FocusNode(),
                enableInteractiveSelection: false,
                // style: GoogleFonts.poppins(),
                enabled: false,
                decoration: InputDecoration(hintText: message),
              ),

              Column(children: [
                Obx(() => inventarisC.inventaris.url != "" &&
                        inventarisC.inventaris.url != null
                    ? Container(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          width: Get.width - 40,
                          placeholder: placeholderWidgetFn() as Widget Function(
                              BuildContext, String)?,
                          imageUrl: inventarisC.inventaris.url ?? "",
                          fit: BoxFit.cover,
                        ),
                      )
                    : text('Belum Ada Gambar', fontSize: textSizeSMedium)),
                // Image.network(
                //       manMasjidC.deMasjid.photoUrl ?? "",
                //       loadingBuilder: (BuildContext context, Widget child,
                //           ImageChunkEvent? loadingProgress) {
                //         if (loadingProgress == null) {
                //           return child;
                //         }
                //         return Center(
                //           child: CircularProgressIndicator(
                //             value: loadingProgress.expectedTotalBytes != null
                //                 ? loadingProgress.cumulativeBytesLoaded /
                //                     loadingProgress.expectedTotalBytes!
                //                 : null,
                //           ),
                //         );
                //       },
                //       errorBuilder: (BuildContext context, Object exception,
                //           StackTrace? stackTrace) {
                //         return const Text("Belum Ada Gambar");
                //       },
                //     ),
                // ),
                ElevatedButton(
                  child: text("Upload Image", textColor: mkWhite),
                  style: ElevatedButton.styleFrom(
                    primary: mkColorPrimary,
                  ),
                  onPressed: () {
                    getImage();
                    // manMasjidC.uploadImage(image!);
                  },
                ),
              ]),

              // Container(
              //   child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              //     child: PopupMenuButton(
              //       itemBuilder: (context) => [
              //         PopupMenuItem(
              //             child: Icon(Icons.photo_album), value: "gallery"),
              //         PopupMenuItem(child: Icon(Icons.camera), value: "cam")
              //       ],
              //       onSelected: (value) async {
              //         if (value == "gallery") {
              //           getImage();
              //         } else {
              //           getImageCam();
              //         }
              //       },
              //       child: Text("Ubah foto"),
              //       offset: Offset(0, 25),
              //     ),
              //   ),
              // ),
              ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: mkColorPrimary,
                      ),
                      onPressed: () {
                        inventarisC.updateInventaris();
                      },
                      child: Text("Ubah"))
                  .center()
            ],
          ),
        ),
        // )
      ),
    );
  }
}
