import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';

import 'ConfirmLogout.dart';

class UserTopBar extends StatelessWidget {
  const UserTopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        margin: EdgeInsets.all(16),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  authController.isLoggedIn.value
                      ? Get.toNamed(RouteName.profile)
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) => CekLogin());
                },
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      // backgroundImage:
                      //     CachedNetworkImageProvider(mk_net_img),
                      radius: 25,
                    ),
                    SizedBox(width: 16),
                    text(authController.userModel.value.name ?? "Guest",
                        textColor: mkWhite,
                        fontSize: textSizeNormal,
                        fontFamily: fontMedium)
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  authController.isLoggedIn.value
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) => ConfirmLogout())
                      : Get.toNamed(RouteName.sign_in);
                  // print("P");
                },
                icon: Icon(authController.isLoggedIn.value
                    ? Icons.logout
                    : Icons.login),
                color: mkWhite,
              )
              // GestureDetector(
              //   onTap: () {
              //     toast("xcvxcxv ");
              //     Get.toNamed(RouteName.sign_in);
              //   },
              // //   child: Icon(Icons.login, size: 25, color: mkWhite),
              // )
            ],
          ),
        ));
  }
}
