import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';

import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main.dart';
import 'package:get/get.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';

class InventarisCard extends StatelessWidget {
  const InventarisCard({
    required this.inventaris,
  });
  final InventarisModel inventaris;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: () async {
        inventarisC.inventaris = inventaris;
        Get.toNamed(RouteName.detail_inventaris, arguments: inventaris);
      },
      title: text(
        inventaris.nama,
        textColor: appStore.textPrimaryColor,
        fontFamily: fontBold,
        fontSize: textSizeLargeMedium,
      ),
      subtitle: text(
        "kondisi : ${inventaris.kondisi}",
        textColor: appStore.textSecondaryColor,
        fontSize: textSizeMedium,
      ),
      // leading: CircleAvatar(
      //     backgroundColor: mkCat1,
      //     child: Icon(
      //       Icons.call_received,
      //     )),
      trailing: CircleAvatar(
        backgroundColor: mkColorPrimary,
        child: text(inventaris.jumlah.toString(),
            textColor: mkWhite,
            fontSize: textSizeSMedium,
            fontFamily: fontBold),
      ),
    );
  }
}
