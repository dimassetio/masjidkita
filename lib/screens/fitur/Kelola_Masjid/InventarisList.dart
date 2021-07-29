import 'package:flutter/material.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/main.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';

class InventarisCard extends StatelessWidget {
  final InventarisModel inventaris;
  InventarisCard(
    this.inventaris,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          color: appStore.scaffoldBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await inventarisC
                      .getInventarisModel(inventaris.inventarisID ?? "");
                  Get.toNamed(RouteName.detail_inventaris);
                },
                child: Row(
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
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
