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
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
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
    transaksiC.kategori = TextEditingController();
    transaksiC.tipeTransaksi = TextEditingController();

    if (!model.id.isEmptyOrNull) {
      transaksiC.nama.text = model.nama ?? "";
      transaksiC.keterangan.text = model.keterangan ?? "";
      transaksiC.kategori.text = model.kategori ?? "";
      transaksiC.jumlah.text = currencyFormatter(model.jumlah);
      transaksiC.selectedDate = model.tanggal ?? DateTime.now();
      if (transaksiC.jumlah.text.isEmptyOrNull) {
        transaksiC.jumlah.text = transaksiC.jumlah.text;
      }
    }

    // if (isKasRoute) {
    //   if (model.id != null) {
    //     nama.text = model.nama ?? "";
    //     saldoAwal.text = Formatter().currencyFormatter.format(model.saldoAwal);
    //     // url.text = model.url ?? "";
    //     // jumlah.text = model.jumlah.toString();
    //   }
    // } else {
    //   if (modelKategori.id != null) {
    //     namaKategori.text = modelKategori.nama ?? "";
    //     jenis.text = modelKategori.jenis ?? "";
    //   }
    // }
  }

  @override
  void dispose() {
    super.dispose();
    transaksiC.clear();
    // KasC.downloadUrl.value = "";
    // showDialog(
    //     context: context, builder: (BuildContext context) => ConfirmDialog());
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
            EditText(
              isEnabled: !transaksiC.isSaving.value,
              mController: transaksiC.nama,
              validator: (value) =>
                  (Validator(attributeName: mk_lbl_transaksi, value: value)
                        ..required())
                      .getError(),
              // inputFormatters: [CurrrencyInputFormatter()],
              label: mk_lbl_nama,
              icon: Icon(Icons.nature,
                  color: transaksiC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
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
              hint: mk_lbl_keterangan,
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
      Step(
        title: Text(mk_lbl_jumlah, style: primaryTextStyle()),
        isActive: currStep == 1,
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
          title: Text(mk_lbl_bukti_transaks, style: primaryTextStyle()),
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
                child: Obx(() => transaksiC.xfoto.value.path.isNotEmpty
                    ? Image.file(File(transaksiC.xfoto.value.path))
                    : !model.url.isEmptyOrNull
                        ? CachedNetworkImage(
                            placeholder: placeholderWidgetFn() as Widget
                                Function(BuildContext, String)?,
                            imageUrl: model.url!,
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
                        isSaving: transaksiC.isSaving,
                        fromCamera: () async {
                          await transaksiC.getImage(true);
                          Get.back();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        fromGaleri: () async {
                          await transaksiC.getImage(false);
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
                            await transaksiC.saveTransaksi(model);
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
