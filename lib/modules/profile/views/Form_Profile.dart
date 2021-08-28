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
import 'package:mosq/modules/profile/models/masjid_model.dart';

import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class FormMasjid extends StatefulWidget {
  const FormMasjid({MasjidModel? model});
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
  ];
  MasjidModel? model;

  String? statusTanah;
  String? legalitas;
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController photoUrl = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kodePos = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController provinsi = TextEditingController();
  TextEditingController tahun = TextEditingController();
  TextEditingController luasTanah = TextEditingController();
  TextEditingController luasBangunan = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = widget.model;
    if (Get.routing.current != RouteName.new_masjid) {
      nama.text = manMasjidC.deMasjid.nama ?? "";
      alamat.text = manMasjidC.deMasjid.alamat ?? "";
      photoUrl.text = manMasjidC.deMasjid.photoUrl ?? "";
      deskripsi.text = manMasjidC.deMasjid.deskripsi ?? "";
      kecamatan.text = manMasjidC.deMasjid.kecamatan ?? "";
      kodePos.text = manMasjidC.deMasjid.kodePos ?? "";
      kota.text = manMasjidC.deMasjid.kota ?? "";
      provinsi.text = manMasjidC.deMasjid.provinsi ?? "";
      tahun.text = manMasjidC.deMasjid.tahun ?? "";
      luasTanah.text = manMasjidC.deMasjid.luasTanah ?? "";
      manMasjidC.downloadUrl.value = manMasjidC.deMasjid.photoUrl ?? "";
      luasBangunan.text = manMasjidC.deMasjid.luasBangunan ?? "";
      if (statusTanahList.contains(manMasjidC.deMasjid.statusTanah)) {
        statusTanah = manMasjidC.deMasjid.statusTanah;
      }
      if (legalitasList.contains(manMasjidC.deMasjid.legalitas)) {
        legalitas = manMasjidC.deMasjid.legalitas;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    manMasjidC.downloadUrl.value = "";
    // showDialog(
    //     context: context, builder: (BuildContext context) => ConfirmDialog());
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
              isEnabled: !manMasjidC.isSaving.value,
              mController: nama,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama_masjid, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_nama_masjid,
              hint: mk_hint_nama_masjid,
              icon: Icon(Icons.home,
                  color: manMasjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !manMasjidC.isSaving.value,
              mController: deskripsi,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_deskripsi, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_deskripsi,
              hint: mk_hint_deskripsi,
              icon: Icon(Icons.home,
                  color: manMasjidC.isSaving.value
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
              isEnabled: !manMasjidC.isSaving.value,
              mController: alamat,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_alamat, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_alamat,
              hint: mk_hint_alamat,
              keyboardType: TextInputType.streetAddress,
              icon: Icon(Icons.edit_location,
                  color: manMasjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !manMasjidC.isSaving.value,
              mController: kecamatan,
              validator: (value) =>
                  (Validator(attributeName: mk_kecamatan, value: value)
                        ..required())
                      .getError(),
              label: mk_kecamatan,
              hint: mk_hint_kecamatan,
              icon: Icon(Icons.edit_location,
                  color: manMasjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !manMasjidC.isSaving.value,
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
                  color: manMasjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !manMasjidC.isSaving.value,
              mController: kota,
              validator: (value) =>
                  (Validator(attributeName: mk_kota, value: value)..required())
                      .getError(),
              label: mk_kota,
              hint: mk_hint_kota,
              icon: Icon(Icons.edit_location,
                  color: manMasjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !manMasjidC.isSaving.value,
              mController: provinsi,
              validator: (value) =>
                  (Validator(attributeName: mk_provinsi, value: value)
                        ..required())
                      .getError(),
              label: mk_provinsi,
              hint: mk_hint_provinsi,
              icon: Icon(Icons.edit_location,
                  color: manMasjidC.isSaving.value
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
              isEnabled: !manMasjidC.isSaving.value,
              mController: tahun,
              validator: (value) =>
                  (Validator(attributeName: mk_tahun, value: value)
                        ..required()
                        ..minLength(4))
                      .getError(),
              label: mk_tahun,
              hint: mk_hint_tahun,
              icon: Icon(Icons.house,
                  color: manMasjidC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
            ),
            EditText(
              isEnabled: !manMasjidC.isSaving.value,
              mController: luasTanah,
              validator: (value) =>
                  (Validator(attributeName: mk_LT, value: value)..required())
                      .getError(),
              label: mk_LT,
              hint: mk_hint_LT,
              icon: Icon(Icons.house,
                  color: manMasjidC.isSaving.value
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
              isEnabled: !manMasjidC.isSaving.value,
              mController: luasBangunan,
              validator: (value) =>
                  (Validator(attributeName: mk_LB, value: value)..required())
                      .getError(),
              label: mk_LB,
              hint: mk_hint_LB,
              icon: Icon(Icons.house,
                  color: manMasjidC.isSaving.value
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
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: manMasjidC.isSaving.value
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
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: manMasjidC.isSaving.value
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
            Obx(() => manMasjidC.photoPath.value != ""
                ? Image.file(File(manMasjidC.photoPath.value))
                : manMasjidC.deMasjid.photoUrl != "" &&
                        manMasjidC.deMasjid.photoUrl != null
                    ? CachedNetworkImage(
                        placeholder: placeholderWidgetFn() as Widget Function(
                            BuildContext, String)?,
                        imageUrl: manMasjidC.deMasjid.photoUrl ?? "",
                        fit: BoxFit.fill,
                      )
                    : text('Belum Ada Gambar', fontSize: textSizeSMedium)),
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
                        isLoading: manMasjidC.isLoadingImage,
                        uploadPrecentage: manMasjidC.uploadPrecentage,
                        isSaving: manMasjidC.isSaving.value,
                        fromCamera: () {
                          manMasjidC.getImage(true);
                          Get.back();
                        },
                        fromGaleri: () {
                          manMasjidC.getImage(false);
                          Get.back();
                        },
                      );
                    });

                // manMasjidC.uploadImage(image!);
              },
            ),
          ]))
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
                            // text("Saving = ${manMasjidC.isSaving}"),

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
                      if (manMasjidC.isSaving.value == false) {
                        if (formKey.currentState!.validate()) {
                          var model = MasjidModel(
                            id: Get.routing.current != RouteName.new_masjid
                                ? manMasjidC.deMasjid.id
                                : null,
                            alamat: alamat.text,
                            deskripsi: deskripsi.text,
                            kecamatan: kecamatan.text,
                            kodePos: kodePos.text,
                            kota: kota.text,
                            legalitas: legalitas,
                            luasBangunan: luasBangunan.text,
                            luasTanah: luasTanah.text,
                            nama: nama.text,
                            photoUrl: manMasjidC.downloadUrl.value,
                            provinsi: provinsi.text,
                            statusTanah: statusTanah,
                            tahun: tahun.text,
                          );
                          await manMasjidC.saveMasjid(model, null);
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
                          bgColor: manMasjidC.isSaving.value
                              ? mkColorPrimaryLight
                              : mkColorPrimary,
                          radius: 10),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: manMasjidC.isSaving.value
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
