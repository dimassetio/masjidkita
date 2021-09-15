import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/MqFormFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class FormMasjid extends StatefulWidget {
  @override
  _FormMasjidState createState() => _FormMasjidState();
}

class _FormMasjidState extends State<FormMasjid> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;
  GlobalKey<FormState> formKey = GlobalKey();

  MasjidModel model = Get.arguments ?? MasjidModel();
  MqFormFoto formFoto = MqFormFoto();

  @override
  void initState() {
    super.initState();
    if (model.id != null) {
      profilC.nama.text = model.nama ?? "";
      profilC.alamat.text = model.alamat ?? "";
      profilC.deskripsi.text = model.deskripsi ?? "";
      profilC.kecamatan.text = model.kecamatan ?? "";
      profilC.kodePos.text = model.kodePos ?? "";
      profilC.kota.text = model.kota ?? "";
      profilC.provinsi.text = model.provinsi ?? "";
      profilC.tahun.text = model.tahun ?? "";
      profilC.luasTanah.text = model.luasTanah ?? "";
      profilC.luasBangunan.text = model.luasBangunan ?? "";
      if (profilC.statusTanahList.contains(model.statusTanah)) {
        profilC.statusTanah = model.statusTanah;
      }
      if (profilC.legalitasList.contains(model.legalitas)) {
        profilC.legalitas = model.legalitas;
      }
      formFoto.oldPath = model.photoUrl ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    profilC.clear();
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
              isEnabled: !profilC.isSaving.value,
              mController: profilC.nama,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama_masjid, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_nama_masjid,
              hint: mk_hint_nama_masjid,
              icon: Icon(Icons.home,
                  color: profilC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !profilC.isSaving.value,
              mController: profilC.deskripsi,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_deskripsi, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_deskripsi,
              hint: mk_hint_deskripsi,
              icon: Icon(Icons.home,
                  color: profilC.isSaving.value
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
              isEnabled: !profilC.isSaving.value,
              mController: profilC.alamat,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_alamat, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_alamat,
              hint: mk_hint_alamat,
              keyboardType: TextInputType.streetAddress,
              icon: Icon(Icons.edit_location,
                  color: profilC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !profilC.isSaving.value,
              mController: profilC.kecamatan,
              validator: (value) =>
                  (Validator(attributeName: mk_kecamatan, value: value)
                        ..required())
                      .getError(),
              label: mk_kecamatan,
              hint: mk_hint_kecamatan,
              icon: Icon(Icons.edit_location,
                  color: profilC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !profilC.isSaving.value,
              mController: profilC.kodePos,
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
                  color: profilC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !profilC.isSaving.value,
              mController: profilC.kota,
              validator: (value) =>
                  (Validator(attributeName: mk_kota, value: value)..required())
                      .getError(),
              label: mk_kota,
              hint: mk_hint_kota,
              icon: Icon(Icons.edit_location,
                  color: profilC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !profilC.isSaving.value,
              mController: profilC.provinsi,
              validator: (value) =>
                  (Validator(attributeName: mk_provinsi, value: value)
                        ..required())
                      .getError(),
              label: mk_provinsi,
              hint: mk_hint_provinsi,
              icon: Icon(Icons.edit_location,
                  color: profilC.isSaving.value
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
              isEnabled: !profilC.isSaving.value,
              mController: profilC.tahun,
              validator: (value) =>
                  (Validator(attributeName: mk_tahun, value: value)
                        ..required()
                        ..minLength(4))
                      .getError(),
              label: mk_tahun,
              hint: mk_hint_tahun,
              icon: Icon(Icons.house,
                  color: profilC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
            ),
            EditText(
              isEnabled: !profilC.isSaving.value,
              mController: profilC.luasTanah,
              validator: (value) =>
                  (Validator(attributeName: mk_LT, value: value)..required())
                      .getError(),
              label: mk_LT,
              hint: mk_hint_LT,
              icon: Icon(Icons.house,
                  color: profilC.isSaving.value
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
              isEnabled: !profilC.isSaving.value,
              mController: profilC.luasBangunan,
              validator: (value) =>
                  (Validator(attributeName: mk_LB, value: value)..required())
                      .getError(),
              label: mk_LB,
              hint: mk_hint_LB,
              icon: Icon(Icons.house,
                  color: profilC.isSaving.value
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
              value: profilC.statusTanah,
              decoration: InputDecoration(
                labelText: mk_status_tanah,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_status_tanah,
                icon: Icon(Icons.house,
                    color: profilC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: profilC.isSaving.value
                  ? null
                  : (String? newValue) {
                      // setState(() {
                      // toast(newValue);
                      profilC.statusTanah = newValue ?? "";
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
              value: profilC.legalitas,
              decoration: InputDecoration(
                labelText: mk_legalitas,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_legalitas,
                icon: Icon(Icons.house,
                    color: profilC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: profilC.isSaving.value
                  ? null
                  : (String? newValue) {
                      // setState(() {
                      profilC.legalitas = newValue ?? "";
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
          content: Column(children: [16.height, formFoto]))
    ];

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: appStore.appBarColor,
              leading: BackButton(),
              title: appBarTitleWidget(
                context,
                model.nama ?? mk_add_masjid,
              ),
              // actions: actions,
            ),
            body: WillPopScope(
              onWillPop: () async {
                // return Future.value(true);
                return profilC.checkControllers(model, formFoto.newPath)
                    ? await showDialog(
                        context: context,
                        builder: (BuildContext context) => ConfirmDialog())
                    : Future.value(true);
              },
              child: Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // text("Saving = ${profilC.isSaving}"),

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
                            () => Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              margin: EdgeInsets.all(10),
                              decoration: boxDecoration(
                                  bgColor: profilC.isSaving.value
                                      ? mkColorPrimaryLight
                                      : mkColorPrimary,
                                  radius: 10),
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: InkWell(
                                onTap: () async {
                                  if (profilC.isSaving.value == false) {
                                    if (formKey.currentState!.validate()) {
                                      await profilC.saveMasjid(model,
                                          path: formFoto.newPath);
                                      Get.back();
                                    } else {
                                      formKey.currentState!.validate();
                                    }
                                  }
                                },
                                child: Center(
                                  child: profilC.isSaving.value
                                      ? CircularProgressIndicator()
                                      : Text(mk_submit,
                                          style: boldTextStyle(
                                              color: white, size: 18)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              )),
            )));
  }
}
