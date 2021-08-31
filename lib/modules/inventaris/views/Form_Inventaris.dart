import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/helpers/validator.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:get/get.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mosq/main.dart';

class FormInventaris extends StatefulWidget {
  final InventarisModel model = Get.arguments ?? InventarisModel();
  static const tag = '/FormInventaris';
  // const FormInventaris({Key? key, required this.model}) : super(key: key);
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
  // GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nama = TextEditingController();
  final TextEditingController jumlah = TextEditingController();
  final TextEditingController kondisi = TextEditingController();
  final TextEditingController foto = TextEditingController();
  final TextEditingController url = TextEditingController();
  InventarisModel model = Get.arguments ?? InventarisModel();
  var harga = TextEditingController();
  var xfoto = XFile("").obs;
  File? fotos;

  @override
  void initState() {
    super.initState();
    // if (model.inventarisID != null) {
    //   nama.text = model.nama ?? "";
    //   kondisi.text = model.kondisi ?? "";
    //   foto.text = model.foto ?? "";
    //   url.text = model.url ?? "";
    //   harga.text = model.harga.toString();
    //   jumlah.text = model.jumlah.toString();
    // }
    if (model.inventarisID != null) {
      nama.text = model.nama ?? "";
      kondisi.text = model.kondisi ?? "";
      foto.text = model.foto ?? "";
      url.text = model.url ?? "";
      harga.text = model.harga.toString();
      jumlah.text = model.jumlah.toString();
    }
    // if (isEdit == true) {}
  }

  checkControllers() {
    if (isEdit) {
      if (nama.text != model.nama ||
          jumlah.text != model.jumlah.toString() ||
          kondisi.text != model.kondisi ||
          // foto.text != inventaris.foto ||
          url.text != model.url ||
          harga.text != model.harga.toString()) {
        return true;
      } else
        return false;
    } else {
      if (nama.text != "" ||
          jumlah.text != "" ||
          kondisi.text != "" ||
          // foto.text != inventaris.foto ||
          // url.text != inventaris.url ||
          harga.text != "") {
        return true;
      } else
        return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    inventarisC.downloadUrl.value = "";
    inventarisC.photoPath = "";
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
              mController: nama,
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
              mController: kondisi,
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
              textAlign: TextAlign.end,
              mController: harga,
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
              textAlign: TextAlign.end,
              mController: jumlah,
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
              // Obx(() => inventarisC.downloadUrl.value != ""
              //     ? Container(
              //         alignment: Alignment.center,
              //         child: CachedNetworkImage(
              //           width: Get.width - 40,
              //           placeholder: placeholderWidgetFn() as Widget Function(
              //               BuildContext, String)?,
              //           imageUrl: inventarisC.downloadUrl.value.isEmpty
              //               ? inventarisC.inventaris.url.toString()
              //               : inventarisC.downloadUrl.value,
              //           fit: BoxFit.cover,
              //         ),
              //       )
              //     : text('Belum Ada Gambar', fontSize: textSizeSMedium)),
              // CircleAvatar(
              //   backgroundImage: AssetImage(mk_profile_pic),
              //   child: isEdit && !model.url.isEmptyOrNull
              //       ? Container(
              //           decoration: BoxDecoration(
              //               color: mkColorAccent,
              //               borderRadius: BorderRadius.circular(100),
              //               image: DecorationImage(
              //                   image: CachedNetworkImageProvider(
              //                       model.url ?? ""),
              //                   fit: BoxFit.cover)),
              //         )
              //       : null,
              //   foregroundImage: FileImage(File(takmirC.photoPath)),
              //   backgroundColor: mkColorPrimary,
              //   radius: 100,
              // ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 16),
                decoration: boxDecoration(
                    radius: 10.0, showShadow: true, color: mkColorPrimary),
                width: 300,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Obx(() => inventarisC.photoPath != ""
                      ? Image.file(File(inventarisC.photoPath))
                      : isEdit
                          ? inventarisC.inventaris.url != "" &&
                                  inventarisC.inventaris.url != null
                              ? CachedNetworkImage(
                                  placeholder: placeholderWidgetFn() as Widget
                                      Function(BuildContext, String)?,
                                  imageUrl: inventarisC.inventaris.url ?? "",
                                  fit: BoxFit.cover,
                                )
                              : text('Belum Ada Gambar',
                                  fontSize: textSizeSMedium)
                          : text('Belum Ada Gambar',
                              fontSize: textSizeSMedium)),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              //   child: EditText(
              //     // focusNode: FocusNode(),
              //     // enableInteractiveSelection: false,
              //     // style: GoogleFonts.poppins(),
              //     isReadOnly: true,
              //     // enabled: !isSaving.value,
              //     mController: foto,
              //     // decoration: InputDecoration(hintText: inventarisC.message),
              //     // validator: (s) {
              //     //   if (s!.trim().isEmpty)
              //     //     return '$mk_lbl_foto_inventaris $mk_is_required';
              //     //   return null;
              //     // },
              //     hint: inventarisC.message,
              //     // validator: (value) => (Validator(
              //     //         attributeName: mk_lbl_foto_inventaris, value: value)
              //     //       ..required())
              //     //     .getError(),
              //   ),
              // ),
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
                  controller: url,
                ),
              ),
              // Opacity(
              //   opacity: 0.0,
              //   child: TextField(
              //     focusNode: FocusNode(),
              //     enableInteractiveSelection: false,
              //     // style: GoogleFonts.poppins(),
              //     enabled: false,
              //     controller: inventarisC.foto,
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
              checkControllers()
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
            // Padding(
            //   padding: EdgeInsets.only(right: 20.0),
            //   child: InkWell(
            //     onTap: () async {
            //       if (isSaving.value == false) {
            //         if (formKey.currentState!.validate()) {
            //           int jumlah = jumlah.text.toInt();
            //           int harga = harga.text
            //               .replaceAll('Rp', '')
            //               .replaceAll('.', '')
            //               .toInt();
            //           InventarisModel model = InventarisModel(
            //               inventarisID: isEdit
            //                   ? inventarisC.inventaris.inventarisID
            //                   : null,
            //               nama: nama.text,
            //               kondisi: kondisi.text,
            //               foto: foto.text,
            //               url: url.text,
            //               harga: harga,
            //               jumlah: jumlah,
            //               hargaTotal: harga * jumlah);

