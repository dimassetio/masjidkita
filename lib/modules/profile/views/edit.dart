// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/profile/models/masjid_model.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/modules/profile/views/Form_Profile.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';

class EditProfile extends StatelessWidget {
  static const tag = '/FormProfile';
  GlobalKey<FormState> formKey = GlobalKey();
  MasjidModel model = Get.arguments as MasjidModel;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                manMasjidC.checkControllers()
                    ? showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) => ConfirmDialog(),
                      )
                    : finish(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(
              context,
              model.nama ?? mk_add_masjid,
            ),
            // actions: actions,
          ),
          // appBar: appBar(context, manMasjidC.deMasjid.nama ?? mk_add_masjid),
          body: FormMasjid()),
    );
  }
}
