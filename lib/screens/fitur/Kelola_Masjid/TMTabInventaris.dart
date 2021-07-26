import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
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
    Get.put(InventarisController());
    final InventarisController inventarisC = Get.find();
    return Container(
      child: SingleChildScrollView(
        child: inventarisC.inventariss.isEmpty
            ? Container(
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteName.new_inventaris);
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) => CustomDelete(),
                    // );
                    // CustomDelete();
                    // File file = await getImage();
                    // imagePath =
                    //     await DatabaseService.uploadImage(file);
                  },
                  child: Text("Tambahkan inventaris",
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
    );
  }
}
