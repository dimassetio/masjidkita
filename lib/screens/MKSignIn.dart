import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:masjidkita/screens/utils/MKWidget.dart';

import '../../main.dart';
// import 'T5Dialog.dart';

class T5SignIn extends StatefulWidget {
  static String tag = '/T5SignIn';

  @override
  T5SignInState createState() => T5SignInState();
}

class T5SignInState extends State<T5SignIn> {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(mkWhite);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // changeStatusColor(appStore.appBarColor!);
    final AuthController authController = Get.find();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(mk_login, width: width / 2.5, height: width / 2.5),
              text(mkapp_name,
                  textColor: appStore.textPrimaryColor,
                  fontFamily: fontBold,
                  fontSize: 22.0),
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
                    EditText(
                      mController: authController.email,
                      hint: "Email",
                      textColor: mkColorPrimary,
                      isPassword: false,
                    ),
                    SizedBox(height: 16),
                    EditText(
                        mController: authController.password,
                        hint: mk_hint_password,
                        isSecure: true),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        toast(mk_forgot_pswd);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        child: text(mk_forgot_pswd,
                            textColor: mkColorPrimary,
                            fontSize: textSizeMedium,
                            fontFamily: fontSemibold),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // toast("Sign in clicked");
                              // Get.toNamed(RouteName.dashboard);
                              authController.signIn();
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 16),
                              alignment: Alignment.center,
                              height: width / 8,
                              child: text(mk_sign_in,
                                  textColor: mkWhite, isCentered: true),
                              decoration: boxDecoration(
                                  bgColor: mkColorPrimary, radius: 8),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.sign_up);
                  },
                  child: text(mk_register,
                      textColor: mkColorPrimary, fontSize: textSizeMedium))
            ],
          ),
        ),
      ),
    );
  }
}
