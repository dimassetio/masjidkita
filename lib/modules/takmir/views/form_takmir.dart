// import 'dart:math';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/widgets/ButtonForm.dart';
import 'package:mosq/screens/widgets/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/MqFormFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

import 'package:image_picker/image_picker.dart';

class FormTakmir extends StatelessWidget {
  final TakmirModel model = Get.arguments ?? TakmirModel();
  static const tag = '/FormTakmir';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: BackButton(),
            title: appBarTitleWidget(
              context,
              Get.currentRoute == RouteName.edit_takmir
                  ? mk_edit_takmir
                  : mk_add_takmir,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, takmirC.deMasjid.nama ?? mk_add_masjid),
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

  bool isEdit = Get.currentRoute == RouteName.edit_takmir;
  TakmirModel model = Get.arguments ?? TakmirModel();
  MqFormFoto formFoto = MqFormFoto(
    defaultPath: mk_profile_svg,
  );
  @override
  void initState() {
    super.initState();
    takmirC.namaC = TextEditingController();
    takmirC.jabatanC = TextEditingController();
    takmirC.jabatan = null;

    if (!model.id.isEmptyOrNull) {
      takmirC.namaC.text = model.nama ?? "";
      if (takmirC.jabatanList.contains(model.jabatan)) {
        takmirC.jabatan = model.jabatan ?? "";
      } else {
        takmirC.jabatanC.text = model.jabatan ?? "";
        takmirC.jabatan = "Lainnya";
      }
    }
    takmirC.jabatan == 'Lainnya' ? takmirC.isOtherJabatan.value = true : null;
    formFoto.oldPath = model.photoUrl ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    takmirC.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text(mk_lbl_profil, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !takmirC.isSaving.value,
              mController: takmirC.namaC,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama, value: value)
                        ..required())
                      .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama,
              icon: Icon(Icons.person,
                  color: takmirC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            DropdownButtonFormField<String>(
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_jabatan, value: value)
                        ..required())
                      .getError(),
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              alignment: Alignment.centerLeft,
              value: takmirC.jabatan,
              decoration: InputDecoration(
                labelText: mk_lbl_jabatan,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_jabatan,
                icon: Icon(Icons.person,
                    color: takmirC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: takmirC.isSaving.value
                  ? null
                  : (String? newValue) {
                      setState(() {
                        takmirC.jabatan = newValue ?? "";
                        takmirC.jabatan == 'Lainnya'
                            ? takmirC.isOtherJabatan.value = true
                            : takmirC.isOtherJabatan.value = false;
                        takmirC.jabatanC.text = "";
                      });
                    },
              items: takmirC.jabatanList
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
            takmirC.isOtherJabatan.value
                ? EditText(
                    isEnabled: !takmirC.isSaving.value,
                    mController: takmirC.jabatanC,
                    validator: (value) =>
                        (Validator(attributeName: mk_lbl_jabatan, value: value)
                              ..required())
                            .getError(),
                    label: "$mk_lbl_jabatan $mk_lbl_lainnya",
                    icon: Icon(Icons.person,
                        color: takmirC.isSaving.value
                            ? mkColorPrimaryLight
                            : mkColorPrimaryDark),
                  )
                : SizedBox(),
          ],
        ),
      ),
      Step(
          title: Text(mk_lbl_foto_profil, style: primaryTextStyle()),
          isActive: currStep == 1,
          state: StepState.indexed,
          content: Column(children: [
            16.height,
            formFoto,
          ]))
    ];

    return WillPopScope(
        onWillPop: () async {
          return takmirC.checkControllers(model, formFoto.newPath)
              ? await showDialog(
                  context: context,
                  builder: (BuildContext context) => ConfirmDialog())
              : Future.value(true);
          // toast("value");
          // return Future.value(true);
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
                key: _formKey,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                // text("Saving = ${takmirC.isSaving}"),

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
                    ButtonForm(
                      tapFunction: () async {
                        // takmirC.isSaving.value = true;
                        if (takmirC.isSaving.value == false) {
                          if (_formKey.currentState!.validate()) {
                            await takmirC.saveTakmir(model,
                                path: formFoto.newPath);
                          } else {
                            _formKey.currentState!.validate();
                          }
                        }
                      },
                      isSaving: takmirC.isSaving,
                    ),
                  ],
                ),
              )),
        )));
  }
}
