import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:get/get.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';

DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

// @override
// void initState() {
//   super.initState();
//   init();
//   print(selectedTime.period);
// }

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      helpText: 'Select your Booking date',
      cancelText: 'Not Now',
      confirmText: "Book",
      fieldLabelText: 'Booking Date',
      fieldHintText: 'Month/Date/Year',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      context: context,
      builder: (BuildContext context, Widget? child) {
        return CustomTheme(
          child: child,
        );
      },
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  // if (picked != null && picked != selectedDate)
  //   setState(() {
  //     print(picked);
  //     selectedDate = picked;
  //   });
}

Future<Null> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return CustomTheme(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      });

  // if (picked != null)
  //   setState(() {
  //     selectedTime = picked;
  //   });
}

class FormKegiatan extends StatelessWidget {
  static const tag = '/FormKegiatan';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                kegiatanC.checkControllers()
                    ? showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) => ConfirmDialog(),
                      )
                    : finish(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(context, mk_add_kegiatan),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    kegiatanC
                        .addKegiatan(authController.firebaseUser.value.uid);
                  },
                  child: Icon(
                    Icons.check,
                    size: 26.0,
                    color: mkColorPrimary,
                  ),
                ),
              )
            ],
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
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (Get.parameters['id'] != null) {
      kegiatanC.namaController.text = kegiatanC.kegiatan.nama ?? "";
      kegiatanC.deskripsiController.text = kegiatanC.kegiatan.deskripsi ?? "";
      // kegiatanC.tanggalController.text = kegiatanC.kegiatan.tanggal ?? "";
      kegiatanC.fotoController.text = kegiatanC.kegiatan.foto ?? "";
      kegiatanC.urlController.text = kegiatanC.kegiatan.url ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    kegiatanC.clearControllers();
    kegiatanC.downloadUrl.value = "";
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text("Data kegiatan"),
        content: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              controller: kegiatanC.namaController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'ex: Istighosah',
                labelText: 'Nama Kegiatan',
              ),
              validator: (s) {
                if (s!.trim().isEmpty)
                  return '$mk_lbl_nama_kegiatan $mk_is_required';
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: TextFormField(
          //     controller: kegiatanC.deskripsiController,
          //     decoration: InputDecoration(
          //       border: UnderlineInputBorder(),
          //       hintText: 'ex: Baik',
          //       labelText: 'Kondisi barang',
          //     ),
          //     validator: (s) {
          //       if (s!.trim().isEmpty)
          //         return '$mk_lbl_deskripsi_kegiatan $mk_is_required';
          //       return null;
          //     },
          //   ),
          // ),
          TextFormField(
            style: primaryTextStyle(),
            controller: kegiatanC.deskripsiController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: mkColorPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1, color: mkColorPrimary),
              ),
              labelText: "Rincian kegiatan",
              hintText: "deskripsikan...",
              hintStyle: TextStyle(color: appStore.textSecondaryColor),
              labelStyle: TextStyle(color: appStore.textSecondaryColor),
              alignLabelWithHint: true,
              // filled: true,
            ),
            cursorColor: appStore.isDarkModeOn ? white : blackColor,
            keyboardType: TextInputType.multiline,
            maxLines: 12,
            textInputAction: TextInputAction.done,
            validator: (s) {
              if (s!.trim().isEmpty)
                return '$mk_lbl_deskripsi_kegiatan $mk_is_required';
              return null;
            },
          ),
        ]),
        isActive: currStep == 0,
        // state: StepState.complete
      ),
      Step(
        title: Text("Waktu & Tempat"),
        content: Column(children: <Widget>[
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
                  "${selectedDate.toLocal()}".split(' ')[0],
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
                  "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"} : ${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period != DayPeriod.am ? 'PM' : 'AM'}   ",
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
          TextFormField(
            controller: kegiatanC.tanggalController,
            // focusNode: addressFocus,
            style: primaryTextStyle(),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_on,
                color: mkColorPrimary,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: mkColorPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1, color: mkColorPrimary),
              ),
              labelText: 'Tempat acara',
              labelStyle: secondaryTextStyle(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            cursorColor: appStore.isDarkModeOn ? white : blackColor,
            keyboardType: TextInputType.multiline,
            validator: (s) {
              if (s!.trim().isEmpty) return 'Address is required';
              return null;
            },
          ),
        ]),
        isActive: currStep == 1,
        // state: StepState.complete
      ),
      Step(
          title: Text("Foto"),
          content: Column(
            children: <Widget>[
              Obx(() =>
                  kegiatanC.kegiatan.url != "" && kegiatanC.kegiatan.url != null
                      ? Container(
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            width: Get.width - 40,
                            placeholder: placeholderWidgetFn() as Widget
                                Function(BuildContext, String)?,
                            imageUrl: kegiatanC.downloadUrl.value.isEmpty
                                ? kegiatanC.kegiatan.url.toString()
                                : kegiatanC.downloadUrl.value,
                            fit: BoxFit.cover,
                          ),
                        )
                      : text('Belum Ada Gambar', fontSize: textSizeSMedium)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: TextFormField(
                  focusNode: FocusNode(),
                  enableInteractiveSelection: false,
                  // style: GoogleFonts.poppins(),
                  enabled: false,
                  controller: kegiatanC.fotoController,
                  decoration: InputDecoration(hintText: kegiatanC.message),
                  validator: (s) {
                    if (s!.trim().isEmpty)
                      return '$mk_lbl_foto_kegiatan $mk_is_required';
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                child: text("Upload Foto",
                    textColor: mkWhite, fontSize: textSizeSMedium),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: appStore.scaffoldBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0)),
                      ),
                      builder: (builder) {
                        return Container(
                            height: 250.0,
                            padding: EdgeInsets.all(16),
                            child: Obx(
                              () => kegiatanC.isLoadingImage.value
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        text("Loading..."),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LinearProgressIndicator(
                                          value:
                                              kegiatanC.uploadPrecentage.value,
                                        ),
                                        text(
                                            "${(kegiatanC.uploadPrecentage.value * 100).toInt()} %"),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Upload Foto dari",
                                          style: boldTextStyle(
                                              color: appStore.textPrimaryColor),
                                        ),
                                        16.height,
                                        Divider(
                                          height: 5,
                                        ),
                                        16.height,
                                        TextButton.icon(
                                            // style: ,
                                            onPressed: () {
                                              kegiatanC.uploadImage(false);
                                            },
                                            icon: Icon(
                                              Icons.image_sharp,
                                              color: mkColorPrimaryDark,
                                            ),
                                            label: text(
                                              "Galeri",
                                              textColor: mkColorPrimaryDark,
                                            )),
                                        Divider(),
                                        TextButton.icon(
                                            // style: ,
                                            onPressed: () async {
                                              kegiatanC.uploadImage(true);
                                            },
                                            icon: Icon(
                                              Icons.camera,
                                              color: mkColorPrimaryDark,
                                            ),
                                            label: text(
                                              "Kamera",
                                              textColor: mkColorPrimaryDark,
                                            )),
                                        8.height,
                                      ],
                                    ),
                            ));
                      });
                  // kegiatanC.kegiatanage(image!);
                },
              ),
              Opacity(
                opacity: 0.0,
                child: TextField(
                  focusNode: FocusNode(),
                  enableInteractiveSelection: false,
                  // style: GoogleFonts.poppins(),
                  enabled: false,
                  controller: kegiatanC.urlController,
                ),
              ),
              // Opacity(
              //   opacity: 0.0,
              //   child: TextField(
              //     focusNode: FocusNode(),
              //     enableInteractiveSelection: false,
              //     // style: GoogleFonts.poppins(),
              //     enabled: false,
              //     controller: kegiatanC.fotoController,
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     kegiatanC
              //         .addkegiatan(authController.firebaseUser.value.uid);
              //   },
              //   child: text("Tambahkan",
              //       textColor: mkWhite, fontSize: textSizeMedium),
              //   style: ElevatedButton.styleFrom(
              //     primary: mkColorPrimary,
              //   ),
              // ).center()
            ],
          ),
          isActive: currStep == 2,
          state: StepState.disabled),
    ];

    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: ThemeData(colorScheme: mkColorScheme),
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  steps: steps,
                  type: StepperType.horizontal,
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
                    setState(() {
                      if (currStep < steps.length - 1) {
                        currStep = currStep + 1;
                      } else {
                        //currStep = 0;
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
              // Obx(
              //   () => GestureDetector(
              //     onTap: () async {
              //       if (kegiatanC.isSaving.value == false) {
              //         if (_formKey.currentState!.validate()) {
              //           // _formKey.currentState!.deactivate();
              //           // _formKey.currentState!.save();
              //           setState(() {});
              //           await kegiatanC.updatekegiatan();
              //           // setState(() {});
              //           // toast("Data Berhasil di Update");

              //           Get.back();
              //           // manMasjidC.clearControllers();
              //         } else {
              //           _formKey.currentState!.validate();
              //         }
              //       }
              //       // finish(context);
              //     },
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       height: 50,
              //       margin: EdgeInsets.all(10),
              //       decoration: boxDecoration(
              //           bgColor: kegiatanC.isSaving.value
              //               ? mkColorPrimaryLight
              //               : mkColorPrimary,
              //           radius: 10),
              //       padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              //       child: Center(
              //         child: kegiatanC.isSaving.value
              //             ? CircularProgressIndicator()
              //             : Text(mk_submit,
              //                 style: boldTextStyle(color: white, size: 18)),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
