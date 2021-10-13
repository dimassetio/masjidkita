import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/buku/views/show_kas.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/CustomAlert.dart';
import 'package:mosq/screens/widgets/DeleteDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/widgets/MasjidCarouselSlider.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../main.dart';

// ignore: must_be_immutable
class TMKasSlider extends StatelessWidget {
  const TMKasSlider(this.model);
  final MasjidModel model;
  @override
  Widget build(BuildContext context) {
    return MasjidCarouselSlider(
      aspectRatio: 2 / 1,
      viewportFraction: 0.9,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      items: kasC.kases.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return KasSlider(
              dataKas: slider,
              masjid: model,
            );
          },
        );
      }).toList(),
    );
  }
}

class KasSlider extends StatelessWidget {
  const KasSlider({required this.dataKas, required this.masjid});
  final KasModel dataKas;
  final MasjidModel masjid;

  @override
  Widget build(BuildContext context) {
    return KasCard(dataKas: dataKas, masjid: masjid);
  }
}

class KasCard extends StatelessWidget {
  KasCard({
    Key? key,
    required this.dataKas,
    required this.masjid,
    this.withPadding = false,
  }) : super(key: key);

  final KasModel dataKas;
  final MasjidModel masjid;
  bool withPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(mk_bg_kas), fit: BoxFit.cover),
        color: mkColorPrimary,
        boxShadow: [BoxShadow(color: Colors.transparent)],
        border: Border.all(color: mkColorPrimary),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.all(10),
      child: InkWell(
        splashColor: mkColorPrimaryDark,
        onTap: () {
          if (dataKas.nama != "Kas Total") {
            Get.toNamed(RouteName.dashboard_kas, arguments: dataKas);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(dataKas.nama ?? 'Kas',
                    textColor: mkWhite,
                    fontSize: textSizeLarge,
                    fontFamily: fontBold),
                Container(
                  // color: mkColorAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Material(
                          color: mkWhite, // Button color
                          child: InkWell(
                            splashColor: mkColorPrimaryDark, // Splash color
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogDeskripsiKas(dataKas),
                              );
                            },
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.info,
                                    size: 30, color: mkColorPrimary)),
                          ),
                        ),
                      ),
                      dataKas.nama != "Kas Total"
                          ? Obx(() => masjidC.myMasjid.value
                              ? PopUpMenuKas(dataKas: dataKas)
                              : SizedBox())
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            withPadding ? 16.height : 0.height,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chips_png,
                  height: 28,
                ),
                text(
                  masjid.nama ?? '',
                  textColor: mkWhite,
                  fontSize: textSizeLargeMedium,
                ),
              ],
            ),
            withPadding ? 16.height : 0.height,
            Container(
              // padding: EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  dataKas.nama != "Kas Total"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(
                              "Saldo Awal",
                              textColor: mkWhite,
                              fontSize: textSizeSMedium,
                            ),
                            // text("${dataKas.saldoAwal}",
                            text(
                                currencyFormatter(dataKas.saldoAwal ?? 0) ?? '',
                                textColor: mkWhite,
                                fontSize: textSizeMedium)
                          ],
                        )
                      : SizedBox(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(
                          "Sisa Saldo",
                          textColor: mkWhite,
                          fontSize: textSizeSMedium,
                        ),
                        text(currencyFormatter(dataKas.saldo ?? 0) ?? '',
                            textColor: mkWhite, fontSize: textSizeMedium)
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      mosq_logo_white,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PopUpMenuKas extends StatelessWidget {
  const PopUpMenuKas({
    Key? key,
    required this.dataKas,
    this.color = mkWhite,
  }) : super(key: key);

  final KasModel dataKas;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: PopupMenuButton(
        color: mkWhite,
        icon: Icon(
          Icons.more_vert,
          color: color,
        ),
        onSelected: (dynamic value) async {
          if (value == 'edit') {
            Get.toNamed(RouteName.edit_kas, arguments: dataKas);
          } else if (value == 'delete') {
            var res = await masjidC.currMasjid.transaksiDao!
                .kasHaveTransaksi(dataKas);
            if (res == false) {
              var res2 = await showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDelete(
                        titleName: 'Kas',
                        subtitleName: dataKas.nama ?? "",
                      ));
              if (res2 == true) {
                kasC.delete(dataKas);
              }
            } else if (res == true) {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomAlert(
                        title: 'Tidak Dapat Menghapus',
                        subtitle:
                            'Buku Kas ini tidak dapat dihapus karena telah memiliki data TRANSAKSI',
                        action: 'Tutup',
                      ));
            } else {
              Get.snackbar('Eror', 'Error While Checking Data Transaction!');
            }
          }
        },
        offset: Offset(0, 50),
        itemBuilder: (context) {
          List<PopupMenuEntry<Object>> list = [];
          list.add(
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                title: Text('Edit'),
              ),
              value: 'edit',
            ),
          );
          list.add(
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                title: Text('Hapus'),
              ),
              value: 'delete',
            ),
          );
          return list;
        },
      ),
    );
  }
}

class DialogDeskripsiKas extends StatelessWidget {
  const DialogDeskripsiKas(this.dataKas);
  final KasModel dataKas;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: appStore.scaffoldBackground,
      titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      title: Text('Tentang buku kas ini', style: boldTextStyle(size: 22)),
      children: [
        Text("${dataKas.deskripsi ?? ""} ", style: primaryTextStyle()),
      ],
    );
  }
}
