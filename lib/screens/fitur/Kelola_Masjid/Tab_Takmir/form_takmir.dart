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
import 'package:mosq/main/utils/AppConstant.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/models/takmir.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class FormTakmir extends StatelessWidget {
  final TakmirModel? dataTakmir = Get.arguments;
  static const tag = '/FormTakmir';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                // takmirC.checkControllers(
                //         Get.currentRoute == RouteName.edit_takmir
                //             ? dataTakmir!
                //             : TakmirModel(
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
  List<String> jabatanList = ['Ketua', 'Sekretaris', 'Bendahara', 'Lainnya'];
  String? jabatan;
  bool isEdit = Get.currentRoute == RouteName.edit_takmir ? true : false;

  TakmirModel dataTakmir = Get.arguments;
  // =
  //  TakmirModel(id: "", jabatan: "", nama: "", photoUrl: "");
  @override
  void initState() {
    super.initState();
    if (isEdit == true) {
      takmirC.namaC.text = dataTakmir.nama ?? "";
      takmirC.jabatanC.text = dataTakmir.jabatan ?? "";
      takmirC.jabatan = dataTakmir.jabatan ?? "";
      takmirC.photoUrlC = dataTakmir.photoUrl ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    takmirC.clearControllers();
    // takmirC.downloadUrl.value = "";
    // showDialog(
    //     context: context, builder: (BuildContext context) => ConfirmDialog());
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
              value: jabatanList.contains(takmirC.jabatanC.text)
                  ? takmirC.jabatanC.text
                  : jabatan,
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
                        takmirC.jabatanC.text = newValue ?? "";
                      });
                    },
              items: jabatanList.map<DropdownMenuItem<String>>((String value) {
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
            jabatanList.contains(takmirC.jabatanC.text) == false ||
                    takmirC.jabatanC.text == 'Lainnya'
                ? EditText(
                    isEnabled: !takmirC.isSaving.value,
                    mController: takmirC.jabatanC,
                    validator: (value) =>
                        (Validator(attributeName: mk_lbl_jabatan, value: value)
                              ..required())
                            .getError(),
                    label: mk_lbl_jabatan + ' lainnya',
                    icon: Icon(Icons.person,
                        color: takmirC.isSaving.value
                            ? mkColorPrimaryLight
                            : mkColorPrimaryDark),
                  )
                : SizedBox()
          ],
        ),
      ),
      Step(
          title: Text(mk_lbl_foto_profil, style: primaryTextStyle()),
          isActive: currStep == 3,
          state: StepState.indexed,
          content: Column(children: [
            Container(
              height: 200,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Obx(() => takmirC.photoPath.isNotEmpty
                        ? Image.file(
                            File(takmirC.photoPath),
                            fit: BoxFit.cover,
                          )
                        : takmirC.photoUrlC.isEmptyOrNull
                            ? Container(
                                color: mkTextColorGrey.withOpacity(0.3),
                                child: Icon(
                                  Icons.person,
                                  size: 200,
                                  color: mkTextColorGrey,
                                ),
                              )
                            : SizedBox()
                    // CachedNetworkImage(
                    //   placeholder: placeholderWidgetFn() as Widget
                    //       Function(BuildContext, String)?,
                    //   imageUrl: dataTakmir.photoUrl ?? "",
                    //   fit: BoxFit.cover,
                    // )
                    ),
              ),
            ),
            // Obx(() => takmirC.uploadPrecentage.value > 0.0
            //     ? LinearProgressIndicator(
            //         value: takmirC.uploadPrecentage.value,
            //       )
            //     : SizedBox()),
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
                        isLoading: takmirC.isLoadingImage.value,
                        uploadPrecentage: takmirC.uploadPrecentage.value,
                        isSaving: takmirC.isSaving.value,
                        fromCamera: () {
                          takmirC.getImage(true);
                        },
                        fromGaleri: () {
                          takmirC.getImage(false);
                        },
                      );
                    });
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
                            // takmirC.updateDataMasjid();
                            takmirC.clearControllers();
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
                      if (takmirC.isSaving.value == false) {
                        if (_formKey.currentState!.validate()) {
                          // _formKey.currentState!.deactivate();
                          // _formKey.currentState!.save();
                          takmirC.isSaving.value = true;
                          setState(() {});
                          TakmirModel model = TakmirModel(
                              id: isEdit ? dataTakmir.id : null,
                              jabatan: takmirC.jabatanC.text,
                              nama: takmirC.namaC.text,
                              photoUrl: takmirC.photoPath);
                          isEdit
                              ? await takmirC.updateTakmir(
                                  model, manMasjidC.deMasjid.id!)
                              : model.id = await takmirC.store(
                                  model, manMasjidC.deMasjid.id!);

                          // if (takmirC.photoLocal != null) {
                          //   await takmirC.uploadImage(
                          //       takmirC.photoLocal, model.id ?? 'Error');
                          // }
                          takmirC.isSaving.value = false;
                          // Get.back();
                          // setState(() {});
                          // toast("Data Berhasil di Update");

                          // takmirC.clearControllers();
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
                          bgColor: takmirC.isSaving.value
                              ? mkColorPrimaryLight
                              : mkColorPrimary,
                          radius: 10),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: takmirC.isSaving.value
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
