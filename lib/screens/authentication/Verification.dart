import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';

import '../../main.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  // Timer? _timer;

  String email = Get.arguments[0];
  String password = Get.arguments[1];

  // setTimer() {
  //   _timer = new Timer.periodic(
  //     Duration(seconds: 1),
  //     (Timer timer) {
  //       if (_count == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         // setState(() {
  //         _count = _count - 1;
  //         // });
  //       }
  //     },
  //   );
  // }

  // int _count = 30;
  // var _countx = 30.obs;
  // int get _count => _countx.value;
  // set _count(int value) => this._countx.value = value;

  @override
  void initState() {
    if (authController.lastVerif == 0) {
      authController.setTimer();
    }
    // authController.timer.isActive ? authController.setTimer() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mkWhite,
          elevation: 0,
          leadingWidth: Get.width,
          leading: TextButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.chevron_left),
              label: Text('Kembali'))),
      body: WillPopScope(
        onWillPop: () async {
          try {
            authController.signOut();
            return true;
          } catch (e) {
            return false;
          }
        },
        child: Container(
          padding: EdgeInsets.all(16),
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // width: Get.width,
                  height: 300,
                  // color: mkColorAccent,
                  margin: EdgeInsets.symmetric(horizontal: 48),
                  child: SvgPicture.asset(
                    mk_verif,
                    fit: BoxFit.contain,
                  ),
                ),
                // 2.height,
                text(
                  "Verifikasi",
                  textColor: mkColorPrimary,
                  fontSize: textSizeLarge,
                  fontFamily: fontBold,
                ),
                16.height,
                text(
                    "Kami telah mengirimkan pesan kepada email anda. Silahkan klik link yang tertera dan kembali ke halaman ini untuk melanjutkan.",
                    isLongText: true,
                    isCentered: true,
                    fontSize: textSizeMedium),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        TextButton(
                            onPressed: () async {
                              await authController.sendVerif(auth.currentUser);

                              // Get.dialog(
                              //     Container(child: text(_count.toString())));
                              // Get.defaultDialog(
                              //     title: authController.lastVerif.toString());
                            },
                            child: text('Resend', textColor: mkColorPrimary)),
                        Obx(
                          () => text("( 00:${authController.lastVerif} )",
                              fontSize: textSizeSMedium),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          authController.signIn(email, password);
                          // String? email = authController.firebaseUser.value.email;
                          // if (auth.currentUser?.emailVerified == true) {
                          //   Get.snackbar("Email Verified", email ?? '');
                          // }
                          // // auth.currentUser?.emailVerified ?? false
                          // // authController.firebaseUser.value.emailVerified
                          // else
                          //   Get.snackbar("DURUNG COK", email ?? '');
                        },
                        child: text(mk_lanjut, textColor: mkColorPrimary)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
