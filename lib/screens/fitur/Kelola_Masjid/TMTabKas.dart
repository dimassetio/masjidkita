import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/fitur/Detail_Masjid/KasSlider.dart';

import '../../../../main.dart';

class TMTabKas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = Get.width - 10;
    var height = Get.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          KasSlider(),
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
          TransaksiKas(),
        ],
      ),
    );
  }
}

class TransaksiKas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 10;
    return Container(
      width: width,
      // padding: EdgeInsets.only(left: 20.0, right: 20),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 50,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: width * 0.1,
                        child: Column(
                          children: <Widget>[
                            text("Des", fontSize: textSizeSMedium),
                            text("$index",
                                fontSize: textSizeLargeMedium,
                                textColor: appStore.textSecondaryColor),
                          ],
                        ),
                      ),
                      Container(
                        decoration: boxDecoration(
                            radius: width * 0.06, bgColor: mkColorPrimary50),
                        // margin: EdgeInsets.only(left: 16, right: 16),
                        width: width * 0.06,
                        height: width * 0.06,
                        child: Icon(
                          Icons.call_received,
                          size: width * 0.04,
                          color: mkColorPrimary,
                        ),
                        // padding: EdgeInsets.all(width / 30),
                      ),
                      Container(
                        width: width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(
                                "Nama Pengeluaran fs dhn jfkns  ksdfkjsdn sd fjksdhf sdnfk ",
                                textColor: appStore.textPrimaryColor,
                                fontSize: textSizeMedium,
                                fontFamily: fontSemibold),
                            text("Nama Buku Kas", fontSize: textSizeSMedium)
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.25,
                        child: text("+ RP $index" + ".000.000",
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
          }),
    );
  }
}
