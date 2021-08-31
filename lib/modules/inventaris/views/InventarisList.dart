import 'package:flutter/material.dart';
import 'package:mosq/modules/inventaris/controllers/inventarisController.dart';
import 'package:mosq/integrations/controllers.dart';

import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main.dart';
import 'package:get/get.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKConstant.dart';

class InventarisCard extends StatelessWidget {
  const InventarisCard({
    required this.inventaris,
  });
  final InventarisModel inventaris;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            inventarisC.inventaris = inventaris;
            Get.toNamed(RouteName.detail_inventaris, arguments: inventaris);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            color: appStore.scaffoldBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // GestureDetector(
                //   onTap: () async {
                //     await inventarisC
                //         .getInventarisModel(inventaris.inventarisID ?? "");
                //     Get.toNamed(RouteName.detail_inventaris);
                //   },
                Row(
                  children: <Widget>[
                    // CircleAvatar(
                    //   backgroundImage:
                    //       AssetImage('images/widgets/to-do-list.png'),
                    //   // CachedNetworkImageProvider(mk_net_img),
                    //   radius: MediaQuery.of(context).size.width * 0.08,
                    // ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(inventaris.nama ?? "Tidak ada",
                            textColor: appStore.textPrimaryColor,
                            fontFamily: fontMedium),
                        SizedBox(width: 4),
                        text("Kondisi ${inventaris.kondisi}",
                            textColor: appStore.textSecondaryColor),
                        text("Jumlah ${inventaris.jumlah}",
                            textColor: appStore.textSecondaryColor),
                      ],
                    )
                  ],
                ),
                // ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
