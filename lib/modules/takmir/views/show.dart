import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';

class DetailTakmir extends StatelessWidget {
  TakmirModel dataTakmir = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // changeStatusColor(appStore.appBarColor!);
    final profileImg = Container(
      // margin: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: FractionalOffset.center,
      child: CircleAvatar(
        backgroundImage: AssetImage(mk_profile_pic),
        foregroundImage:
            CachedNetworkImageProvider(dataTakmir.photoUrl ?? mk_net_img),
        backgroundColor: mkColorPrimary,
        radius: 100,
      ),
    );
    final profileContent = Container(
      width: Get.width,
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.only(top: 110, bottom: 25),
      decoration: boxDecoration(
          bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
      child: Column(
        children: <Widget>[
          text(dataTakmir.nama ?? "Nama",
              textColor: appStore.textPrimaryColor,
              fontSize: textSizeNormal,
              fontFamily: fontMedium),
          Divider(),
          text(dataTakmir.jabatan ?? "Jabatan",
              textColor: mkColorPrimary,
              fontSize: textSizeMedium,
              fontFamily: fontMedium),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appStore.appBarColor,
        leading: BackButton(),
        title: appBarTitleWidget(context, 'Detail Takmir'),
        // actions: actions,
      ),
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
                    profileContent,
                    profileImg,
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
