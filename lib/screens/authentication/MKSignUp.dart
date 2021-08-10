import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';

import '../../main.dart';

class T5SignUp extends StatefulWidget {
  static String tag = '/T5SignUp';

  @override
  T5SignUpState createState() => T5SignUpState();
}

class T5SignUpState extends State<T5SignUp> {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);

    var width = Get.width;
    var height = Get.height;
    final AuthController authController = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          alignment: Alignment.center,
          color: appStore.scaffoldBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(mk_login, width: width / 2.5, height: width / 2.5),
              text(mk_heading_login,
                  textColor: appStore.textPrimaryColor,
                  fontFamily: fontBold,
                  fontSize: 22.0),
              Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 16),
                child: text(mk_note_registration,
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
                    radius: 4.0),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: mkViewColor, width: 0.5)),
                      child: Row(
                        children: <Widget>[
                          // CountryCodePicker(onChanged: print, showFlag: true),
                          Expanded(
                            child: TextFormField(
                              controller: authController.name,
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                  fontSize: textSizeLargeMedium,
                                  fontFamily: fontRegular),
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: "Name",
                                hintStyle: TextStyle(color: mkTextColorThird),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: mkViewColor, width: 0.5)),
                      child: Row(
                        children: <Widget>[
                          // CountryCodePicker(onChanged: print, showFlag: true),
                          Expanded(
                            child: TextFormField(
                              controller: authController.email,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontSize: textSizeLargeMedium,
                                  fontFamily: fontRegular),
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: mk_lbl_email,
                                hintStyle: TextStyle(color: mkTextColorThird),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: mkViewColor, width: 0.5)),
                      child: Row(
                        children: <Widget>[
                          // CountryCodePicker(onChanged: print, showFlag: true),
                          Expanded(
                            child: TextFormField(
                              obscureText: true,
                              controller: authController.password,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                  fontSize: textSizeLargeMedium,
                                  fontFamily: fontRegular),
                              decoration: InputDecoration(
                                // icon: Icon(Icons.lock),
                                counterText: "",
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: mk_lbl_password,
                                hintStyle: TextStyle(color: mkTextColorThird),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        // T5Verification().launch(context);
                        authController.signUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: width / 8,
                        child: text(mk_continue,
                            textColor: mkWhite, isCentered: true),
                        decoration:
                            boxDecoration(bgColor: mkColorPrimary, radius: 8.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
