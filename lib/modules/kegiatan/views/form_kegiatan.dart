// import 'dart:math';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

import 'package:image_picker/image_picker.dart';

class FormKegiatan extends StatelessWidget {
  final KegiatanModel model = Get.arguments ?? KegiatanModel();

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
              Get.currentRoute == RouteName.new_kegiatan
                  ? mk_add_kegiatan
                  : mk_edit_kegiatan,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, kegiatanC.deMasjid.nama ?? mk_add_masjid),
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
  KegiatanModel model = Get.arguments ?? KegiatanModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    kegiatanC.clear();
  }

  // DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    var result = await showDatePicker(
        // helpText: 'Pilih tanggal kegiatan',
        // cancelText: 'Batal',
        // confirmText: "Konfirmasi",
        // fieldLabelText: 'Tanggal Kegiatan',
        // fieldHintText: 'Bulan/Tanggal/Tahun',
        // errorFormatText: 'Masukkan tanggal yang valid',
        // errorInvalidText: 'Masukkan tanggal dalam rentang yang tersedia',

        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(colorScheme: mkColorScheme),
            child: child!,
          );
        },
        initialDate: kegiatanC.selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (result is DateTime) {
      kegiatanC.selectedDate = new DateTime(
        result.year,
        result.month,
        result.day,
        kegiatanC.selectedDate.hour,
        kegiatanC.selectedDate.minute,
      );
    }
    // if (picked != null && picked != selectedDate)
    //   setState(() {
    //     print(picked);
    //     selectedDate = picked;
    //   });
  }

  _selectTime(BuildContext context) async {
    var picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(kegiatanC.selectedDate),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(colorScheme: mkColorScheme),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );

          // return CustomTheme(
          //   child: MediaQuery(
          //     data:
          //         MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          //     child: child!,
          //   ),
          // );
        });

    if (picked is TimeOfDay)
      kegiatanC.selectedDate = new DateTime(
        kegiatanC.selectedDate.year,
        kegiatanC.selectedDate.month,
        kegiatanC.selectedDate.day,
        picked.hour,
        picked.minute,
      );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text(mk_lbl_kegiatan, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              isEnabled: !kegiatanC.isSaving.value,
              mController: kegiatanC.namaC,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_nama_kegiatan, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_nama_kegiatan,
              hint: mk_hint_nama_kegiatan,
              icon: Icon(Icons.volunteer_activism,
                  color: kegiatanC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
            EditText(
              isEnabled: !kegiatanC.isSaving.value,
              mController: kegiatanC.deskripsiC,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_deskripsi, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_deskripsi_kegiatan,
              hint: mk_lbl_deskripsi_kegiatan,
              icon: Icon(Icons.description,
                  color: kegiatanC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              maxLine: 3,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
      Step(
        title: Text("Waktu Kegiatan", style: primaryTextStyle()),
        content: Obx(
          () => Column(children: <Widget>[
            Card(
                elevation: 4,
                child: ListTile(
                  onTap: () {
                    _selectDate(context);
                  },
                  title: Text(
                    'Pilih tanggal acara',
                    style: primaryTextStyle(),
                  ),
                  subtitle: Text(
                    "${kegiatanC.selectedDate.toLocal()}".split(' ')[0],
                    style: secondaryTextStyle(),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.date_range,
                      color: mkColorPrimary,
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                )),
            SizedBox(height: 20),
            Card(
                elevation: 4,
                child: ListTile(
                  onTap: () {
                    _selectTime(context);
                  },
                  title: Text(
                    'Pilih waktu acara',
                    style: primaryTextStyle(),
                  ),
                  subtitle: Text(
                    timeFormatter(kegiatanC.selectedDate),
                    style: secondaryTextStyle(),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.schedule,
                      color: mkColorPrimary,
                    ),
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                )),
            SizedBox(height: 20),
          ]),
        ),
        isActive: currStep == 1,
        // state: StepState.complete
      ),
      Step(
          title: Text(mk_lbl_foto_kegiatan, style: primaryTextStyle()),
          isActive: currStep == 2,
          state: StepState.indexed,
          content: Column(children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 16),
              // decoration: boxDecoration(
              //     radius: 10.0, showShadow: true, color: mkColorPrimary),
              width: Get.width,
              height: Get.width / 1.7,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Obx(() => kegiatanC.xfoto.value.path.isNotEmpty
                    ? Image.file(File(kegiatanC.xfoto.value.path))
                    : isEdit && !model.photoUrl.isEmptyOrNull
                        ? CachedNetworkImage(
                            placeholder: placeholderWidgetFn() as Widget
                                Function(BuildContext, String)?,
                            imageUrl: model.photoUrl!,
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            mk_no_image,
                          )),
              ),
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
                        isSaving: kegiatanC.isSaving,
                        fromCamera: () async {
                          await kegiatanC.getImage(true);
                          Get.back();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        fromGaleri: () async {
                          await kegiatanC.getImage(false);
                          Get.back();
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
    return WillPopScope(
        onWillPop: () async {
          // return kegiatanC.checkControllers()
          //     ? await showDialog(
          //         context: context,
          //         builder: (BuildContext context) => ConfirmDialog())
          //     : Future.value(true);
          // toast("value");
          return Future.value(true);
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
                    Obx(
                      () => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.all(10),
                        decoration: boxDecoration(
                            bgColor: kegiatanC.isSaving.value
                                ? mkColorPrimaryLight
                                : mkColorPrimary,
                            radius: 10),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: InkWell(
                          onTap: () async {
                            if (kegiatanC.isSaving.value == false) {
                              if (_formKey.currentState!.validate()) {
                                await kegiatanC.saveKegiatan(model);
                              } else {
                                _formKey.currentState!.validate();
                              }
                            }
                            // finish(context);
                          },
                          child: Center(
                            child: kegiatanC.isSaving.value
                                ? CircularProgressIndicator()
                                : Text(mk_submit,
                                    style:
                                        boldTextStyle(color: white, size: 18)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )));
  }
}
