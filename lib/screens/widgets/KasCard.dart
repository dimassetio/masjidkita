import 'package:flutter/material.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
// import 'package:mosq/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/screens/utils/Style.dart';

Widget KasCard({
  required String visaTitle,
  required Color color,
  required String creditNumber,
  required String expire,
  required String name,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 16),
    decoration:
        boxDecoration(radius: 20, bgColor: mkColorPrimary, showShadow: true),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  width: 40,
                  height: 40,
                  image: AssetImage('images/widgets/opchip.png'),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    visaTitle,
                    style: boldTextStyle(size: 22, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            FittedBox(
              child: Text(
                "**** **** **** " + creditNumber,
                style: boldTextStyle(
                    size: 20,
                    color: Colors.white,
                    letterSpacing: 3,
                    wordSpacing: 2),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      'CARDHOLDER',
                      style: secondaryTextStyle(color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FittedBox(
                    child: Text(
                      name,
                      style: primaryTextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      'EXPIRES',
                      style: secondaryTextStyle(color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FittedBox(
                    child: Text(
                      expire,
                      style: primaryTextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(),
            ],
          ),
        ),
      ],
    ),
  );
}
