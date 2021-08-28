// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/profile/views/Form_Profile.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class NewProfile extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
                // manMasjidC.checkControllers()
                //     ? showDialog(
                //         context: Get.context!,
                //         builder: (BuildContext context) => ConfirmDialog(),
                //       )
                //     : finish(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(
              context,
              mk_add_masjid,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, manMasjidC.deMasjid.nama ?? mk_add_masjid),
          body: FormMasjid()),
    );
  }
}
