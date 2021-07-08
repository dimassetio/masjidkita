import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:masjidkita/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import '../../main.dart';

class T5Verification extends StatefulWidget {
  static String tag = '/T5Verification';

  @override
  T5VerificationState createState() => T5VerificationState();
}

class T5VerificationState extends State<T5Verification> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(mk_login,
                      width: width / 2.5, height: width / 2.5),
                  SizedBox(height: 30),
                  text(mk_lbl_verification,
                      textColor: appStore.textPrimaryColor,
                      fontFamily: fontBold,
                      fontSize: 22.0),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 16),
                    child: text(mk_note_verification,
                        textColor: mkTextColorSecondary,
                        fontFamily: fontMedium,
                        fontSize: textSizeMedium,
                        maxLine: 2,
                        isCentered: true),
                  ),
                  Container(
                    margin: EdgeInsets.all(24),
                    decoration: boxDecoration(
                        bgColor: appStore.scaffoldBackground,
                        showShadow: true,
                        radius: 4),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: 10),
                        PinEntryTextField(fields: 4, fontSize: textSizeNormal),
                        SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            // T5SetPassword().launch(context);
                            Get.toNamed(RouteName.dashboard);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: width / 8,
                            child: text(mk_continue,
                                textColor: mkWhite, isCentered: true),
                            decoration: boxDecoration(
                                bgColor: mkColorPrimary, radius: 8),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      toast(mk_resend);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      child: text(mk_resend,
                          textColor: mkColorPrimary,
                          fontSize: textSizeLargeMedium,
                          fontFamily: fontSemibold),
                    ),
                  )
                ],
              ),
            ),
          ),
          TopBar()
        ],
      ),
    );
  }
}
