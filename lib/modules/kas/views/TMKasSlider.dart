import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/MasjidCarouselSlider.dart';

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
            return Container(
              child: SingleChildScrollView(
                child: Obx(() => ListView.builder(
                    padding: EdgeInsets.symmetric(),
                    scrollDirection: Axis.vertical,
                    itemCount: kasC.kases.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return KasSlider(
                        dataKas: kasC.kases[index],
                        masjid: model,
                      );
                    })),
              ),
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
    var saldoAwal = Formatter().currencyFormatter.format(dataKas.saldoAwal);
    var saldo = Formatter().currencyFormatter.format(dataKas.saldo);
    return Container(
      // height: 400,
      width: width,
      decoration: boxDecoration(bgColor: mkColorPrimary, radius: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              text(dataKas.nama,
                  textColor: mkWhite,
                  fontSize: textSizeLarge,
                  fontFamily: fontBold),
              text(
                "Masjid ${masjid.nama}",
                textColor: mkWhite,
                fontSize: textSizeMedium,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text(
                      "Saldo Awal",
                      textColor: mkWhite,
                      fontSize: textSizeMedium,
                    ),
                    // text("${dataKas.saldoAwal}",
                    text("$saldoAwal",
                        textColor: mkWhite, fontSize: textSizeMedium)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text(
                      "Sisa Saldo",
                      textColor: mkWhite,
                      fontSize: textSizeMedium,
                    ),
                    text("$saldo", textColor: mkWhite, fontSize: textSizeMedium)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
