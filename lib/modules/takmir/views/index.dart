import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/inventarisController.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/takmir/models/takmir_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

class TMTabTakmir extends StatelessWidget {
  const TMTabTakmir(this.model);
  final MasjidModel model;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: SingleChildScrollView(
          child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(),
              scrollDirection: Axis.vertical,
              itemCount: takmirC.takmirs.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return TakmirCard(
                  dataTakmir: takmirC.takmirs[index],
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
    return Column(children: [
      Dismissible(
          key: Key(dataTakmir.id!),
          direction: masjidC.myMasjid.value
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
                        subtitleName: dataTakmir.nama ?? "",
                      ));
            }
          },
          onDismissed: (direction) async {
            try {
              // takmirC.delete(dataTakmir, masjidC.deMasjid.id!);
            } catch (e) {
              toast('Error Delete Data');
              rethrow;
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
              backgroundImage: AssetImage(mk_profile_pic),
              foregroundImage:
                  CachedNetworkImageProvider(dataTakmir.photoUrl ?? ""),
              backgroundColor: mkColorPrimary,
              radius: MediaQuery.of(context).size.width * 0.08,
            ),
            onTap: () =>
                Get.toNamed(RouteName.detail_takmir, arguments: dataTakmir),
            title: text(dataTakmir.nama,
                textColor: appStore.textPrimaryColor, fontFamily: fontMedium),
            subtitle: text(dataTakmir.dao.toString(),
                textColor: appStore.textSecondaryColor),
          )),
      Divider()
    ]);
  }
}
