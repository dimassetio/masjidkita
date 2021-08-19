// import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppConstant.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class FormProfile extends StatelessWidget {
  static const tag = '/FormProfile';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                manMasjidC.checkControllers()
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
              manMasjidC.deMasjid.nama ?? mk_add_masjid,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, manMasjidC.deMasjid.nama ?? mk_add_masjid),
          body: StepperBody()),
    );
  }
}

// class StepperBody extends StatelessWidget {
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
    if (Get.routing.current != RouteName.new_masjid) {
      manMasjidC.nama.text = manMasjidC.deMasjid.nama ?? "";
      manMasjidC.alamat.text = manMasjidC.deMasjid.alamat ?? "";
      manMasjidC.photoUrl.text = manMasjidC.deMasjid.photoUrl ?? "";
      manMasjidC.deskripsi.text = manMasjidC.deMasjid.deskripsi ?? "";
      manMasjidC.kecamatan.text = manMasjidC.deMasjid.kecamatan ?? "";
      manMasjidC.kodePos.text = manMasjidC.deMasjid.kodePos ?? "";
      manMasjidC.kota.text = manMasjidC.deMasjid.kota ?? "";
      manMasjidC.provinsi.text = manMasjidC.deMasjid.provinsi ?? "";
      manMasjidC.tahun.text = manMasjidC.deMasjid.tahun ?? "";
      manMasjidC.luasTanah.text = manMasjidC.deMasjid.luasTanah ?? "";
      manMasjidC.luasBangunan.text = manMasjidC.deMasjid.luasBangunan ?? "";
      print("PP ${Get.routing.current} ${RouteName.new_masjid}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    manMasjidC.clearControllers();
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
              mController: manMasjidC.nama,
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
              mController: manMasjidC.deskripsi,
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
              mController: manMasjidC.alamat,
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
              mController: manMasjidC.kecamatan,
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
              mController: manMasjidC.kodePos,
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
              mController: manMasjidC.kota,
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
              mController: manMasjidC.provinsi,
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
              mController: manMasjidC.tahun,
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
              mController: manMasjidC.luasTanah,
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
              mController: manMasjidC.luasBangunan,
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
              value: manMasjidC.deMasjid.statusTanah,
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
                      manMasjidC.statusTanah = newValue ?? "";
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
              value: manMasjidC.deMasjid.legalitas,
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
                      manMasjidC.legalitas = newValue ?? "";
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
            Obx(() => manMasjidC.deMasjid.photoUrl != "" &&
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
                          manMasjidC.uploadImage(true);
                        },
                        fromGaleri: () {
                          manMasjidC.uploadImage(false);
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
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          } else {
                            manMasjidC.updateDataMasjid();
                            manMasjidC.clearControllers();
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
                  () => GestureDetector(
                    onTap: () async {
                      if (manMasjidC.isSaving.value == false) {
                        if (_formKey.currentState!.validate()) {
                          // _formKey.currentState!.deactivate();
                          // _formKey.currentState!.save();
                          setState(() {});
                          await manMasjidC.updateDataMasjid();
                          // setState(() {});
                          // toast("Data Berhasil di Update");

                          // Get.back();
                          // manMasjidC.clearControllers();
                        } else {
                          _formKey.currentState!.validate();
                        }
                      }
                      // finish(context);
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
