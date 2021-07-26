import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:masjidkita/constants/firebase.dart';
import 'package:nb_utils/nb_utils.dart';

class InventarisEdit extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController kondisiController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();
  final hargaController = MoneyMaskedTextController(
      precision: 3,
      leftSymbol: 'Rp ',
      decimalSeparator: '.',
      initialValue: 0,
      thousandSeparator: '.');

  PickedFile? pickImage;
  String fileName = '', filePath = '';
  final ImagePicker _picker = ImagePicker();
  String message = "Belum ada gambar";

  Future getImage() async {
    pickImage = await ImagePicker().getImage(source: ImageSource.gallery);
    // var dowurl = await (await pickImage.onComplete).ref.getDownloadURL().toString();
    if (pickImage != null) {
      fileName = pickImage!.path.split('/').last;
      filePath = pickImage!.path;
      // Reference reference = firebaseStorage.ref('Inventaris/' + fileName);
      var file = File(filePath);

      var snapshot = await firebaseStorage
          .ref()
          .child('Inventaris/' + fileName)
          .putFile(file);
      fotoController.text = fileName;
    } else {
      print(message);
    }
  }

  Future getImageCam() async {
    pickImage = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickImage != null) {
      fileName = pickImage!.path.split('/').last;
      filePath = pickImage!.path;
      var file = File(filePath);
      var snapshot = await firebaseStorage
          .ref()
          .child('Inventaris/' + fileName)
          .putFile(file);
      fotoController.text = fileName;
    } else {
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(InventarisController());
    final InventarisController inventarisController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: text('Edit Inventaris'),
      ),
      body: Container(
          child: Obx(
        () => inventarisController.inventaris.nama == null
            ? Center(child: text("Tidak ada"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '${inventarisController.inventaris.nama}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: kondisiController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '${inventarisController.inventaris.kondisi}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: hargaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '${inventarisController.inventaris.harga}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Masukkan Jumlah barang',
                        hintText: '${inventarisController.inventaris.jumlah}',
                      ),
                    ),
                  ),
                  TextField(
                    focusNode: FocusNode(),
                    enableInteractiveSelection: false,
                    // style: GoogleFonts.poppins(),
                    enabled: false,
                    controller: fotoController,
                    decoration: InputDecoration(hintText: message),
                  ),
                  Container(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                  ElevatedButton(
                          onPressed: () {
                            inventarisController.updateInventaris(
                              namaController.text,
                              kondisiController.text,
                              int.parse(jumlahController.text),
                              fotoController.text,
                              inventarisController.inventaris.inventarisID,
                              hargaController.text.toInt(),
                            );
                          },
                          child: Text("Ubah"))
                      .center()
                ],
              ),
      )),
    );
  }
}