            //           if (currStep < steps.length - 1) {
            //             currStep = currStep + 1;
            //           } else {
            //             isSaving.value = true;
            //             setState(() {});
            //             await inventarisC.addInventaris(
            //                 model, authController.firebaseUser.value.uid);

            //             if (inventarisC.photoLocal != null) {
            //               await inventarisC.uploadToStorage(
            //                   inventarisC.photoLocal, model);
            //             }

            //             isSaving.value = false;
            //           }
            //         } else {
            //           formKey.currentState!.validate();
            //         }
            //       }
            //     },
            //     child: isSaving.value
            //         ? Container(
            //             padding: EdgeInsets.all(13),
            //             width: 55.0,
            //             child: CircularProgressIndicator())
            //         : Icon(
            //             Icons.check,
            //             size: 26.0,
            //             color: mkColorPrimary,
            //           ),
            //   ),
            // )

            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () async {
                  if (isSaving.value == false) {
                    if (formKey.currentState!.validate()) {
                      isSaving.value = true;
                      int jumlahBarang = jumlah.text.toInt();
                      int hargaBarang = harga.text
                          .replaceAll('Rp', '')
                          .replaceAll('.', '')
                          .toInt();
                      // InventarisModel model = InventarisModel(
                      //     inventarisID: isEdit
                      //         ? inventarisC.inventaris.inventarisID
                      //         : null,
                      //     nama: nama.text,
                      //     kondisi: kondisi.text,
                      //     foto: foto.text,
                      //     url: url.text,
                      //     harga: hargaBarang,
                      //     jumlah: jumlahBarang,
                      //     hargaTotal: hargaBarang * jumlahBarang);

                      // inventarisID: isEdit
                      //     ? inventarisC.inventaris.inventarisID
                      //     : null,
                      model.nama = nama.text;
                      model.kondisi = kondisi.text;
                      model.foto = foto.text;
                      model.url = url.text;
                      model.harga = hargaBarang;
                      model.jumlah = jumlahBarang;
                      model.hargaTotal = hargaBarang * jumlahBarang;

                      if (xfoto.value.path.isNotEmpty) {
                        fotos = File(xfoto.value.path);
                      }

                      // await inventarisC.saveInventaris(model, fotos);
                      // isSaving.value = false;
                      // Get.back();

                      if (currStep < steps.length - 1) {
                        currStep = currStep + 1;
                      } else {
                        isSaving.value = true;
                        setState(() {});
                        // await inventarisC.addInventaris(
                        //     model, authController.firebaseUser.value.uid);

                        await inventarisC.saveInventaris(model, fotos);

                        Get.back();
                        // if (inventarisC.photoLocal != null) {
                        //   await inventarisC.uploadToStorage(
                        //       inventarisC.photoLocal, model);
                        // }

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
