import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: must_be_immutable
class InventarisEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: Obx(
          () => Column(
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
              // TextFormField(
              //   initialValue: inventarisC.inventaris.foto,
              //   onChanged: (newValue) {
              //     inventarisC.fotoController.text = newValue;
              //   },
              //   focusNode: FocusNode(),
              //   enableInteractiveSelection: false,
              //   // style: GoogleFonts.poppins(),
              //   enabled: false,
              //   decoration: InputDecoration(hintText: inventarisC.message),
              // ),
              Column(children: [
                Obx(() => inventarisC.inventaris.url != "" &&
                        inventarisC.inventaris.url != null
                    ? Container(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          width: Get.width - 40,
                          placeholder: placeholderWidgetFn() as Widget Function(
                              BuildContext, String)?,
                          imageUrl: inventarisC.downloadUrl.value.isEmpty
                              ? inventarisC.inventaris.url.toString()
                              : inventarisC.downloadUrl.value,
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
                // ElevatedButton(
                //   child: text("Upload Image", textColor: mkWhite),
                //   style: ElevatedButton.styleFrom(
                //     primary: mkColorPrimary,
                //   ),
                //   onPressed: () {
                //     getImage();
                //     // manMasjidC.uploadImage(image!);
                //   },
                // ),
                //   Container(
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                //     child: PopupMenuButton(
                //       itemBuilder: (context) => [
                //         PopupMenuItem(
                //             child: Icon(Icons.photo_album), value: "gallery"),
                //         PopupMenuItem(child: Icon(Icons.camera), value: "cam")
                //       ],
                //       onSelected: (value) async {
                //         if (value == "gallery") {
                //           inventarisC.uploadImage(false);
                //         } else {
                //           inventarisC.uploadImage(true);
                //         }
                //       },
                //       child: Text("Pilih gambar"),
                //       offset: Offset(0, 25),
                //     ),
                //   ),
                // ),

                ElevatedButton(
                  child: text("Ubah Foto", textColor: mkWhite),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: appStore.scaffoldBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        builder: (builder) {
                          return Container(
                              height: 250.0,
                              padding: EdgeInsets.all(16),
                              child: Obx(
                                () => inventarisC.isLoadingImage.value
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          text("Loading..."),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          LinearProgressIndicator(
                                            value: inventarisC
                                                .uploadPrecentage.value,
                                          )
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Upload Foto dari",
                                            style: boldTextStyle(
                                                color:
                                                    appStore.textPrimaryColor),
                                          ),
                                          16.height,
                                          Divider(
                                            height: 5,
                                          ),
                                          16.height,
                                          TextButton.icon(
                                              // style: ,
                                              onPressed: () {
                                                inventarisC.uploadImage(false);
                                              },
                                              icon: Icon(
                                                Icons.image_sharp,
                                                color: mkColorPrimaryDark,
                                              ),
                                              label: text(
                                                "Galeri",
                                                textColor: mkColorPrimaryDark,
                                              )),
                                          Divider(),
                                          TextButton.icon(
                                              // style: ,
                                              onPressed: () async {
                                                inventarisC.uploadImage(true);
                                              },
                                              icon: Icon(
                                                Icons.camera,
                                                color: mkColorPrimaryDark,
                                              ),
                                              label: text(
                                                "Kamera",
                                                textColor: mkColorPrimaryDark,
                                              )),
                                          8.height,
                                        ],
                                      ),
                              ));
                        });

                    // manMasjidC.uploadImage(image!);
                  },
                ),
              ]),
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
        )),
        // )
      ),
    );
  }
}
