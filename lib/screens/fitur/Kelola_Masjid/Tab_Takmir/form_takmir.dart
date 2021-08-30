// import 'dart:math';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/models/takmir.dart';
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

class FormTakmir extends StatelessWidget {
  final TakmirModel dataTakmir = Get.arguments;
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

  List<String> jabatanList = [
    'Ketua',
    'Sekretaris',
    'Bendahara',
    mk_lbl_lainnya
  ];
  String? jabatan;
  var isOtherJabatan = false.obs;

  bool isEdit = Get.currentRoute == RouteName.edit_takmir;
  var isSaving = false.obs;

  final TextEditingController namaC = TextEditingController();
  final TextEditingController jabatanC = TextEditingController();
  XFile? pickedImage;

  TakmirModel dataTakmir = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (isEdit == true) {
      namaC.text = dataTakmir.nama ?? "";
      if (jabatanList.contains(dataTakmir.jabatan)) {
        jabatan = dataTakmir.jabatan ?? "";
      } else {
        jabatanC.text = dataTakmir.jabatan ?? "";
        jabatan = "Lainnya";
      }
      takmirC.photoUrlC = dataTakmir.photoUrl ?? "";
    }
    jabatan == 'Lainnya' ? isOtherJabatan.value = true : false;
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
              isEnabled: !isSaving.value,
              mController: namaC,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama, value: value)
                        ..required())
                      .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama,
              icon: Icon(Icons.person,
                  color: isSaving.value
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
              value: jabatan,
              decoration: InputDecoration(
                labelText: mk_lbl_jabatan,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_jabatan,
                icon: Icon(Icons.person,
                    color: isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: isSaving.value
                  ? null
                  : (String? newValue) {
                      setState(() {
                        jabatan = newValue ?? "";
                        jabatan == 'Lainnya'
                            ? isOtherJabatan.value = true
                            : isOtherJabatan.value = false;
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
            isOtherJabatan.value
                ? EditText(
                    isEnabled: !isSaving.value,
                    mController: jabatanC,
                    validator: (value) =>
                        (Validator(attributeName: mk_lbl_jabatan, value: value)
                              ..required())
                            .getError(),
                    label: "$mk_lbl_jabatan $mk_lbl_lainnya",
                    icon: Icon(Icons.person,
                        color: isSaving.value
                            ? mkColorPrimaryLight
                            : mkColorPrimaryDark),
                  )
                : SizedBox(),
          ],
        ),
      ),
      Step(
          title: Text(mk_lbl_foto_profil, style: primaryTextStyle()),
          isActive: currStep == 3,
          state: StepState.indexed,
          content: Column(children: [
            CircleAvatar(
              backgroundImage: AssetImage(mk_profile_pic),
              child: isEdit && !dataTakmir.photoUrl.isEmptyOrNull
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  dataTakmir.photoUrl ?? ""),
                              fit: BoxFit.cover)),
                    )
                  : null,
              foregroundImage: FileImage(File(takmirC.photoPath)),
              backgroundColor: mkColorPrimary,
              radius: 100,
            ),
            16.height,
            // FormField(
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   validator: (String? value) =>
            //       (Validator(attributeName: mk_lbl_foto_profil, value: value)
            //             ..required())
            //           .getError(),
            //   builder: (FormFieldState imageForm) =>
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
                        isLoading: takmirC.isLoadingImage,
                        uploadPrecentage: takmirC.uploadPrecentage,
                        isSaving: isSaving.value,
                        fromCamera: () {
                          takmirC.getImage(true);
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        fromGaleri: () async {
                          await takmirC.getImage(false);
                          if (takmirC.photoLocal != null) {}
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                      );
                    });
              },
            ),
            // ),
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
                        if (isSaving.value == false) {
                          if (_formKey.currentState!.validate()) {
                            isSaving.value = true;
                            TakmirModel model = TakmirModel(
                                id: isEdit ? dataTakmir.id : null,
                                jabatan: jabatan == 'Lainnya'
                                    ? jabatanC.text
                                    : jabatan,
                                nama: namaC.text,
                                photoUrl: dataTakmir.photoUrl);

                            if (takmirC.photoLocal != null) {
                              await takmirC.uploadImage(
                                  takmirC.photoLocal, model);
                            }
                            isSaving.value = false;
                            Get.back();
                            // setState(() {});
                            // toast("Data Berhasil di Update");

                            // takmirC.clearControllers();
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
