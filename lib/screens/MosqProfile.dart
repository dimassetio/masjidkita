import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import 'utils/MKConstant.dart';

class MosqProfile extends StatelessWidget {
  static var tag = "/T1Profile";
  final AuthController authC = Get.find();

  Widget counter(String counter, String counterName) {
    return Column(
      children: <Widget>[
        profile(counter),
        text(counterName,
            textColor: appStore.textPrimaryColor,
            fontSize: textSizeMedium,
            fontFamily: fontMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    final profileImg = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: FractionalOffset.center,
      child: CircleAvatar(
        // backgroundImage: CachedNetworkImageProvider(mk_net_img),
        radius: 50,
      ),
    );
    final profileContent = Container(
      margin: EdgeInsets.only(top: 55.0),
      decoration: boxDecoration(
          bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            text(authC.userModel.value.name ?? "Nama",
                textColor: appStore.textPrimaryColor,
                fontSize: textSizeNormal,
                fontFamily: fontMedium),
            text(authC.userModel.value.email ?? "Email",
                textColor: mkColorPrimary,
                fontSize: textSizeMedium,
                fontFamily: fontMedium),
            Padding(
              padding: EdgeInsets.all(16),
              child: Divider(color: mkColorPrimaryDark, height: 0.5),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     counter("100", "t1_lbl_document"),
            //     counter("50", "Photos"),
            //     counter("60", "Videos"),
            //   ],
            // ),
            // SizedBox(height: 16),
          ],
        ),
      ),
    );

    final authController = Get.find<AuthController>();
    final width = Get.width / 10;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15, left: 2, right: 2),
        physics: ScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration:
                          boxDecoration(showShadow: true, radius: width),
                      width: width,
                      height: width,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: mkTextColorPrimary,
                        ),
                      ),
                      // height: ,
                    ),
                    profileContent,
                    profileImg
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: boxDecoration(
                    bgColor: appStore.scaffoldBackground,
                    radius: 10,
                    showShadow: true),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8),
                      rowHeading("Info Personal"),
                      SizedBox(height: 16),
                      profileText(authC.userModel.value.name ?? "Nama"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: view(),
                      ),
                      SizedBox(height: 8),
                      profileText("Male"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: view(),
                      ),
                      SizedBox(height: 8),
                      profileText("t1_profile_address", maxline: 2),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: boxDecoration(
                    bgColor: appStore.scaffoldBackground,
                    radius: 10,
                    showShadow: true),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8),
                      rowHeading("Info Kontak"),
                      SizedBox(height: 16),
                      profileText("+91 36982145"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: view(),
                      ),
                      SizedBox(height: 8),
                      profileText(authC.userModel.value.email ?? "Email"),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: boxDecoration(
                    bgColor: appStore.scaffoldBackground,
                    radius: 10,
                    showShadow: true),
                child: GestureDetector(
                  onTap: () {
                    authController.signOut();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: text("Log Out"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
