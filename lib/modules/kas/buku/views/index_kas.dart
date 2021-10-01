import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/transaksi/views/list_transaksi.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/modules/kas/buku/views/slider_kas.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../main.dart';

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
                    Text('Transaksi',
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
