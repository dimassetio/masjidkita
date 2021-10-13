import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/transaksi/views/list_transaksi.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/modules/kas/buku/views/slider_kas.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../main.dart';

class TMTabKas extends StatelessWidget {
  const TMTabKas(this.model);
  final MasjidModel model;

  @override
  Widget build(BuildContext context) {
    var width = Get.width - 10;
    var height = Get.height;
    return Stack(children: [
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
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
                    Text('Transaksi',
                        style: TextStyle(fontSize: 18, fontFamily: fontMedium)),
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteName.transaksi, arguments: model);
                      },
                      child: Row(
                        children: [
                          Text(mk_lbl_show_all,
                              style: secondaryTextStyle(color: mkColorPrimary)),
                          4.width,
                          Icon(Icons.keyboard_arrow_right,
                              color: mkColorPrimary, size: 16),
                        ],
                      ).paddingOnly(left: 16, right: 16),
                    )
                  ],
                ),
              ),
              Obx(
                () => TransaksiKas(
                  transaksies: transaksiC.transaksies,
                ),
              )
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
    ]);
  }
}
