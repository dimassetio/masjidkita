import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/kas/views/dashboard.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/DeleteDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/widgets/MasjidCarouselSlider.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

// ignore: must_be_immutable
class TMKasSlider extends StatelessWidget {
  const TMKasSlider(this.model);
  final MasjidModel model;
  @override
  Widget build(BuildContext context) {
    return MasjidCarouselSlider(
      aspectRatio: 2.5 / 1,
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
    var width = MediaQuery.of(context).size.width;
    var saldoAwal = currencyFormatter(dataKas.saldoAwal ?? 0);
    var saldo = currencyFormatter(dataKas.saldo);
    return Container(
      width: width,
      decoration: boxDecoration(bgColor: mkColorPrimary, radius: 20),
      child: InkWell(
        splashColor: mkColorPrimaryDark,
        onTap: () {
          dataKas.nama != "Kas Total"
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardKas(),
                  ),
                )
              : null;
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    text(dataKas.nama,
                        textColor: mkWhite,
                        fontSize: textSizeLarge,
                        fontFamily: fontBold),
                    text(
                      masjid.nama,
                      textColor: mkWhite,
                      fontSize: textSizeMedium,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: dataKas.nama != "Kas Total"
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      dataKas.nama != "Kas Total"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                text(
                                  "Saldo Awal",
                                  textColor: mkWhite,
                                  fontSize: textSizeMedium,
                                ),
                                // text("${dataKas.saldoAwal}",
                                text("${saldoAwal ?? " "}",
                                    textColor: mkWhite,
                                    fontSize: textSizeMedium)
                              ],
                            )
                          : SizedBox(),
                      dataKas.nama != "Kas Total"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                text(
                                  "Sisa Saldo",
                                  textColor: mkWhite,
                                  fontSize: textSizeMedium,
                                ),
                                text("$saldo",
                                    textColor: mkWhite,
                                    fontSize: textSizeMedium)
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                text(
                                  "Sisa Saldo",
                                  textColor: mkWhite,
                                  fontSize: textSizeLargeMedium,
                                ),
                                text("$saldo",
                                    textColor: mkWhite, fontSize: textSizeLarge)
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 15, top: 15),
              child: ClipOval(
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
                        child:
                            Icon(Icons.info, size: 30, color: mkColorPrimary)),
                  ),
                ),
              ),
            ),
            Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(right: 10, top: 5),
                child: dataKas.nama != "Kas Total"
                    ? Obx(() => masjidC.myMasjid.value
                        ? InkWell(
                            onTap: () {},
                            child: PopupMenuButton(
                              color: mkWhite,
                              icon: Icon(
                                Icons.more_vert,
                                color: mkWhite,
                              ),
                              onSelected: (dynamic value) async {
                                if (value == 'edit') {
                                  Get.toNamed(RouteName.edit_kas,
                                      arguments: dataKas);
                                } else if (value == 'delete') {
                                  var res = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDelete(
                                            titleName: 'Kas',
                                            subtitleName: dataKas.nama ?? "",
                                          ));
                                  if (res == true) {
                                    kasC.delete(dataKas);
                                  }
                                  // Get.toNamed(RouteName.new_kategori_transaksi,
                                  //     arguments: KategoriModel(dao: model.kategoriDao));
                                } else if (value == 'kategori') {
                                  Get.toNamed(RouteName.new_kategori);
                                }
                              },
                              offset: Offset(0, 50),
                              itemBuilder: (context) {
                                List<PopupMenuEntry<Object>> list = [];
                                list.add(
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.tag,
                                        color: Colors.black,
                                      ),
                                      title: Text('Tambah Kategori'),
                                    ),
                                    value: 'kategori',
                                  ),
                                );
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
                          )
                        : SizedBox())
                    : SizedBox()),
          ],
        ),
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
