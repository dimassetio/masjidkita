// import 'dart:math';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

import 'package:image_picker/image_picker.dart';

class FormKas extends StatelessWidget {
  var model = Get.arguments ?? null;
  static const tag = '/FormKas';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                // KasC.checkControllers(
                //         Get.currentRoute == RouteName.edit_Kas
                //             ? dataKas!
                //             : KasModel(
                //                 nama: "", jabatan: "", photoUrl: "", id: ""))
                //     ? showDialog(
                //         context: Get.context!,
                //         builder: (BuildContext context) => ConfirmDialog(),
                //       )
                //     :
                Get.back();
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(
              context,
              Get.currentRoute == RouteName.edit_kas ? mk_edit_kas : mk_add_kas,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, KasC.deMasjid.nama ?? mk_add_masjid),
          body: StepperBody()),
    );
  }
}

// class StepperBody extends StatelessWidget {
class StepperBody extends StatefulWidget {
  const StepperBody({Key? key}) : super(key: key);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;

  GlobalKey<FormState> _formKey = GlobalKey();

  bool isEdit = Get.currentRoute == RouteName.edit_kas;
  bool isKasRoute = Get.currentRoute == RouteName.new_kas;
  var isSaving = false.obs;

  final TextEditingController nama = TextEditingController();
  var saldoAwal = TextEditingController();

  final TextEditingController namaKategori = TextEditingController();
  final TextEditingController jenis = TextEditingController();
  XFile? pickedImage;
  var xfoto = XFile("").obs;
  File? foto;
  // String? photoUrl;
  KasModel model = Get.arguments ?? KasModel();
  final KategoriModel modelKategori = KategoriModel();
  // KategoriModel modelKategori = Get.arguments ?? KategoriModel();

  List<String> jenisList = [
    'Pengeluaran',
    'Pemasukan',
  ];
  String? jenisTransaksi;

