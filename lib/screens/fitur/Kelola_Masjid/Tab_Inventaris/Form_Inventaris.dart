import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:get/get.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/controllers/inventarisController.dart';

class FormInventaris extends StatelessWidget {
  static const tag = '/FormInventaris';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                inventarisC.checkControllers()
                    ? showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) => ConfirmDialog(),
                      )
                    : finish(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(
              context,
              mk_add_inventaris,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, manMasjidC.deMasjid.nama ?? mk_add_masjid),
          body: StepperBody()),
    );
  }
}

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
          title: Text("Data inventaris"),
          content: Column(children: <Widget>[
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
          ]),
          isActive: currStep == 0,
          state: StepState.complete),
      Step(
          title: Text("Foto"),
          content: Column(
            children: <Widget>[
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
              ),
              ElevatedButton(
                child: text("Upload Foto",
                    textColor: mkWhite, fontSize: textSizeSMedium),
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
              // Opacity(
              //   opacity: 0.0,
              //   child: TextField(
              //     focusNode: FocusNode(),
              //     enableInteractiveSelection: false,
              //     // style: GoogleFonts.poppins(),
              //     enabled: false,
              //     controller: inventarisC.fotoController,
              //   ),
              // ),
              ElevatedButton(
                onPressed: () {
                  inventarisC
                      .addInventaris(authController.firebaseUser.value.uid);
                },
                child: text("Tambahkan",
                    textColor: mkWhite, fontSize: textSizeMedium),
                style: ElevatedButton.styleFrom(
                  primary: mkColorPrimary,
                ),
              ).center()
            ],
          ),
          isActive: currStep == 1,
          state: StepState.disabled),
    ];

    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: ThemeData(colorScheme: mkColorScheme),
          child: Stepper(
            steps: steps,
            type: StepperType.horizontal,
            currentStep: this.currStep,
            controlsBuilder: (BuildContext context,
                {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  currStep < steps.length - 1
                      ? TextButton(
                          onPressed: onStepContinue,
                          child: Text(mk_berikut, style: secondaryTextStyle()),
                        )
                      : 10.width,
                  currStep != 0
                      ? TextButton(
                          onPressed: onStepCancel,
                          child: Text(mk_sebelum, style: secondaryTextStyle()),
                        )
                      : 10.width,
                ],
              );
            },
            onStepContinue: () {
              setState(() {
                if (currStep < steps.length - 1) {
                  currStep = currStep + 1;
                } else {
                  //currStep = 0;
                  finish(context);
                }
              });
            },
            onStepCancel: () {
              // finish(context);
              setState(() {
                if (currStep > 0) {
                  currStep = currStep - 1;
                } else {
                  currStep = 0;
                }
              });
            },
            onStepTapped: (step) {
              setState(() {
                currStep = step;
              });
            },
          ),
        ),
      ),
    );
  }
}
