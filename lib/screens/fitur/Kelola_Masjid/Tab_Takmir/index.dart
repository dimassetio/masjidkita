import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/inventarisController.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/models/takmir.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../main.dart';

class TMTabTakmir extends StatelessWidget {
  TakmirModel? emptyTakmir;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: SingleChildScrollView(
          child: Obx(
            () => ListView.builder(
                padding: EdgeInsets.symmetric(),
                scrollDirection: Axis.vertical,
                itemCount: takmirC.takmirs.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return TakmirCard(
                    dataTakmir: takmirC.takmirs[index],
                  );
                }),
          ),
        ),
      ),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 15, bottom: 15),
          child: Obx(() => manMasjidC.myMasjid.value
              ? FloatingActionButton(
                  child: Icon(
                    Icons.edit,
                    color: mkWhite,
                  ),
                  backgroundColor: mkColorPrimary,
                  onPressed: () {
                    Get.toNamed(RouteName.new_takmir);
                  })
              : SizedBox())),
    ]);
  }
}

class TakmirCard extends StatelessWidget {
  const TakmirCard({required this.dataTakmir});
  final TakmirModel dataTakmir;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(dataTakmir.id!),
      direction: manMasjidC.myMasjid.value
          ? DismissDirection.horizontal
          : DismissDirection.none,
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          Get.toNamed(RouteName.edit_takmir, arguments: dataTakmir);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          // toast("Delete data");
          return await showDialog(
              context: context,
              builder: (BuildContext context) => CustomDelete(
                    titleName: 'Takmir',
                    subtitleName: dataTakmir.nama!,
                  ));
        }
      },
      onDismissed: (direction) async {
        try {
          takmirC.delete(dataTakmir, manMasjidC.deMasjid.id!);
        } catch (e) {
          toast('Error Delete Data');
          rethrow;
        }
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            color: appStore.scaffoldBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      // backgroundImage:
                      //     CachedNetworkImageProvider(mk_net_img),
                      radius: MediaQuery.of(context).size.width * 0.08,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(dataTakmir.nama,
                            textColor: appStore.textPrimaryColor,
                            fontFamily: fontMedium),
                        SizedBox(width: 4),
                        text(dataTakmir.jabatan,
                            textColor: appStore.textSecondaryColor),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
