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
import 'package:mosq/modules/kas/kategori/models/kategori_model.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/widgets/ButtonForm.dart';
import 'package:mosq/screens/widgets/ImageSourceBottomSheet.dart';
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

  var model = Get.arguments;
  KasModel? modelKas;

  @override
  void initState() {
    super.initState();
    if (model is KasModel) {
      modelKas = model;
      kasC.nama = TextEditingController();
      kasC.saldoAwal = TextEditingController();
      kasC.saldo = TextEditingController();
      kasC.deskripsi = TextEditingController();
      if (modelKas!.id != null) {
        kasC.nama.text = model.nama ?? "";
        kasC.deskripsi.text = model.deskripsi ?? "";
        kasC.saldoAwal.text = currencyFormatter(model.saldoAwal);
        if (kasC.saldo.text.isEmptyOrNull) {
          kasC.saldo.text = kasC.saldoAwal.text;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    kasC.clear();
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
              isEnabled: !kasC.isSaving.value,
              mController: kasC.nama,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama_kas, value: value)
                        ..required())
                      .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama,
              icon: Icon(Icons.nature,
                  color: kasC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !kasC.isSaving.value,
              mController: kasC.deskripsi,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_deskripsi, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_deskripsi_kegiatan,
              hint: mk_lbl_deskripsi_kegiatan,
              icon: Icon(Icons.departure_board,
                  color: kasC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              maxLine: 3,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
      Step(
        title: Text(mk_lbl_saldo_kas, style: primaryTextStyle()),
        isActive: currStep == 1,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              textAlign: TextAlign.end,
              mController: kasC.saldoAwal,
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
              isEnabled: !kasC.isSaving.value,
              icon: Icon(Icons.play_for_work,
                  color: kasC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ],
        ),
      ),
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
                      steps: stepsKas,
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
                        setState(() {
                          if (currStep < stepsKas.length - 1) {
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
                      if (kasC.isSaving.value == false) {
                        if (_formKey.currentState!.validate()) {
                          kasC.saveKas(modelKas!);
                        } else {
                          _formKey.currentState!.validate();
                        }
                      }
                    },
                    isSaving: kasC.isSaving)
              ],
            ),
          )),
    ));
  }
}