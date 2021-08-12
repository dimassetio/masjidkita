import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mosq/helpers/validator.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
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
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    inventarisC
                        .addInventaris(authController.firebaseUser.value.uid);
                  },
                  child: Icon(
                    Icons.check,
                    size: 26.0,
                    color: mkColorPrimary,
                  ),
                ),
              )
            ],
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
  void initState() {
    super.initState();
    if (Get.parameters['id'] != null) {
      inventarisC.namaController.text = inventarisC.inventaris.nama ?? "";
      inventarisC.kondisiController.text = inventarisC.inventaris.kondisi ?? "";
      inventarisC.fotoController.text = inventarisC.inventaris.foto ?? "";
      inventarisC.urlController.text = inventarisC.inventaris.url ?? "";
      inventarisC.hargaController.text =
          inventarisC.inventaris.harga.toString();
      inventarisC.jumlahController.text =
          inventarisC.inventaris.jumlah.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    inventarisC.clearControllers();
    inventarisC.downloadUrl.value = "";
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text("Data inventaris"),
        content: Column(children: <Widget>[
          // Padding(
          // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          EditText(
            fontSize: textSizeMedium,
            mController: inventarisC.namaController,
            hint: mk_hint_nama_inventaris,
            label: mk_lbl_nama_inventaris,
            // validator: (s) {
            //   if (s!.trim().isEmpty)
            //     return '$mk_lbl_nama_inventaris $mk_is_required';
            //   return null;
            // },
            validator: (value) =>
                (Validator(attributeName: mk_lbl_nama_inventaris, value: value)
                      ..required())
                    .getError(),
          ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              mController: inventarisC.kondisiController,
              hint: mk_hint_kondisi_inventaris,
              label: mk_lbl_kondisi_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_kondisi_inventaris, value: value)
                    ..required())
                  .getError(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              mController: inventarisC.hargaController,
              keyboardType: TextInputType.number,
              hint: mk_hint_harga_inventaris,
              label: mk_lbl_harga_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_harga_inventaris, value: value)
                    ..required())
                  .getError(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              mController: inventarisC.jumlahController,
              keyboardType: TextInputType.number,
              hint: mk_hint_jumlah_inventaris,
              label: mk_lbl_jumlah_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_jumlah_inventaris, value: value)
                    ..required())
                  .getError(),
            ),
          ),
        ]),
        isActive: currStep == 0,
      ),
      Step(
          title: Text("Foto"),
          content: Column(
            children: <Widget>[
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: TextFormField(
                  focusNode: FocusNode(),
                  enableInteractiveSelection: false,
                  // style: GoogleFonts.poppins(),
                  enabled: false,
                  controller: inventarisC.fotoController,
                  decoration: InputDecoration(hintText: inventarisC.message),
                  // validator: (s) {
                  //   if (s!.trim().isEmpty)
                  //     return '$mk_lbl_foto_inventaris $mk_is_required';
                  //   return null;
                  // },
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
                                        ),
                                        text(
                                            "${(inventarisC.uploadPrecentage.value * 100).toInt()} %"),
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
              // ElevatedButton(
              //   onPressed: () {
              //     inventarisC
              //         .addInventaris(authController.firebaseUser.value.uid);
              //   },
              //   child: text("Tambahkan",
              //       textColor: mkWhite, fontSize: textSizeMedium),
              //   style: ElevatedButton.styleFrom(
              //     primary: mkColorPrimary,
              //   ),
              // ).center()
            ],
          ),
          isActive: currStep == 1,
          state: StepState.disabled),
    ];

    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: ThemeData(colorScheme: mkColorScheme),
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  steps: steps,
                  type: StepperType.horizontal,
                  currentStep: this.currStep,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback? onStepContinue,
                      VoidCallback? onStepCancel}) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        currStep != 0
                            ? TextButton(
                                onPressed: onStepCancel,
                                child: Text(mk_sebelum,
                                    style: secondaryTextStyle(),
                                    textAlign: TextAlign.start),
                              )
                            : 10.width,
                        currStep < steps.length - 1
                            ? TextButton(
                                onPressed: onStepContinue,
                                child: Text(mk_berikut,
                                    style: secondaryTextStyle(),
                                    textAlign: TextAlign.end),
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
              // Obx(
              //   () => GestureDetector(
              //     onTap: () async {
              //       if (inventarisC.isSaving.value == false) {
              //         if (_formKey.currentState!.validate()) {
              //           // _formKey.currentState!.deactivate();
              //           // _formKey.currentState!.save();
              //           setState(() {});
              //           await inventarisC.updateInventaris();
              //           // setState(() {});
              //           // toast("Data Berhasil di Update");

              //           Get.back();
              //           // maninvenmk_lbl_nama_inventarisC.clearControllers();
              //         } else {
              //           _formKey.currentState!.validate();
              //         }
              //       }
              //       // finish(context);
              //     },
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       height: 50,
              //       margin: EdgeInsets.all(10),
              //       decoration: boxDecoration(
              //           bgColor: inventarisC.isSaving.value
              //               ? mkColorPrimaryLight
              //               : mkColorPrimary,
              //           radius: 10),
              //       padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              //       child: Center(
              //         child: inventarisC.isSaving.value
              //             ? CircularProgressIndicator()
              //             : Text(mk_submit,
              //                 style: boldTextStyle(color: white, size: 18)),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
