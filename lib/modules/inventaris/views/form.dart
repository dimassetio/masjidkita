import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/helpers/validator.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/MqFormFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:get/get.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main.dart';

class FormInventaris extends StatefulWidget {
  final InventarisModel model = Get.arguments ?? InventarisModel();
  static const tag = '/FormInventaris';
  // const FormInventaris({Key? key, required this.model}) : super(key: key);
  @override
  _FormInventarisState createState() => _FormInventarisState();
}

class _FormInventarisState extends State<FormInventaris> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isEdit = Get.currentRoute != RouteName.new_inventaris;
  // var isSaving = false.obs;
  // GlobalKey<FormState> formKey = GlobalKey();
  InventarisModel model = Get.arguments as InventarisModel;
  MqFormFoto formFoto = MqFormFoto();
  @override
  void initState() {
    super.initState();

    inventarisC.nama = TextEditingController();
    inventarisC.kondisi = TextEditingController();
    inventarisC.harga = TextEditingController();
    inventarisC.jumlah = TextEditingController();

    if (model.id != null) {
      inventarisC.nama.text = model.nama ?? "";
      inventarisC.kondisi.text = model.kondisi ?? "";
      inventarisC.harga.text = currencyFormatter(model.harga);
      inventarisC.jumlah.text = model.jumlah.toString();
      formFoto.oldPath = model.photoUrl ?? "";
    }

    // if (isEdit == true) {}
  }

  @override
  void dispose() {
    super.dispose();
    inventarisC.clear();
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<FormState> formKey = GlobalKey();
    List<Step> steps = [
      Step(
        title: Text("Data inventaris"),
        content: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              fontSize: textSizeLargeMedium,
              mController: inventarisC.nama,
              hint: mk_hint_nama_inventaris,
              label: mk_lbl_nama_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_nama_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !inventarisC.isSaving.value,
              icon: Icon(Icons.dns,
                  color: inventarisC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              mController: inventarisC.kondisi,
              hint: mk_hint_kondisi_inventaris,
              label: mk_lbl_kondisi_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_kondisi_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !inventarisC.isSaving.value,
              icon: Icon(Icons.add_task,
                  color: inventarisC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              textAlign: TextAlign.end,
              mController: inventarisC.harga,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrrencyInputFormatter()
              ],
              keyboardType: TextInputType.number,
              hint: mk_hint_harga_inventaris,
              label: mk_lbl_harga_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_harga_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !inventarisC.isSaving.value,
              icon: Icon(Icons.money,
                  color: inventarisC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: EditText(
              textAlign: TextAlign.end,
              mController: inventarisC.jumlah,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              keyboardType: TextInputType.number,
              hint: mk_hint_jumlah_inventaris,
              label: mk_lbl_jumlah_inventaris,
              validator: (value) => (Validator(
                      attributeName: mk_lbl_jumlah_inventaris, value: value)
                    ..required())
                  .getError(),
              isEnabled: !inventarisC.isSaving.value,
              icon: Icon(Icons.play_for_work,
                  color: inventarisC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ),
        ]),
        isActive: currStep == 0,
      ),
      Step(
          title: Text("Foto"),
          content: Column(
            children: <Widget>[
              16.height,
              formFoto,
            ],
          ),
          isActive: currStep == 1,
          state: StepState.indexed),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appStore.appBarColor,
          leading: BackButton(),
          title: appBarTitleWidget(
            context,
            // mk_add_inventaris,
            Get.currentRoute == RouteName.new_inventaris
                ? mk_add_inventaris
                : mk_edit_inventaris,
          ),
          // actions: <Widget>[
          //   Padding(
          //     padding: EdgeInsets.only(right: 20.0),
          //     child: InkWell(
          //       onTap: () async {
          //         if (inventarisC.isSaving.value == false) {
          //           if (formKey.currentState!.validate()) {
          //             if (currStep < steps.length - 1) {
          //               currStep = currStep + 1;
          //             } else {
          //               inventarisC.isSaving.value = true;
          //               setState(() {});
          //               await inventarisC.saveInventaris(model);

          //               Get.back();
          //               inventarisC.isSaving.value = false;
          //             }
          //           } else {
          //             formKey.currentState!.validate();
          //           }
          //         }
          //       },
          //       child: inventarisC.isSaving.value
          //           ? Container(
          //               padding: EdgeInsets.all(13),
          //               width: 55.0,
          //               child: CircularProgressIndicator())
          //           : Icon(
          //               Icons.check,
          //               size: 26.0,
          //               color: mkColorPrimary,
          //             ),
          //     ),
          //   )
          // ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            // return Future.value(true);
            return inventarisC.checkControllers(model, formFoto.newPath)
                ? await showDialog(
                    context: context,
                    builder: (BuildContext context) => ConfirmDialog())
                : Future.value(true);
          },
          child: Theme(
            data: ThemeData(colorScheme: mkColorScheme),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Stepper(
                      steps: steps,
                      type: StepperType.vertical,
                      currentStep: this.currStep,
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
                                        style: secondaryTextStyle(),
                                        textAlign: TextAlign.start),
                                  )
                                : 10.width,
                            currStep < steps.length - 1
                                ? TextButton(
                                    // onPressed: () {
                                    //   if(formKey.currentState!.validate(),
                                    //   onStepContinue;
                                    // }
                                    onPressed: onStepContinue,
                                    child: Text(mk_berikut,
                                        style: secondaryTextStyle(),
                                        textAlign: TextAlign.end),
                                  )
                                : 10.width,
                          ],
                        );
                      },
                      onStepContinue: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            if (currStep < steps.length - 1) {
                              currStep = currStep + 1;
                            } else {
                              //currStep = 0;
                              finish(context);
                            }
                          });
                        }
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
                  Obx(
                    () => Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: boxDecoration(
                          bgColor: inventarisC.isSaving.value
                              ? mkColorPrimaryLight
                              : mkColorPrimary,
                          radius: 10),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: InkWell(
                        onTap: () async {
                          if (inventarisC.isSaving.value == false) {
                            if (formKey.currentState!.validate()) {
                              await inventarisC.saveInventaris(model,
                                  path: formFoto.newPath);
                            } else {
                              formKey.currentState!.validate();
                            }
                          }
                        },
                        child: Center(
                          child: inventarisC.isSaving.value
                              ? CircularProgressIndicator()
                              : Text(mk_submit,
                                  style: boldTextStyle(color: white, size: 18)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
