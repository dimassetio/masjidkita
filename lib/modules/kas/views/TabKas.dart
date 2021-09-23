import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/modules/kas/views/TMKasSlider.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

class TMTabKas extends StatelessWidget {
  const TMTabKas(this.model);
  final MasjidModel model;
  // final TransaksiModel modelT;
  @override
  Widget build(BuildContext context) {
    var width = Get.width - 10;
    var height = Get.height;
    return Stack(children: [
      Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => kasC.kases.isEmpty
                    ? Container(
                        height: 250,
                        child: text("Masjid belu memiliki buku Kas").center(),
                      )
                    : TMKasSlider(model),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Transaction',
                        style: TextStyle(fontSize: 18, fontFamily: fontMedium)),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 5),
                      height: 34,
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.withAlpha(50)),
                      ),
                      child: DropdownButton(
                        value: 'Weekly',
                        underline: SizedBox(),
                        items: <String>['Daily', 'Weekly', 'Monthly', 'Yearly']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          print(value);
                        },
                      ),
                    )
                  ],
                ),
              ),
              // TransaksiKas(),
            ],
          ),
        ),
      ),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 15, bottom: 15),
          child: Obx(() => masjidC.myMasjid.value
              ? FloatingActionButton(
                  child: Icon(
                    Icons.edit,
                    color: mkWhite,
                  ),
                  backgroundColor: mkColorPrimary,
                  onPressed: () {
                    Get.toNamed(RouteName.new_transaksi,
                        arguments: TransaksiModel(dao: model.transaksiDao));
                  })
              : SizedBox())),
      text(transaksiC.transaksies.toString())
    ]);
  }
}

class TransaksiKas extends StatelessWidget {
  final TransaksiModel model = Get.arguments;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 10;
    return Container(
      width: width,
      // padding: EdgeInsets.only(left: 20.0, right: 20),
      child: Obx(() => ListView.builder(
          padding: EdgeInsets.symmetric(),
          scrollDirection: Axis.vertical,
          itemCount: transaksiC.transaksies.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return TransaksiList(dataTransaksi: transaksiC.transaksies[index]);
          })),
    );
  }
}

class TransaksiList extends StatelessWidget {
  const TransaksiList({required this.dataTransaksi});
  final TransaksiModel dataTransaksi;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: Get.width * 0.1,
                child: Column(
                  children: <Widget>[
                    text("${dataTransaksi.jumlah}", fontSize: textSizeSMedium),
                    text("${dataTransaksi.jumlah}",
                        fontSize: textSizeLargeMedium,
                        textColor: appStore.textSecondaryColor),
                  ],
                ),
              ),
              Container(
                decoration: boxDecoration(
                    radius: Get.width * 0.06, bgColor: mkColorPrimary50),
                // margin: EdgeInsets.only(left: 16, right: 16),
                width: Get.width * 0.06,
                height: Get.width * 0.06,
                child: Icon(
                  Icons.call_received,
                  size: Get.width * 0.04,
                  color: mkColorPrimary,
                ),
                // padding: EdgeInsets.all(width / 30),
              ),
              Container(
                width: Get.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text("${dataTransaksi.jumlah}",
                        textColor: appStore.textPrimaryColor,
                        fontSize: textSizeMedium,
                        fontFamily: fontSemibold),
                    text("${dataTransaksi.jumlah}", fontSize: textSizeSMedium)
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Get.width * 0.25,
                child: text("+ RP ${dataTransaksi.jumlah}" + ".000.000",
                    textColor: appStore.textSecondaryColor,
                    fontSize: textSizeMedium,
                    isLongText: true,
                    fontFamily: fontSemibold),
              )
            ],
          ),
        ),
        Divider(height: 0.5)
      ],
    );
  }
}
