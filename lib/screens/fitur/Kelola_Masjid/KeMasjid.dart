import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Home.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';

class KeMasjid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(mkWhite);
    return Scaffold(
        backgroundColor: mkWhite,
        body: Obx(
            () => authController.isLoggedIn.value ? TMMasjid() : CekLogin()));
  }
}
