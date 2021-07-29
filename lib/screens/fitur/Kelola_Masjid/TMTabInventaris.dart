import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/services/database.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'InventarisList.dart';

import '../../../../main.dart';

class TMTabInventaris extends StatelessWidget {
  final InventarisModel inventaris;
  TMTabInventaris(
    this.inventaris,
  );
  @override
  Widget build(BuildContext context) {
    final InventarisController inventarisC = Get.find();
    return Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Obx(
            () => inventarisC.inventariss.isEmpty
                ? Container(
                    height: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        inventarisC.tesBind();
                        // Get.toNamed(RouteName.new_inventaris);
                      },
                      child: Text(inventarisC.inventariss.length.toString(),
                          style: boldTextStyle(size: 18, color: Colors.white)),
                    ).center(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(),
                    scrollDirection: Axis.vertical,
                    itemCount: inventarisC.inventariss.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (_, index) {
                      return InventarisCard(inventarisC.inventariss[index]);
                    }),
          ),
          FloatingActionButton.extended(
              heroTag: '1',
              // heroTag: '5',
              label: Text(
                "Add",
                style: primaryTextStyle(color: Colors.white),
              ),
              backgroundColor: mkColorPrimary,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                // CustomDelete();
                Get.toNamed(RouteName.new_inventaris);
              }),
        ],
      )),
    );
  }
}
