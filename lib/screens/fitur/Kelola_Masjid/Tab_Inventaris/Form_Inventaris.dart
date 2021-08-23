import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/helpers/validator.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:get/get.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main.dart';

class FormInventaris extends StatefulWidget {
  @override
  _FormInventarisState createState() => _FormInventarisState();
}

class _FormInventarisState extends State<FormInventaris> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isEdit = Get.currentRoute != RouteName.new_inventaris;
  var isSaving = false.obs;
  InventarisModel dataInventaris = Get.arguments;
  // GlobalKey<FormState> formKey = GlobalKey();

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
    // if (isEdit == true) {
    //   inventarisC.namaController.text = dataInventaris.nama ?? "";
    //   inventarisC.kondisiController.text = dataInventaris.kondisi ?? "";
    //   inventarisC.fotoController.text = dataInventaris.foto ?? "";
    //   inventarisC.urlController.text = dataInventaris.url ?? "";
    //   inventarisC.hargaController.text = dataInventaris.harga.toString();
    //   inventarisC.jumlahController.text = dataInventaris.jumlah.toString();
    // }
  }

  @override
  void dispose() {
    super.dispose();
    inventarisC.clearControllers();
    inventarisC.downloadUrl.value = "";
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<FormState> formKey = GlobalKey();
    List<Step> steps = [
      Step(
        title: Text("Data inventaris"),
        content: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              fontSize: textSizeLargeMedium,
              mController: inventarisC.namaController,
              hint: mk_hint_nama_inventaris,
              label: mk_lbl_nama_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_nama_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !isSaving.value,
              icon: Icon(Icons.dns,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
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
              isEnabled: !isSaving.value,
              icon: Icon(Icons.add_task,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              mController: inventarisC.hargaController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrrencyInputFormatter()
              ],
              keyboardType: TextInputType.number,
              hint: mk_hint_harga_inventaris,
              label: mk_lbl_harga_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_harga_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !isSaving.value,
              icon: Icon(Icons.money,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              mController: inventarisC.jumlahController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              keyboardType: TextInputType.number,
              hint: mk_hint_jumlah_inventaris,
              label: mk_lbl_jumlah_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_jumlah_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !isSaving.value,
              icon: Icon(Icons.play_for_work,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
        ]),
        isActive: currStep == 0,
      ),
      Step(
          title: Text("Foto"),
          content: Column(
            children: <Widget>[
              Obx(() => inventarisC.downloadUrl.value != ""
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
              // CircleAvatar(
              //   backgroundImage: AssetImage(mk_profile_pic),
              //   child: isEdit && !dataInventaris.url.isEmptyOrNull
              //       ? Container(
              //           decoration: BoxDecoration(
              //               color: mkColorAccent,
              //               borderRadius: BorderRadius.circular(100),
              //               image: DecorationImage(
              //                   image: CachedNetworkImageProvider(
              //                       dataInventaris.url ?? ""),
              //                   fit: BoxFit.cover)),
              //         )
              //       : null,
              //   foregroundImage: FileImage(File(takmirC.photoPath)),
              //   backgroundColor: mkColorPrimary,
              //   radius: 100,
              // ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(15.0),
              //   child: isEdit && !dataInventaris.url.isEmptyOrNull
              //       ? Container(
              //           height: 200,
              //           width: 200,
              //           decoration: BoxDecoration(
              //               color: mkColorAccent,
              //               borderRadius: BorderRadius.circular(10),
              //               image: DecorationImage(
              //                   image: AssetImage(mk_login),
              //                   // CachedNetworkImageProvider(
              //                   //     dataInventaris.url ?? ""),
              //                   fit: BoxFit.cover)),
              //         )
              //       : null,
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: EditText(
                  // focusNode: FocusNode(),
                  // enableInteractiveSelection: false,
                  // style: GoogleFonts.poppins(),
                  isReadOnly: true,
                  // enabled: !isSaving.value,
                  mController: inventarisC.fotoController,
                  // decoration: InputDecoration(hintText: inventarisC.message),
                  // validator: (s) {
                  //   if (s!.trim().isEmpty)
                  //     return '$mk_lbl_foto_inventaris $mk_is_required';
                  //   return null;
                  // },
                  hint: inventarisC.message,
                  // validator: (value) => (Validator(
                  //         attributeName: mk_lbl_foto_inventaris, value: value)
                  //       ..required())
                  //     .getError(),
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
                        return ImageSourceBottomSheet(
                            isLoading: inventarisC.isLoadingImage,
                            uploadPrecentage: inventarisC.uploadPrecentage,
                            isSaving: isSaving.value,
                            fromCamera: () {
                              inventarisC.getImage(true);
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            fromGaleri: () async {
                              await inventarisC.getImage(false);
                              if (inventarisC.photoLocal != null) {}
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            });
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
            // mk_add_inventaris,
            Get.currentRoute == RouteName.new_inventaris
                ? mk_add_inventaris
                : mk_edit_inventaris,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () async {
                  if (isSaving.value == false) {
                    if (formKey.currentState!.validate()) {
                      InventarisModel model = InventarisModel(
                        inventarisID:
                            isEdit ? dataInventaris.inventarisID : null,
                        nama: inventarisC.namaController.text,
                      );

                      if (currStep < steps.length - 1) {
                        currStep = currStep + 1;
                      } else {
                        isSaving.value = true;
                        setState(() {});
                        await inventarisC.addInventaris(
                            authController.firebaseUser.value.uid);

                        if (inventarisC.photoLocal != null) {
                          await inventarisC.uploadToStorage(
                              inventarisC.photoLocal, model);
                        }

                        isSaving.value = false;
                      }
                    } else {
                      formKey.currentState!.validate();
                    }
                  }
                },
                child: isSaving.value
                    ? Container(
                        padding: EdgeInsets.all(13),
                        width: 55.0,
                        child: CircularProgressIndicator())
                    : Icon(
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
        body: Theme(
          data: ThemeData(colorScheme: mkColorScheme),
          child: Form(
            key: formKey,
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
                                  // onPressed: () {
                                  //   if(formKey.currentState!.validate(),
                                  //   onStepContinue;
                                  // }
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
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          if (currStep < steps.length - 1) {
                            currStep = currStep + 1;
                          } else {
                            //currStep = 0;
                            finish(context);
                          }
                        });
                      }
                      // setState(() {
                      //   if (currStep < steps.length - 1) {
                      //     currStep = currStep + 1;
                      //   } else {
                      //     //currStep = 0;
                      //     finish(context);
                      //   }
                      // }
                      // );
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
                //       if (isSaving.value == false) {
                //         if (formKey.currentState!.validate()) {
                //           // formKey.currentState!.deactivate();
                //           // formKey.currentState!.save();
                //           setState(() {});
                //           await inventarisC.addInventaris(
                //               authController.firebaseUser.value.uid);
                //           // setState(() {});
                //           // toast("Data Berhasil di Update");

                //           Get.back();
                //           // maninvenmk_lbl_nama_inventarisC.clearControllers();
                //         } else {
                //           formKey.currentState!.validate();
                //         }
                //       }
                //       // finish(context);
                //     },
                //     child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       height: 50,
                //       margin: EdgeInsets.all(10),
                //       decoration: boxDecoration(
                //           bgColor: isSaving.value
                //               ? mkColorPrimaryLight
                //               : mkColorPrimary,
                //           radius: 10),
                //       padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                //       child: Center(
                //         child: isSaving.value
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
      ),
    );
  }
}
