import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/kas/kategori/models/kategori_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/ButtonForm.dart';
import 'package:mosq/screens/widgets/MqFormFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class FormKategori extends StatelessWidget {
  final KategoriModel model = Get.arguments ?? KategoriModel();
  static const tag = '/FormKategori';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(
                context,
                Get.currentRoute == RouteName.edit_kategori
                    ? mk_edit_kategori
                    : mk_add_kategori),
            // actions: actions,
          ),
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

  bool isEdit = Get.currentRoute == RouteName.edit_kategori;

  GlobalKey<FormState> _formKey = GlobalKey();

  KategoriModel model = Get.arguments ?? KategoriModel();

  @override
  void initState() {
    super.initState();

    if (!model.id.isEmptyOrNull) {
      kategoriC.namaC.text = model.nama ?? "";
      kategoriC.jenis = model.jenis;
    }
  }

  @override
  void dispose() {
    super.dispose();
    kategoriC.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text(mk_lbl_kategori, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            DropdownButtonFormField<int>(
              validator: (value) => (Validator(
                      attributeName: mk_lbl_jenis_Kategori_transaksi,
                      value: jenisTransaksiToStr(value))
                    ..required())
                  .getError(),
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              alignment: Alignment.centerLeft,
              value: kategoriC.jenis,
              decoration: InputDecoration(
                labelText: mk_lbl_jenis_Kategori_transaksi,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_jenis_Kategori_transaksi,
                icon: Icon(Icons.plagiarism,
                    color: kategoriC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: kategoriC.isSaving.value
                  ? null
                  : kategoriC.jenis != null
                      ? null
                      : (int? newValue) {
                          setState(() {
                            kategoriC.jenis = newValue;
                          });
                        },
              items:
                  kategoriC.jenisList.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Tooltip(
                      message: jenisTransaksiToStr(value),
                      child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          child: Text(jenisTransaksiToStr(value),
                              style: primaryTextStyle()))),
                );
              }).toList(),
            ),
            EditText(
              isEnabled: !kategoriC.isSaving.value,
              mController: kategoriC.namaC,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_kategori, value: value)
                        ..required())
                      .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama_kategori,
              icon: Icon(Icons.nature,
                  color: kategoriC.isSaving.value
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
                            // text("Saving = ${isSaving}"),

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
                      if (kategoriC.isSaving.value == false) {
                        if (_formKey.currentState!.validate()) {
                          await kategoriC.saveKategori(model);
                        } else {
                          _formKey.currentState!.validate();
                        }
                      }
                    },
                    isSaving: kategoriC.isSaving)
              ],
            ),
          )),
    ));
  }
}
