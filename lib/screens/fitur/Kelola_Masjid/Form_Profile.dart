import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:masjidkita/screens/utils/m_k_icon_icons.dart';
import 'package:masjidkita/screens/utils/widgets/AddOrJoin.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';

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

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;

  @override
  void initState() {
    super.initState();
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
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.nama,
              onChanged: (newValue) {
                manMasjidC.nama.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_lbl_nama_masjid,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_nama_masjid,
                icon: Icon(Icons.home, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 2,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.deskripsi,
              onChanged: (newValue) {
                manMasjidC.deskripsi.text = newValue;
              },
              // textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.multiline,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_lbl_deskripsi,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_deskripsi,
                icon: Icon(Icons.home, color: mkColorPrimaryDark),
              ),
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
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.alamat,
              onChanged: (newValue) {
                manMasjidC.alamat.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_lbl_alamat,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_alamat,
                icon: Icon(Icons.edit_location, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.kecamatan,
              onChanged: (newValue) {
                manMasjidC.kecamatan.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_kecamatan,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_kecamatan,
                icon: Icon(Icons.edit_location, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.kodePos,
              onChanged: (newValue) {
                manMasjidC.kodePos.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_kode_pos,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_kode_pos,
                icon: Icon(Icons.edit_location, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.kota,
              onChanged: (newValue) {
                manMasjidC.kota.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_kota,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_kota,
                icon: Icon(Icons.edit_location, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.provinsi,
              onChanged: (newValue) {
                manMasjidC.provinsi.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_provinsi,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_provinsi,
                icon: Icon(Icons.edit_location, color: mkColorPrimaryDark),
              ),
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
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.tahun,
              onChanged: (newValue) {
                manMasjidC.tahun.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_tahun,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_tahun,
                icon: Icon(Icons.house, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.luasTanah,
              onChanged: (newValue) {
                manMasjidC.luasTanah.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_LT,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_LT,
                suffix: text("M\u00B2"),
                suffixStyle: boldTextStyle(size: textSizeSMedium.toInt()),
                icon: Icon(Icons.house, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.luasBangunan,
              onChanged: (newValue) {
                manMasjidC.luasBangunan.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_LB,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_LB,
                suffix: text("M\u00B2"),
                suffixStyle: boldTextStyle(size: textSizeSMedium.toInt()),
                icon: Icon(Icons.house, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.statusTanah,
              onChanged: (newValue) {
                manMasjidC.statusTanah.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_status_tanah,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_status_tanah,
                icon: Icon(Icons.house, color: mkColorPrimaryDark),
              ),
            ),
            TextFormField(
              maxLines: 1,
              autocorrect: false,
              initialValue: manMasjidC.deMasjid.legalitas,
              onChanged: (newValue) {
                manMasjidC.legalitas.text = newValue;
              },
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_legalitas,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_legalitas,
                icon: Icon(Icons.house, color: mkColorPrimaryDark),
              ),
            ),
          ],
        ),
      ),
      Step(
          title: Text("Foto Masjid", style: primaryTextStyle()),
          isActive: currStep == 3,
          state: StepState.indexed,
          content: Column(children: [
            Obx(() => Image.network(
                  manMasjidC.deMasjid.photoUrl ?? "",
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text("Belum Ada Gambar");
                  },
                )),
            ElevatedButton(
              child: text("Upload Image", textColor: mkWhite),
              onPressed: () {
                bool isCam = false;
                manMasjidC.getImage(isCam);
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          currStep < steps.length - 1
                              ? TextButton(
                                  onPressed: onStepContinue,
                                  child: Text(mk_berikut,
                                      style: secondaryTextStyle()),
                                )
                              : 10.width,
                          currStep != 0
                              ? TextButton(
                                  onPressed: onStepCancel,
                                  child: Text(mk_sebelum,
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
              GestureDetector(
                onTap: () {
                  manMasjidC.updateDataMasjid();
                  manMasjidC.clearControllers();
                  finish(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration:
                      boxDecoration(bgColor: mkColorPrimary, radius: 10),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text(mk_submit, style: boldTextStyle(color: white)),
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
