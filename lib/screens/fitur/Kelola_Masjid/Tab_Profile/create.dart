// import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';

import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirmDialog.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Profile/Form_Profile.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
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