  @override
  void initState() {
    super.initState();
    // if (isKasRoute) {
    //   if (model.id != null) {
    //     nama.text = model.nama ?? "";
    //     saldoAwal.text = Formatter().currencyFormatter.format(model.saldoAwal);
    //     // url.text = model.url ?? "";
    //     // jumlah.text = model.jumlah.toString();
    //   }
    // } else {
    //   if (modelKategori.id != null) {
    //     namaKategori.text = modelKategori.nama ?? "";
    //     jenis.text = modelKategori.jenis ?? "";
    //   }
    // }
    if (model.id != null) {
      nama.text = model.nama ?? "";
      saldoAwal.text = Formatter().currencyFormatter.format(model.saldoAwal);
      // url.text = model.url ?? "";
      // jumlah.text = model.jumlah.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    kasC.clearControllers();
    // KasC.downloadUrl.value = "";
    // showDialog(
    //     context: context, builder: (BuildContext context) => ConfirmDialog());
  }

  @override
  Widget build(BuildContext context) {
    List<Step> stepsKas = [
      Step(
        title: Text(mk_lbl_kas, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !isSaving.value,
              mController: nama,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama_kas, value: value)
                        ..required())
                      .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama,
              icon: Icon(Icons.person,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              textAlign: TextAlign.end,
              mController: saldoAwal,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrrencyInputFormatter()
              ],
              keyboardType: TextInputType.number,
              hint: mk_hint_saldo_awal_kas,
              label: mk_lbl_saldo_awal_kas,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_saldo_awal_kas, value: value)
                        ..required())
                      .getError(),
              isEnabled: !isSaving.value,
              icon: Icon(Icons.play_for_work,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ],
        ),
      ),
      // Step(
      //     title: Text(mk_lbl_foto_profil, style: primaryTextStyle()),
      //     isActive: currStep == 3,
      //     state: StepState.indexed,
      //     content: Column(children: [
      // Obx(
      //   () => CircleAvatar(
      //     backgroundImage: AssetImage(mk_profile_pic),
      //     child: isEdit && !model.photoUrl.isEmptyOrNull
      //         ? Container(
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(100),
      //                 image: DecorationImage(
      //                     image: CachedNetworkImageProvider(
      //                         model.photoUrl ?? ""),
      //                     fit: BoxFit.cover)),
      //           )
      //         : null,
      //     foregroundImage: FileImage(File(xfoto.value.path)),
      //     backgroundColor: mkColorPrimary,
      //     radius: 100,
      //   ),
      // ),
      // 16.height,

      // ElevatedButton(
      //   child: text("Upload Foto", textColor: mkWhite),
      //   onPressed: () {
      //     showModalBottomSheet(
      //         context: context,
      //         backgroundColor: appStore.scaffoldBackground,
      //         shape: RoundedRectangleBorder(
      //           borderRadius:
      //               BorderRadius.vertical(top: Radius.circular(25.0)),
      //         ),
      //         builder: (builder) {
      //           return ImageSourceBottomSheet(
      //             isLoading: kasC.isLoadingImage,
      //             uploadPrecentage: kasC.uploadPrecentage,
      //             isSaving: isSaving.value,
      //             fromCamera: () async {
      //               xfoto.value = await KasC.getImage(true);
      //               Get.back();
      //               FocusScopeNode currentFocus = FocusScope.of(context);
      //               if (!currentFocus.hasPrimaryFocus) {
      //                 currentFocus.unfocus();
      //               }
      //             },
      //             fromGaleri: () async {
      //               xfoto.value = await kasC.getImage(false);
      //               Get.back();
      //               FocusScopeNode currentFocus = FocusScope.of(context);
      //               if (!currentFocus.hasPrimaryFocus) {
      //                 currentFocus.unfocus();
      //               }
      //             },
      //           );
      //         });
      //   },
      // ),
      // ]))
    ];

    List<Step> stepsKategori = [
      Step(
        title: Text(mk_lbl_Kategori_transaksi, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !isSaving.value,
              mController: namaKategori,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_nama_Kategori_transaksi,
                      value: value)
                    ..required())
                  .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama_Kategori_transaksi,
              icon: Icon(Icons.person,
                  color: isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            DropdownButtonFormField<String>(
              validator: (value) => (Validator(
                      attributeName: mk_lbl_jenis_Kategori_transaksi,
                      value: value)
                    ..required())
                  .getError(),
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              alignment: Alignment.centerLeft,
              value: jenisTransaksi,
              decoration: InputDecoration(
                labelText: mk_lbl_jenis_Kategori_transaksi,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_jenis_Kategori_transaksi,
                icon: Icon(Icons.plagiarism,
                    color: isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: isSaving.value
                  ? null
                  : (String? newValue) {
                      setState(() {
                        jenisTransaksi = newValue ?? "";
                      });
                    },
              items: jenisList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Tooltip(
                      message: value,
                      child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          child: Text(value, style: primaryTextStyle()))),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      // Step(
      //     title: Text(mk_lbl_foto_profil, style: primaryTextStyle()),
      //     isActive: currStep == 3,
      //     state: StepState.indexed,
      //     content: Column(children: [
      // Obx(
      //   () => CircleAvatar(
      //     backgroundImage: AssetImage(mk_profile_pic),
      //     child: isEdit && !model.photoUrl.isEmptyOrNull
      //         ? Container(
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(100),
      //                 image: DecorationImage(
      //                     image: CachedNetworkImageProvider(
      //                         model.photoUrl ?? ""),
      //                     fit: BoxFit.cover)),
      //           )
      //         : null,
      //     foregroundImage: FileImage(File(xfoto.value.path)),
      //     backgroundColor: mkColorPrimary,
      //     radius: 100,
      //   ),
      // ),
      // 16.height,

      // ElevatedButton(
      //   child: text("Upload Foto", textColor: mkWhite),
      //   onPressed: () {
      //     showModalBottomSheet(
      //         context: context,
      //         backgroundColor: appStore.scaffoldBackground,
      //         shape: RoundedRectangleBorder(
      //           borderRadius:
      //               BorderRadius.vertical(top: Radius.circular(25.0)),
      //         ),
      //         builder: (builder) {
      //           return ImageSourceBottomSheet(
      //             isLoading: kasC.isLoadingImage,
      //             uploadPrecentage: kasC.uploadPrecentage,
      //             isSaving: isSaving.value,
      //             fromCamera: () async {
      //               xfoto.value = await KasC.getImage(true);
      //               Get.back();
      //               FocusScopeNode currentFocus = FocusScope.of(context);
      //               if (!currentFocus.hasPrimaryFocus) {
      //                 currentFocus.unfocus();
      //               }
      //             },
      //             fromGaleri: () async {
      //               xfoto.value = await kasC.getImage(false);
      //               Get.back();
      //               FocusScopeNode currentFocus = FocusScope.of(context);
      //               if (!currentFocus.hasPrimaryFocus) {
      //                 currentFocus.unfocus();
      //               }
      //             },
      //           );
      //         });
      //   },
      // ),
      // ]))
    ];

    return Container(
        child: GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Theme(
          data: ThemeData(colorScheme: mkColorScheme),
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => Stepper(
                      steps: isKasRoute ? stepsKas : stepsKategori,
                      type: StepperType.vertical,
                      currentStep: currStep,
                      physics: ScrollPhysics(),
                      controlsBuilder: (BuildContext context,
                          {VoidCallback? onStepContinue,
                          VoidCallback? onStepCancel}) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // text("Saving = ${isSaving}"),

                            currStep != 0
                                ? TextButton(
                                    onPressed: onStepCancel,
                                    child: Text(mk_sebelum,
                                        style: secondaryTextStyle()),
                                  )
                                : 10.width,
                            currStep < stepsKas.length - 1
                                ? TextButton(
                                    onPressed: onStepContinue,
                                    child: Text(mk_berikut,
                                        style: secondaryTextStyle()),
                                  )
                                : 10.width,
                          ],
                        );
                      },
                      onStepContinue: () {
                        isKasRoute
                            ? setState(() {
                                if (currStep < stepsKas.length - 1) {
                                  currStep = currStep + 1;
                                } else {
                                  // KasC.updateDataMasjid();
                                  kasC.clearControllers();
                                  // currStep = 0;

                                  finish(context);
                                }
                              })
                            : setState(() {
                                if (currStep < stepsKategori.length - 1) {
                                  currStep = currStep + 1;
                                } else {
                                  // KasC.updateDataMasjid();
                                  kasC.clearControllers();
                                  // currStep = 0;

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
                Obx(
                  () => Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.all(10),
                    decoration: boxDecoration(
                        bgColor: isSaving.value
                            ? mkColorPrimaryLight
                            : mkColorPrimary,
                        radius: 10),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: InkWell(
                      onTap: () async {
                        int saldoFinal = saldoAwal.text
                            .replaceAll('Rp', '')
                            .replaceAll('.', '')
                            .toInt();
                        if (isSaving.value == false) {
                          if (_formKey.currentState!.validate()) {
                            if (isKasRoute) {
                              isSaving.value = true;
                              model.nama = nama.text;
                              model.saldoAwal = saldoFinal;
                              model.saldo = saldoFinal;
                              // model.jabatan =
                              //     jabatan == "Lainnya" ? jabatanC.text : jabatan;
                              // if (xfoto.value.path.isNotEmpty) {
                              //   foto = File(xfoto.value.path);
                              // }
                              await kasC.saveKas(model);
                              isSaving.value = false;
                              Get.back();
                            } else {
                              isSaving.value = true;
                              model.nama = namaKategori.text;
                              // model. = jenis.text;
                              // model.jabatan =
                              //     jabatan == "Lainnya" ? jabatanC.text : jabatan;
                              // if (xfoto.value.path.isNotEmpty) {
                              //   foto = File(xfoto.value.path);
                              // }
                              await kasC.saveKategori(modelKategori);
                              isSaving.value = false;
                              Get.back();
                            }
                          } else {
                            _formKey.currentState!.validate();
                          }
                        }
                        // finish(context);
                      },
                      child: Center(
                        child: isSaving.value
                            ? CircularProgressIndicator()
                            : Text(mk_submit,
                                style: boldTextStyle(color: white, size: 18)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
