import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
// import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/MqFoto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppWidget.dart';

// ignore: must_be_immutable
class DetailTransaksi extends StatelessWidget {
  List argument = Get.arguments;
  @override
  Widget build(BuildContext context) {
    TransaksiModel model = argument[0];
    KasModel kas = argument[1];
    KasModel toKas = argument[2] ?? null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appStore.appBarColor,
        leading: BackButton(color: mkBlack),
        title: appBarTitleWidget(context, 'Detail Transaksi'),
        // actions: actions,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(12),
                child: MqFoto(
                  oldPath: model.photoUrl ?? '',
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: boxDecoration(radius: 12, showShadow: true),
                child: Column(
                  children: [
                    // Divider(color: mkColorPrimaryDark),
                    ListTile(
                      leading: TipeTransaksiIcon(
                          tipeTransaksi: model.tipeTransaksi!),
                      title: text(tipeTransaksiToStr(model.tipeTransaksi),
                          fontSize: textSizeSMedium,
                          textColor: mkTextColorSecondary),
                      subtitle: text(currencyFormatter(model.jumlah),
                          fontSize: textSizeMedium, fontFamily: fontSemibold),
                    ),
                    ListTile(
                      leading: Icon(Icons.my_library_books,
                          color: mkColorPrimaryDark),
                      title: text(mk_lbl_buku_kas,
                          fontSize: textSizeSmall,
                          textColor: mkTextColorSecondary),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("${kas.nama}",
                              fontSize: textSizeMedium,
                              textColor: mkTextColorPrimary),
                          model.toKas != null
                              ? Icon(
                                  Icons.arrow_forward_rounded,
                                  color: mkColorPrimaryDark,
                                )
                              : SizedBox(),
                          model.toKas != null
                              ? text("${toKas.nama}",
                                  fontSize: textSizeMedium,
                                  textColor: mkTextColorPrimary)
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: boxDecoration(radius: 12, showShadow: true),
                child: Column(
                  children: [
                    text('Rincian'),
                    CustomTile(
                      title: 'Tanggal Transaksi',
                      subtitle: dateFormatter(model.tanggal),
                      icon: Icons.date_range,
                    ),
                    CustomTile(
                      title: 'Kategori Transaksi',
                      subtitle: model.kategori,
                      icon: Icons.nature,
                    ),
                    CustomTile(
                      title: 'Keterangan Transaksi',
                      subtitle: model.keterangan,
                      icon: Icons.description_outlined,
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: Get.width,
              //   margin: EdgeInsets.all(12),
              //   padding: EdgeInsets.symmetric(vertical: 12),
              //   decoration: BoxDecoration(
              //     color: mkWhite,
              //     boxShadow: defaultBoxShadow(shadowColor: shadowColorGlobal),
              //     borderRadius: BorderRadius.all(Radius.circular(12)),
              //   ),
              //   child: GestureDetector(
              //     onTap: () {
              //       showModalBottomSheet(
              //           backgroundColor: Colors.transparent,
              //           context: context,
              //           builder: (builder) => TesBSheet(
              //                 photoUrl: model.photoUrl,
              //               ));
              //     },
              //     child: Column(
              //       children: [
              //         Icon(Icons.keyboard_arrow_up_rounded),
              //         text('Foto Transaksi'),
              //       ],
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

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: mkColorPrimaryDark) : null,
      title:
          text(title, fontSize: textSizeSmall, textColor: mkTextColorSecondary),
      subtitle: text("$subtitle",
          fontSize: textSizeMedium, textColor: mkTextColorPrimary),
    );
  }
}

class TesBSheet extends StatelessWidget {
  TesBSheet({
    this.photoUrl,
    Key? key,
  }) : super(key: key);

  String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: 50,
          height: 10,
          decoration:
              boxDecoration(color: mkViewColor, radius: 16, bgColor: mkWhite),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: appStore.scaffoldBackground),
          // height: Get.width,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    text('Bukti Transaksi'),
                    16.height,
                    MqFoto(
                      oldPath: photoUrl ?? '',
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}
