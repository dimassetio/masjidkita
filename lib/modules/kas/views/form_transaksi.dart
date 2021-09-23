import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/kas/kategori/kategori_database.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/utils/m_k_icon_icons.dart';
import 'package:mosq/screens/widgets/MqFormFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class FormTransaksi extends StatelessWidget {
  final TransaksiModel model = Get.arguments ?? TransaksiModel();
  static const tag = '/FormTransaksi';

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
                Get.currentRoute == RouteName.edit_transaksi
                    ? mk_edit_transaksi
                    : mk_add_transaksi),
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

  bool isEdit = Get.currentRoute == RouteName.edit_transaksi;

  GlobalKey<FormState> _formKey = GlobalKey();

  TransaksiModel model = Get.arguments ?? TransaksiModel();
  MqFormFoto formFoto = MqFormFoto();

  var isMutasi = false.obs;

  // KategoriModel modelKategori = Get.arguments ?? KategoriModel();

  // List<String> jenisList = [
  //   'Pengeluaran',
  //   'Pemasukan',
  //   'Mutasi',
  // ];
  // String? jenisTransaksi;

  @override
  void initState() {
    super.initState();
    transaksiC.nama = TextEditingController();
    transaksiC.url = TextEditingController();
    transaksiC.jumlah = TextEditingController();
    transaksiC.keterangan = TextEditingController();
    // transaksiC.kategori = TextEditingController();
    transaksiC.tipeTransaksi = TextEditingController();
    kategoriC.filterKategoriStream(masjidC.currMasjid, null);

    if (!model.id.isEmptyOrNull) {
      transaksiC.keterangan.text = model.keterangan ?? "";
      transaksiC.kategori = model.kategori ?? "";
      transaksiC.jumlah.text = currencyFormatter(model.jumlah);
      transaksiC.selectedDate = model.tanggal ?? DateTime.now();
      formFoto.oldPath = model.photoUrl ?? '';
      if (transaksiC.jumlah.text.isEmptyOrNull) {
        transaksiC.jumlah.text = transaksiC.jumlah.text;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    transaksiC.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> stepsTransaksi = [
      Step(
        title: Text(mk_lbl_transaksi, style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            DropdownButtonFormField(
                // value: transaksiC.kategori,
                decoration: InputDecoration(
                  labelText: mk_lbl_jenis_transaksi,
                  hintStyle: secondaryTextStyle(),
                  labelStyle: secondaryTextStyle(),
                  hintText: mk_lbl_enter + mk_lbl_jenis_transaksi,
                  icon: Icon(Icons.change_circle_outlined,
                      color: transaksiC.isSaving.value
                          ? mkColorPrimaryLight
                          : mkColorPrimaryDark),
                ),
                onChanged: (newValue) {
                  if (newValue is FilterKategori) {
                    transaksiC.kategori = null;
                    isMutasi.value = false;
                  } else {
                    isMutasi.value = true;
                  }
                  kategoriC.filterKategoriStream(
                      masjidC.currMasjid, newValue as FilterKategori);
                },
                items: [
                  DropdownMenuItem(
                    value: FilterKategori.All,
                    child: Tooltip(
                      message: 'Mutasi',
                      child: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text('Mutasi', style: primaryTextStyle()),
                      ),
                    ),
                  ),
                  DropdownMenuItem<FilterKategori>(
                    value: FilterKategori.Pemasukan,
                    child: Tooltip(
                      message: 'Pemasukan',
                      child: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text('Pemasukan', style: primaryTextStyle()),
                      ),
                    ),
                  ),
                  DropdownMenuItem<FilterKategori>(
                    value: FilterKategori.Pengeluaran,
                    child: Tooltip(
                      message: 'Pengeluaran',
                      child: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text('Pengeluaran', style: primaryTextStyle()),
                      ),
                    ),
                  ),
                ]),
            Obx(
              () => DropdownButtonFormField<String>(
                validator: (value) => (Validator(
                        attributeName: mk_lbl_jenis_Kategori_transaksi,
                        value: value)
                      ..required())
                    .getError(),
                style: primaryTextStyle(color: appStore.textPrimaryColor),
                alignment: Alignment.centerLeft,
                value: transaksiC.kategori,
                decoration: InputDecoration(
                  labelText: mk_lbl_jenis_Kategori_transaksi,
                  hintStyle: secondaryTextStyle(),
                  labelStyle: secondaryTextStyle(),
                  hintText: mk_lbl_enter + mk_lbl_jenis_Kategori_transaksi,
                  icon: Icon(Icons.plagiarism,
                      color: transaksiC.isSaving.value
                          ? mkColorPrimaryLight
                          : mkColorPrimaryDark),
                ),
                dropdownColor: appStore.appBarColor,
                onChanged: transaksiC.isSaving.value
                    ? null
                    : (newValue) {
                        setState(() {
                          transaksiC.kategori = newValue;
                        });
                      },
                items: kategoriC.filteredKategories
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Tooltip(
                        message: value.nama!,
                        child: Container(
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child:
                                Text(value.nama!, style: primaryTextStyle()))),
                  );
                }).toList(),
              ),
            ),
            EditText(
              isEnabled: !transaksiC.isSaving.value,
              mController: transaksiC.keterangan,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_keterangan, value: value)
                        ..required())
                      .getError(),
              label: mk_lbl_keterangan,
              hint: mk_lbl_keterangan_optional,
              icon: Icon(Icons.departure_board,
                  color: transaksiC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              maxLine: 3,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
      // Step(
      //     title: Text(mk_lbl_buku_kas, style: primaryTextStyle()),
      //     isActive: currStep == 1,
      //     state: StepState.indexed,
      //     content: isMutasi
      //         ? Column(
      //             children: [
      //               DropdownButtonFormField<String>(
      //                 validator: (value) => (Validator(
      //                         attributeName: mk_lbl_buku_kas + mk_lbl_from,
      //                         value: value)
      //                       ..required())
      //                     .getError(),
      //                 style: primaryTextStyle(color: appStore.textPrimaryColor),
      //                 alignment: Alignment.centerLeft,
      //                 value: transaksiC.bukuAsal,
      //                 decoration: InputDecoration(
      //                   labelText: mk_lbl_buku_kas + mk_lbl_from,
      //                   hintStyle: secondaryTextStyle(),
      //                   labelStyle: secondaryTextStyle(),
      //                   hintText: mk_lbl_enter + mk_lbl_buku_kas + mk_lbl_from,
      //                   icon: Icon(Icons.pageview,
      //                       color: transaksiC.isSaving.value
      //                           ? mkColorPrimaryLight
      //                           : mkColorPrimaryDark),
      //                 ),
      //                 dropdownColor: appStore.appBarColor,
      //                 onChanged: transaksiC.isSaving.value
      //                     ? null
      //                     : (String? newValue) {
      //                         setState(() {
      //                           transaksiC.bukuAsal = newValue ?? "";
      //                         });
      //                       },
      //                 items: transaksiC.listBukuAsal
      //                     .map<DropdownMenuItem<String>>((String value) {
      //                   return DropdownMenuItem<String>(
      //                     value: value,
      //                     child: Tooltip(
      //                         message: value,
      //                         child: Container(
      //                             margin: EdgeInsets.only(left: 4, right: 4),
      //                             child:
      //                                 Text(value, style: primaryTextStyle()))),
      //                   );
      //                 }).toList(),
      //               ),
      //               DropdownButtonFormField<String>(
      //                 validator: (value) => (Validator(
      //                         attributeName: mk_lbl_buku_kas + mk_lbl_to,
      //                         value: value)
      //                       ..required())
      //                     .getError(),
      //                 style: primaryTextStyle(color: appStore.textPrimaryColor),
      //                 alignment: Alignment.centerLeft,
      //                 value: transaksiC.bukuTujuan,
      //                 decoration: InputDecoration(
      //                   labelText: mk_lbl_buku_kas + mk_lbl_to,
      //                   hintStyle: secondaryTextStyle(),
      //                   labelStyle: secondaryTextStyle(),
      //                   hintText: mk_lbl_enter + mk_lbl_buku_kas + mk_lbl_to,
      //                   icon: Icon(Icons.pageview,
      //                       color: transaksiC.isSaving.value
      //                           ? mkColorPrimaryLight
      //                           : mkColorPrimaryDark),
      //                 ),
      //                 dropdownColor: appStore.appBarColor,
      //                 onChanged: transaksiC.isSaving.value
      //                     ? null
      //                     : (String? newValue) {
      //                         setState(() {
      //                           transaksiC.bukuTujuan = newValue ?? "";
      //                         });
      //                       },
      //                 items: transaksiC.listBukuTujuan
      //                     .map<DropdownMenuItem<String>>((String value) {
      //                   return DropdownMenuItem<String>(
      //                     value: value,
      //                     child: Tooltip(
      //                         message: value,
      //                         child: Container(
      //                             margin: EdgeInsets.only(left: 4, right: 4),
      //                             child:
      //                                 Text(value, style: primaryTextStyle()))),
      //                   );
      //                 }).toList(),
      //               ),
      //             ],
      //           )
      //         : Column(
      //             children: [
      //               DropdownButtonFormField<String>(
      //                 validator: (value) => (Validator(
      //                         attributeName: mk_lbl_buku_kas + mk_lbl_from,
      //                         value: value)
      //                       ..required())
      //                     .getError(),
      //                 style: primaryTextStyle(color: appStore.textPrimaryColor),
      //                 alignment: Alignment.centerLeft,
      //                 value: transaksiC.bukuAsal,
      //                 decoration: InputDecoration(
      //                   labelText: mk_lbl_buku_kas + mk_lbl_from,
      //                   hintStyle: secondaryTextStyle(),
      //                   labelStyle: secondaryTextStyle(),
      //                   hintText: mk_lbl_enter + mk_lbl_buku_kas + mk_lbl_from,
      //                   icon: Icon(Icons.pageview,
      //                       color: transaksiC.isSaving.value
      //                           ? mkColorPrimaryLight
      //                           : mkColorPrimaryDark),
      //                 ),
      //                 dropdownColor: appStore.appBarColor,
      //                 onChanged: transaksiC.isSaving.value
      //                     ? null
      //                     : (String? newValue) {
      //                         setState(() {
      //                           transaksiC.bukuAsal = newValue ?? "";
      //                         });
      //                       },
      //                 items: transaksiC.listBukuAsal
      //                     .map<DropdownMenuItem<String>>((String value) {
      //                   return DropdownMenuItem<String>(
      //                     value: value,
      //                     child: Tooltip(
      //                         message: value,
      //                         child: Container(
      //                             margin: EdgeInsets.only(left: 4, right: 4),
      //                             child:
      //                                 Text(value, style: primaryTextStyle()))),
      //                   );
      //                 }).toList(),
      //               ),
      //             ],
      //           )),

      Step(
        title: Text(mk_lbl_jumlah, style: primaryTextStyle()),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: Column(
          children: [
            EditText(
              textAlign: TextAlign.end,
              mController: transaksiC.jumlah,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrrencyInputFormatter()
              ],
              keyboardType: TextInputType.number,
              hint: mk_hint_jumlah,
              label: mk_hint_jumlah,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_jumlah, value: value)
                        ..required())
                      .getError(),
              isEnabled: !transaksiC.isSaving.value,
              icon: Icon(Icons.play_for_work,
                  color: transaksiC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
            ),
          ],
        ),
      ),
      Step(
          title: Text("Foto Bukti Transaksi"),
          content: Column(
            children: <Widget>[
              16.height,
              formFoto,
            ],
          ),
          isActive: currStep == 3,
          state: StepState.indexed),
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
                      steps: stepsTransaksi,
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
                            currStep < stepsTransaksi.length - 1
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
                          if (currStep < stepsTransaksi.length - 1) {
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
                    width: Get.width,
                    height: 50,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (transaksiC.isSaving.value == false) {
                          if (_formKey.currentState!.validate()) {
                            await transaksiC.saveTransaksi(model,
                                path: formFoto.newPath);
                          } else {
                            _formKey.currentState!.validate();
                          }
                        }
                      },
                      child: Center(
                        child: transaksiC.isSaving.value
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
