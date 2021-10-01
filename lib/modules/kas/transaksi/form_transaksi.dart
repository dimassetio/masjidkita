import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/helpers/validator.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/kas/kategori/kategori_database.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/kas/buku/kas_model.dart';
import 'package:mosq/modules/kas/transaksi/transaksi_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/ButtonForm.dart';
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
  // KasModel modelKas = Get.arguments ?? KasModel();
  MqFormFoto formFoto = MqFormFoto();

  var isMutasi = false.obs;
  var isSelected = false.obs;
  List<KasModel> fromKases = kasC.kases;
  FilterKategori filter = FilterKategori.All;

  @override
  void initState() {
    super.initState();
    fromKases = kasC.kases;
    fromKases.removeWhere((item) => item.nama == "Kas Total");
    if (model.tipeTransaksi == 10) {
      filter = FilterKategori.Pemasukan;
    } else if (model.tipeTransaksi == 20) {
      filter = FilterKategori.Pengeluaran;
    }

    kategoriC.filterKategoriStream(masjidC.currMasjid, filter);
    if (!model.fromKas.isEmptyOrNull) {
      transaksiC.kasModel =
          fromKases.where((element) => element.id == model.fromKas).first;
    }

    if (!model.id.isEmptyOrNull) {
      transaksiC.keterangan.text = model.keterangan ?? "";
      transaksiC.selectedDate = model.tanggal ?? DateTime.now();
      transaksiC.kategori = model.kategori;
      kategoriC.filteredKategories.forEach((element) {
        print("fil : ${element.toSnapshot()}}");
      });
      print("ele : ${transaksiC.kategoriModel?.toSnapshot()}}");
      print(kategoriC.filteredKategories.length);

      transaksiC.tipeTransaksi = model.tipeTransaksi;
      transaksiC.jumlah.text = currencyFormatter(model.jumlah);
      // transaksiC.selectedDate = model.tanggal ?? DateTime.now();
      formFoto.oldPath = model.photoUrl ?? '';
      if (transaksiC.jumlah.text.isEmptyOrNull) {
        transaksiC.jumlah.text = transaksiC.jumlah.text;
      }
    }

    if (transaksiC.tipeTransaksi != null) isSelected.value = true;
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
        title: Text(mk_lbl_data_transaksi),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            Obx(
              () => InkWell(
                onTap: () {
                  transaksiC.selectDate(context);
                },
                child: EditText(
                  label: 'Tanggal Transaksi',
                  mController: TextEditingController(
                      text: dateFormatter(transaksiC.selectedDate)),
                  icon: Icon(
                    Icons.date_range,
                    color: mkColorPrimaryDark,
                  ),
                  isEnabled: false,
                ),
              ),
            ),
            10.height,
            Obx(
              () => DropdownButtonFormField<KasModel>(
                validator: (value) =>
                    (Validator(attributeName: mk_lbl_buku_kas, model: value)
                          ..requireModel())
                        .getError(),
                value: transaksiC.kasModel,
                style: primaryTextStyle(color: appStore.textPrimaryColor),
                alignment: Alignment.centerLeft,
                // value: KasModel(
                //     id: transaksiC.kategoriID, nama: transaksiC.kategori),
                decoration: InputDecoration(
                  labelText: mk_lbl_buku_kas,
                  hintStyle: secondaryTextStyle(),
                  labelStyle: secondaryTextStyle(),
                  hintText: mk_lbl_enter + mk_lbl_buku_kas,
                  icon: Icon(Icons.book_outlined,
                      color: transaksiC.isSaving.value
                          ? mkColorPrimaryLight
                          : mkColorPrimaryDark),
                ),
                dropdownColor: appStore.appBarColor,
                onChanged: !model.fromKas.isEmptyOrNull
                    ? null
                    : transaksiC.isSaving.value
                        ? null
                        : (newValue) {
                            isSelected.value = true;
                            setState(() {
                              transaksiC.kasModel = newValue!;
                            });
                          },
                items: fromKases.map<DropdownMenuItem<KasModel>>((value) {
                  return DropdownMenuItem<KasModel>(
                    value: value,
                    child: Tooltip(
                        message: value.nama ?? '',
                        child: Container(
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child: Text(value.nama ?? '',
                                style: primaryTextStyle()))),
                  );
                }).toList(),
              ),
            ),
            10.height,
            DropdownButtonFormField<int>(
                value: transaksiC.tipeTransaksi,
                decoration: InputDecoration(
                  labelText: mk_lbl_tipe_transaksi,
                  hintStyle: secondaryTextStyle(),
                  labelStyle: secondaryTextStyle(),
                  hintText: mk_lbl_enter + mk_lbl_tipe_transaksi,
                  icon: Icon(Icons.change_circle_outlined,
                      color: transaksiC.isSaving.value
                          ? mkColorPrimaryLight
                          : mkColorPrimaryDark),
                ),
                validator: (value) => (Validator(
                        attributeName: mk_lbl_tipe_transaksi,
                        value: value.toString())
                      ..required())
                    .getError(),
                onChanged: !model.id.isEmptyOrNull
                    ? null
                    : (newValue) {
                        setState(() {
                          transaksiC.kategoriModel = null;
                          FilterKategori? filter;
                          switch (newValue) {
                            case 10:
                              filter = FilterKategori.Pemasukan;
                              isMutasi.value = false;
                              break;
                            case 20:
                              filter = FilterKategori.Pengeluaran;
                              isMutasi.value = false;
                              break;
                            case 30:
                              filter = FilterKategori.All;
                              isMutasi.value = true;
                              break;
                          }
                          isSelected.value = true;
                          transaksiC.tipeTransaksi = newValue;
                          kategoriC.filterKategoriStream(
                              masjidC.currMasjid, filter);
                        });
                      },
                items: [
                  DropdownMenuItem<int>(
                    enabled: false,
                    value: 30,
                    child: Tooltip(
                      message: 'Mutasi',
                      child: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text('Mutasi (Disabled)',
                            style: primaryTextStyle()),
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 10,
                    child: Tooltip(
                      message: 'Pemasukan',
                      child: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text('Pemasukan', style: primaryTextStyle()),
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 20,
                    child: Tooltip(
                      message: 'Pengeluaran',
                      child: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text('Pengeluaran', style: primaryTextStyle()),
                      ),
                    ),
                  ),
                ]),
            10.height,
            Obx(
              () => DropdownButtonFormField<KategoriModel>(
                validator: (value) => (Validator(
                        attributeName: mk_lbl_jenis_Kategori_transaksi,
                        model: value)
                      ..requireModel())
                    .getError(),
                value: model.kategoriID.isEmptyOrNull
                    ? null
                    : transaksiC.mKategori(model.kategoriID!),
                // value: transaksiC.kategoriModel,

                style: primaryTextStyle(color: appStore.textPrimaryColor),
                alignment: Alignment.centerLeft,
                // value: KategoriModel(
                //     id: transaksiC.kategoriID, nama: transaksiC.kategori),
                decoration: InputDecoration(
                  labelText: mk_lbl_jenis_Kategori_transaksi,
                  hintStyle: secondaryTextStyle(),
                  labelStyle: secondaryTextStyle(),
                  hintText: mk_lbl_enter + mk_lbl_jenis_Kategori_transaksi,
                  icon: Icon(Icons.plagiarism_outlined,
                      color: transaksiC.isSaving.value
                          ? mkColorPrimaryLight
                          : mkColorPrimaryDark),
                ),
                dropdownColor: appStore.appBarColor,
                onChanged: transaksiC.isSaving.value
                    ? null
                    : (newValue) {
                        isSelected.value = true;
                        setState(() {
                          transaksiC.kategoriModel = newValue!;
                        });
                      },
                items: kategoriC.filteredKategories
                    .map<DropdownMenuItem<KategoriModel>>((value) {
                  return DropdownMenuItem<KategoriModel>(
                    value: value,
                    child: Tooltip(
                        message: value.nama ?? '',
                        child: Container(
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child: Text(value.nama ?? '',
                                style: primaryTextStyle()))),
                  );
                }).toList(),
              ),
            ),
            10.height,
            EditText(
              isEnabled: !transaksiC.isSaving.value,
              mController: transaksiC.keterangan,
              textInputAction: TextInputAction.newline,
              label: mk_lbl_keterangan,
              hint: mk_lbl_keterangan_optional,
              icon: Icon(Icons.departure_board_outlined,
                  color: transaksiC.isSaving.value
                      ? mkColorPrimaryLight
                      : mkColorPrimaryDark),
              maxLine: 3,
              keyboardType: TextInputType.multiline,
            ),
            10.height,
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
        isActive: currStep == 1,
        state: isSelected.value ? StepState.indexed : StepState.disabled,
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
                            currStep < stepsTransaksi.length - 1 &&
                                    isSelected.value
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
                ButtonForm(
                    tapFunction: () {
                      if (transaksiC.isSaving.value == false) {
                        if (_formKey.currentState!.validate()) {
                          transaksiC.saveTransaksi(model,
                              path: formFoto.newPath);
                        } else {
                          _formKey.currentState!.validate();
                        }
                      }
                    },
                    isSaving: transaksiC.isSaving)
              ],
            ),
          )),
    ));
  }
}
