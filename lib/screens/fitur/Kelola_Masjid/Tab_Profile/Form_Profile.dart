// import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/CurrencyInputFormatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppConstant.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

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

// class StepperBody extends StatelessWidget {
class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  var currentStep = 0.obs;
  int get currStep => currentStep.value;
  set currStep(int value) => this.currentStep.value = value;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (Get.routing.current != RouteName.new_masjid) {
      manMasjidC.nama.text = manMasjidC.deMasjid.nama ?? "";
      manMasjidC.alamat.text = manMasjidC.deMasjid.alamat ?? "";
      manMasjidC.photoUrl.text = manMasjidC.deMasjid.photoUrl ?? "";
      manMasjidC.deskripsi.text = manMasjidC.deMasjid.deskripsi ?? "";
      manMasjidC.kecamatan.text = manMasjidC.deMasjid.kecamatan ?? "";
      manMasjidC.kodePos.text = manMasjidC.deMasjid.kodePos ?? "";
      manMasjidC.kota.text = manMasjidC.deMasjid.kota ?? "";
      manMasjidC.provinsi.text = manMasjidC.deMasjid.provinsi ?? "";
      manMasjidC.tahun.text = manMasjidC.deMasjid.tahun ?? "";
      manMasjidC.luasTanah.text = manMasjidC.deMasjid.luasTanah ?? "";
      manMasjidC.luasBangunan.text = manMasjidC.deMasjid.luasBangunan ?? "";
      print("PP ${Get.routing.current} ${RouteName.new_masjid}");
    }
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
              enabled: !manMasjidC.isSaving.value,
              // focusNode: FocusNode(),
              maxLines: 1,
              autocorrect: false,
              // initialValue: manMasjidC.deMasjid.nama,
              // onChanged: (newValue) {
              //   manMasjidC.nama.text = newValue;
              // },
              controller: manMasjidC.nama,
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_lbl_nama_masjid,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_hint_nama_masjid,
                icon: Icon(Icons.home,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) {
                  return '$mk_lbl_nama_masjid $mk_is_required';
                }

                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 3,
              autocorrect: false,

              controller: manMasjidC.deskripsi,
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.multiline,
              // inputFormatters: [
              //   FilteringTextInputFormatter.singleLineFormatter
              // ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_hint_deskripsi,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_lbl_deskripsi,
                icon: Icon(Icons.home,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty)
                  return '$mk_lbl_deskripsi $mk_is_required';
                return null;
              },
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
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.alamat,
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
                hintText: mk_hint_alamat,
                icon: Icon(Icons.edit_location,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_lbl_alamat $mk_is_required';
                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.kecamatan,
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
                hintText: mk_hint_kecamatan,
                icon: Icon(Icons.edit_location,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_kecamatan $mk_is_required';
                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.kodePos,

              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5)
              ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_kode_pos,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_hint_kode_pos,
                icon: Icon(Icons.edit_location,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_kode_pos $mk_is_required';
                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.kota,

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
                hintText: mk_hint_kota,
                icon: Icon(Icons.edit_location,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_kota $mk_is_required';
                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.provinsi,

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
                hintText: mk_hint_provinsi,
                icon: Icon(Icons.edit_location,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_provinsi $mk_is_required';
                return null;
              },
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
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.tahun,

              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_tahun,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_hint_tahun,
                icon: Icon(Icons.house,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_tahun $mk_is_required';
                if (s.trim().toInt() <= 1400 ||
                    s.trim().toInt() > DateTime.now().year)
                  return '$mk_tahun tidak valid';
                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.luasTanah,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
                CurrencyInputFormatter()
              ],
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_LT,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_hint_LT,
                suffix: text("M\u00B2"),
                suffixStyle: boldTextStyle(size: textSizeSMedium.toInt()),
                icon: Icon(Icons.house,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_LT $mk_is_required';
                return null;
              },
            ),
            TextFormField(
              enabled: !manMasjidC.isSaving.value,
              maxLines: 1,
              autocorrect: false,
              controller: manMasjidC.luasBangunan,
              textInputAction: TextInputAction.next,
              cursorColor: appStore.textPrimaryColor,
              // style: primaryTextStyle(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
                CurrencyInputFormatter()
              ],
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              decoration: InputDecoration(
                labelText: mk_LB,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_hint_LB,
                suffix: text("M\u00B2"),
                suffixStyle: boldTextStyle(size: textSizeSMedium.toInt()),
                icon: Icon(Icons.house,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              validator: (s) {
                if (s!.trim().isEmpty) return '$mk_LB $mk_is_required';
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              validator: (value) =>
                  value == null ? '$mk_status_tanah $mk_is_required' : null,
              style: primaryTextStyle(color: appStore.textPrimaryColor),
              alignment: Alignment.centerLeft,
              value: manMasjidC.deMasjid.statusTanah,
              decoration: InputDecoration(
                labelText: mk_status_tanah,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_status_tanah,
                icon: Icon(Icons.house,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: manMasjidC.isSaving.value
                  ? null
                  : (String? newValue) {
                      // setState(() {
                      // toast(newValue);
                      manMasjidC.statusTanah = newValue ?? "";
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
              value: manMasjidC.deMasjid.legalitas,
              decoration: InputDecoration(
                labelText: mk_legalitas,
                hintStyle: secondaryTextStyle(),
                labelStyle: secondaryTextStyle(),
                hintText: mk_lbl_enter + mk_legalitas,
                icon: Icon(Icons.house,
                    color: manMasjidC.isSaving.value
                        ? mkColorPrimaryLight
                        : mkColorPrimaryDark),
              ),
              dropdownColor: appStore.appBarColor,
              onChanged: manMasjidC.isSaving.value
                  ? null
                  : (String? newValue) {
                      // setState(() {
                      manMasjidC.legalitas = newValue ?? "";
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
          content: Column(children: [
            Obx(() => manMasjidC.deMasjid.photoUrl != "" &&
                    manMasjidC.deMasjid.photoUrl != null
                ? CachedNetworkImage(
                    placeholder: placeholderWidgetFn() as Widget Function(
                        BuildContext, String)?,
                    imageUrl: manMasjidC.deMasjid.photoUrl ?? "",
                    fit: BoxFit.fill,
                  )
                : text('Belum Ada Gambar', fontSize: textSizeSMedium)),
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
                        isLoading: manMasjidC.isLoadingImage.value,
                        uploadPrecentage: manMasjidC.uploadPrecentage.value,
                        isSaving: manMasjidC.isSaving.value,
                        fromCamera: () {
                          manMasjidC.uploadImage(true);
                        },
                        fromGaleri: () {
                          manMasjidC.uploadImage(false);
                        },
                      );
                    });

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
                            // text("Saving = ${manMasjidC.isSaving}"),

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
                IconButton(
                    onPressed: () {
                      print(
                          "COK ${Get.routing.current} ${RouteName.new_masjid}");

                      print("GET ${Get.routing.current}");
                    },
                    icon: Icon(Icons.play_arrow)),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      if (manMasjidC.isSaving.value == false) {
                        if (_formKey.currentState!.validate()) {
                          // _formKey.currentState!.deactivate();
                          // _formKey.currentState!.save();
                          setState(() {});
                          await manMasjidC.updateDataMasjid();
                          // setState(() {});
                          // toast("Data Berhasil di Update");

                          // Get.back();
                          // manMasjidC.clearControllers();
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
                          bgColor: manMasjidC.isSaving.value
                              ? mkColorPrimaryLight
                              : mkColorPrimary,
                          radius: 10),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: manMasjidC.isSaving.value
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
