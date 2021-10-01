import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';

class TransaksiKas extends StatelessWidget {
  TransaksiKas({required this.transaksies, this.length = 5});
  // final TransaksiModel model = Get.arguments;
  final List<TransaksiModel> transaksies;
  int length = 5;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 10;
    return Container(
      width: width,
      // padding: EdgeInsets.only(left: 20.0, right: 20),
      child: ListView.builder(
          padding: EdgeInsets.symmetric(),
          scrollDirection: Axis.vertical,
          itemCount: transaksies.length < 5 ? transaksies.length : length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return TransaksiList(dataTransaksi: transaksies[index]);
          }),
    );
  }
}

class TransaksiList extends StatelessWidget {
  const TransaksiList({required this.dataTransaksi});
  final TransaksiModel dataTransaksi;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Get.toNamed(RouteName.detail_transaksi, arguments: dataTransaksi),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: boxDecoration(
                      radius: Get.width * 0.06,
                      bgColor: dataTransaksi.tipeTransaksi == 10
                          ? mkGreen.withOpacity(0.3)
                          : mkRed.withOpacity(0.3)),
                  // margin: EdgeInsets.only(left: 16, right: 16),
                  width: Get.width * 0.06,
                  height: Get.width * 0.06,
                  child: Icon(
                    dataTransaksi.tipeTransaksi == 10
                        ? Icons.call_received
                        : Icons.call_made,
                    size: Get.width * 0.04,
                    color: dataTransaksi.tipeTransaksi == 10 ? mkGreen : mkRed,
                  ),
                  // padding: EdgeInsets.all(width / 30),
                ),
                Container(
                  width: Get.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text("${dataTransaksi.kategori}",
                          textColor: appStore.textPrimaryColor,
                          fontSize: textSizeMedium,
                          fontFamily: fontSemibold),
                      text(dateFormatter(dataTransaksi.tanggal),
                          fontSize: textSizeSMedium)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.35,
                  child:
                      // text("${dataTransaksi.fromKas}",
                      text("${currencyFormatter(dataTransaksi.jumlah)}",
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
      ),
    );
  }
}
