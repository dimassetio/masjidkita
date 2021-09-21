// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/ButtonForm.dart';
import 'package:mosq/screens/widgets/MqFormFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

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

  MqFormFoto formFoto = MqFormFoto();

  @override
  void initState() {
    super.initState();
    if (!model.id.isEmptyOrNull) {
      kegiatanC.namaC.text = model.nama ?? "";
      kegiatanC.deskripsiC.text = model.deskripsi ?? "";
      kegiatanC.tempatC.text = model.tempat ?? "";
      kegiatanC.selectedDate = model.tanggal ?? DateTime.now();
      formFoto.oldPath = model.photoUrl ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    kegiatanC.clear();
  }

  // DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    var result = await showDatePicker(
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
        title: Text(mk_lbl_waktu_tempat, style: primaryTextStyle()),
        content: Obx(
          () => Column(children: <Widget>[
            Card(
              elevation: 2,
              child: ListTile(
                onTap: () {
                  _selectDate(context);
                },
                title: Text(
                  'Tanggal Kegiatan',
                  style: primaryTextStyle(),
                ),
                subtitle: Text(
                  "${kegiatanC.selectedDate.toLocal()}".split(' ')[0],
                  style: secondaryTextStyle(),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.date_range,
                    color: mkColorPrimaryDark,
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
                elevation: 2,
                child: ListTile(
                  onTap: () {
                    _selectTime(context);
                  },
                  title: Text(
                    'Waktu Kegiatan',
                    style: primaryTextStyle(),
                  ),
                  subtitle: Text(
                    timeFormatter(kegiatanC.selectedDate),
                    style: secondaryTextStyle(),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.schedule,
                      color: mkColorPrimaryDark,
                    ),
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                )),
            SizedBox(height: 20),
            EditText(
              isEnabled: !kegiatanC.isSaving.value,
              mController: kegiatanC.tempatC,
              label: mk_lbl_tempat_kegiatan,
              hint: mk_lbl_tempat_kegiatan,
              icon: Icon(Icons.volunteer_activism,
                  color: kegiatanC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
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
            16.height,
            formFoto,
          ]))
    ];
    return WillPopScope(
        onWillPop: () async {
          return kegiatanC.checkControllers(model, formFoto.newPath)
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
                          if (kegiatanC.isSaving.value == false) {
                            if (_formKey.currentState!.validate()) {
                              await kegiatanC.saveKegiatan(model,
                                  path: formFoto.newPath);
                            } else {
                              _formKey.currentState!.validate();
                            }
                          }
                        },
                        isSaving: kegiatanC.isSaving)
                  ],
                ),
              )),
        )));
  }
}
