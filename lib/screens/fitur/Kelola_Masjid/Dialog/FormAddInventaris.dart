import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masjidkita/constants/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/main.dart';

// ignore: must_be_immutable
class AddInventarisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(InventarisController());
    // final InventarisController inventarisController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: text('Tambah Inventaris'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: inventarisC.namaController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'ex: Karpet',
                    labelText: 'Nama Barang',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: inventarisC.kondisiController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'ex: Baik',
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
                    hintText: 'misal: Rp. 15.000,-',
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
                    hintText: 'ex: 20',
                    labelText: 'Masukkan Jumlah barang',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: TextField(
                  focusNode: FocusNode(),
                  enableInteractiveSelection: false,
                  // style: GoogleFonts.poppins(),
                  enabled: false,
                  controller: inventarisC.fotoController,
                  decoration: InputDecoration(hintText: inventarisC.message),
                ),

                // Obx(() => inventarisC.inventaris.url != "" &&
                //         inventarisC.inventaris.url != null
                //     ? CachedNetworkImage(
                //         placeholder: placeholderWidgetFn() as Widget
                //             Function(BuildContext, String)?,
                //         imageUrl: inventarisC.inventaris.url ?? "",
                //         fit: BoxFit.fill,
                //       )
                //     : text('Belum Ada Gambar', fontSize: textSizeSMedium)),
              ),
              // Container(
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
                child: text("Upload Foto", textColor: mkWhite),
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
                                              color: appStore.textPrimaryColor),
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

                  // inventarisC.inventarisage(image!);
                },
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
              Opacity(
                opacity: 0.0,
                child: TextField(
                  focusNode: FocusNode(),
                  enableInteractiveSelection: false,
                  // style: GoogleFonts.poppins(),
                  enabled: false,
                  controller: inventarisC.fotoController,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  inventarisC
                      .addInventaris(authController.firebaseUser.value.uid);
                },
                child: Text("Tambahkan"),
                style: ElevatedButton.styleFrom(
                  primary: mkColorPrimary,
                ),
              ).center()
            ],
          ),
        ),
      ),
    );
  }
}
