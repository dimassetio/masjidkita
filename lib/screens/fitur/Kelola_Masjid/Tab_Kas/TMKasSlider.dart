import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/MasjidCarouselSlider.dart';

import '../../../../../main.dart';

// ignore: must_be_immutable
class TMKasSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var mSliderList = [
      "0",
      "1",
      "2",
    ];

    return MasjidCarouselSlider(
      aspectRatio: 2 / 1,
      viewportFraction: 0.9,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      items: mSliderList.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              // height: 400,
              width: width,
              decoration: boxDecoration(bgColor: mkColorPrimary, radius: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      text("Nama Kas",
                          textColor: mkWhite,
                          fontSize: textSizeLarge,
                          fontFamily: fontBold),
                      text(
                        "Masjid Al-Hooda",
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
                            text("Rp. 5.xxx.xxx",
                                textColor: mkWhite, fontSize: textSizeNormal)
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
                            text("Rp. 5.xxx.xxx",
                                textColor: mkWhite, fontSize: textSizeNormal)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
