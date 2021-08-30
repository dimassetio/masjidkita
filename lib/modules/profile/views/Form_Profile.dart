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
import 'package:mosq/modules/masjid/models/masjid_model.dart';

import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:image_picker/image_picker.dart';

class FormMasjid extends StatefulWidget {
  @override
  _FormMasjidState createState() => _FormMasjidState();
}

class _FormMasjidState extends State<FormMasjid> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;
  GlobalKey<FormState> formKey = GlobalKey();

  List<String> statusTanahList = ['Wakaf', mk_lbl_lainnya];
  List<String> legalitasList = [
    'Hak Milik',
    'Hak Guna Bangunan',
    mk_lbl_lainnya
  ];

  String? statusTanah;
  String? legalitas;

  var photo = XFile("").obs;
  var photoPath = "".obs;
  var photoUrl = "".obs;
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kodePos = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController provinsi = TextEditingController();
  TextEditingController tahun = TextEditingController();
  TextEditingController luasTanah = TextEditingController();
  TextEditingController luasBangunan = TextEditingController();
  MasjidModel model = Get.arguments ?? MasjidModel();

  @override
  void initState() {
    super.initState();
    if (model.id != null) {
      nama.text = model.nama ?? "";
      alamat.text = model.alamat ?? "";
      photoUrl.value = model.photoUrl ?? "";
      deskripsi.text = model.deskripsi ?? "";
      kecamatan.text = model.kecamatan ?? "";
      kodePos.text = model.kodePos ?? "";
      kota.text = model.kota ?? "";
      provinsi.text = model.provinsi ?? "";
      tahun.text = model.tahun ?? "";
      luasTanah.text = model.luasTanah ?? "";
      masjidC.downloadUrl.value = model.photoUrl ?? "";
      luasBangunan.text = model.luasBangunan ?? "";
      if (statusTanahList.contains(model.statusTanah)) {
        statusTanah = model.statusTanah;
      }
      if (legalitasList.contains(model.legalitas)) {
        legalitas = model.legalitas;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    masjidC.downloadUrl.value = "";
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text(mk_lbl_nama, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: nama,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama_masjid, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_nama_masjid,
              hint: mk_hint_nama_masjid,
              icon: Icon(Icons.home,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: deskripsi,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_deskripsi, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_deskripsi,
              hint: mk_hint_deskripsi,
              icon: Icon(Icons.home,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              maxLine: 3,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
      Step(
        title: Text(mk_lbl_alamat, style: primaryTextStyle()),
        isActive: currStep == 1,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: alamat,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_alamat, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_alamat,
              hint: mk_hint_alamat,
              keyboardType: TextInputType.streetAddress,
              icon: Icon(Icons.edit_location,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: kecamatan,
              validator: (value) =>
                  (Validator(attributeName: mk_kecamatan, value: value)
                        ..required())
                      .getError(),
              label: mk_kecamatan,
              hint: mk_hint_kecamatan,
              icon: Icon(Icons.edit_location,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: kodePos,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5)
              ],
              keyboardType: TextInputType.number,
              validator: (value) =>
                  (Validator(attributeName: mk_kode_pos, value: value)
                        ..required()
                        ..minLength(5))
                      .getError(),
              label: mk_kode_pos,
              hint: mk_hint_kode_pos,
              icon: Icon(Icons.edit_location,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: kota,
              validator: (value) =>
                  (Validator(attributeName: mk_kota, value: value)..required())
                      .getError(),
              label: mk_kota,
              hint: mk_hint_kota,
              icon: Icon(Icons.edit_location,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: provinsi,
              validator: (value) =>
                  (Validator(attributeName: mk_provinsi, value: value)
                        ..required())
                      .getError(),
              label: mk_provinsi,
              hint: mk_hint_provinsi,
              icon: Icon(Icons.edit_location,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ],
        ),
      ),
      Step(
        title: Text(mk_info_bangunan, style: primaryTextStyle()),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: tahun,
              validator: (value) =>
                  (Validator(attributeName: mk_tahun, value: value)
                        ..required()
                        ..minLength(4))
                      .getError(),
              label: mk_tahun,
              hint: mk_hint_tahun,
              icon: Icon(Icons.house,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: luasTanah,
              validator: (value) =>
                  (Validator(attributeName: mk_LT, value: value)..required())
                      .getError(),
              label: mk_LT,
              hint: mk_hint_LT,
              icon: Icon(Icons.house,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
                DecimalInputFormatter()
              ],
            ),
            EditText(
              isEnabled: !masjidC.isSaving.value,
              mController: luasBangunan,
              validator: (value) =>
                  (Validator(attributeName: mk_LB, value: value)..required())
                      .getError(),
              label: mk_LB,
              hint: mk_hint_LB,
              icon: Icon(Icons.house,
                  color: masjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
                DecimalInputFormatter()
              ],
            ),
            DropdownButtonFormField<String>(
              validator: (value) =>
                  value == null ? '$mk_status_tanah $mk_is_required' : null,
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              alignment: Alignment.centerLeft,
              value: statusTanah,
              decoration: InputDecoration(
                labelText: mk_status_tanah,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_status_tanah,
                icon: Icon(Icons.house,
                    color: masjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: masjidC.isSaving.value
                  ? null
                  : (String? newValue) {
                      // setState(() {
                      // toast(newValue);
                      statusTanah = newValue ?? "";
                      // });
                    },
              items: <String>['Wakaf', 'Lainnya']
                  .map<DropdownMenuItem<String>>((String value) {
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
            DropdownButtonFormField<String>(
              validator: (value) =>
                  value == null ? '$mk_legalitas $mk_is_required' : null,
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              alignment: Alignment.centerLeft,
              value: legalitas,
              decoration: InputDecoration(
                labelText: mk_legalitas,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_legalitas,
                icon: Icon(Icons.house,
                    color: masjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: masjidC.isSaving.value
                  ? null
                  : (String? newValue) {
                      // setState(() {
                      legalitas = newValue ?? "";
                      // });
                    },
              items: <String>['Hak Milik', 'Hak Guna Bangunan', 'Lainnya']
                  .map<DropdownMenuItem<String>>((String value) {
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
      Step(
          title: Text("Foto Masjid", style: primaryTextStyle()),
          isActive: currStep == 3,
          state: StepState.indexed,
          content: Column(children: [
            Container(
              width: Get.width,
              height: Get.width / 1.7,
              child: Obx(() => photo.value.path != ""
                  ? Image.file(File(photo.value.path))
                  : !model.photoUrl.isEmptyOrNull
                      ? CachedNetworkImage(
                          placeholder: placeholderWidgetFn() as Widget Function(
                              BuildContext, String)?,
                          imageUrl: model.photoUrl ?? "",
                          fit: BoxFit.fill,
                        )
                      : Image.asset(mk_contoh_image)),
            ),
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
                      return ImageSourceBottomSheet(
                        isLoading: masjidC.isLoadingImage,
                        uploadPrecentage: masjidC.uploadPrecentage,
                        isSaving: masjidC.isSaving.value,
                        fromCamera: () {
                          photo.value = masjidC.getImage(true);
                          Get.back();
                        },
                        fromGaleri: () async {
                          photo.value = masjidC.getImage(false);
                          Get.back();
                        },
                      );
                    });

                // masjidC.uploadImage(image!);
              },
            ),
          ]))
    ];

    return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   backgroundColor: appStore.appBarColor,
            //   leading: IconButton(
            //     onPressed: () {
            //       // masjidC.checkControllers()
            //       //     ? showDialog(
            //       //         context: Get.context!,
            //       //         builder: (BuildContext context) => ConfirmDialog(),
            //       //       )
            //       //     : finish(context);
            //     },
            //     icon: Icon(Icons.arrow_back,
            //         color: appStore.isDarkModeOn ? white : black),
            //   ),
            //   title: appBarTitleWidget(
            //     context,
            //     model.nama ?? mk_add_masjid,
            //   ),
            //   // actions: actions,
            // ),
            body: Container(
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
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => Stepper(
                      steps: steps,
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
                            // text("Saving = ${masjidC.isSaving}"),

                            currStep != 0
                                ? TextButton(
                                    onPressed: onStepCancel,
                                    child: Text(mk_sebelum,
                                        style: secondaryTextStyle()),
                                  )
                                : 10.width,
                            currStep < steps.length - 1
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
                        setState(() {
                          if (currStep < steps.length - 1) {
                            currStep = currStep + 1;
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
                  () => GestureDetector(
                    onTap: () async {
                      if (masjidC.isSaving.value == false) {
                        if (formKey.currentState!.validate()) {
                          model.alamat = alamat.text;
                          model.deskripsi = deskripsi.text;
                          model.kecamatan = kecamatan.text;
                          model.kodePos = kodePos.text;
                          model.kota = kota.text;
                          model.legalitas = legalitas;
                          model.luasBangunan = luasBangunan.text;
                          model.luasTanah = luasTanah.text;
                          model.nama = nama.text;
                          model.photoUrl = masjidC.downloadUrl.value;
                          model.provinsi = provinsi.text;
                          model.statusTanah = statusTanah;
                          model.tahun = tahun.text;
                          await masjidC.saveMasjid(model, null);
                          Get.back();
                        } else {
                          formKey.currentState!.validate();
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: boxDecoration(
                          bgColor: masjidC.isSaving.value
                              ? mkColorPrimaryLight
                              : mkColorPrimary,
                          radius: 10),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: masjidC.isSaving.value
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
    ))));
  }
}
