import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/inventaris/controllers/inventarisController.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
import 'package:mosq/modules/kegiatan/views/card.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

class TabKegiatan extends StatelessWidget {
  const TabKegiatan(this.model);
  final MasjidModel model;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: SingleChildScrollView(
          child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(),
              scrollDirection: Axis.vertical,
              itemCount: kegiatanC.kegiatans.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return KegiatanCard(
                  dataKegiatan: kegiatanC.kegiatans[index],
                );
              })),
        ),
      ),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 15, bottom: 15),
          child: Obx(() => masjidC.myMasjid.value
              ? FloatingActionButton(
                  child: Icon(
                    Icons.edit,
                    color: mkWhite,
                  ),
                  // child: PopupMenuButton(

                  //     itemBuilder: (context) => [
                  //           PopupMenuItem(
                  //             child: Text("First"),
                  //             value: 1,
                  //           ),
                  //           PopupMenuItem(
                  //             child: Text("Second"),
                  //             value: 2,
                  //           )
                  //         ]),
                  backgroundColor: mkColorPrimary,
                  onPressed: () {
                    Get.toNamed(RouteName.new_kegiatan,
                        arguments: KegiatanModel(dao: model.kegiatanDao));
                  })
              : SizedBox())),
    ]);
  }
}
