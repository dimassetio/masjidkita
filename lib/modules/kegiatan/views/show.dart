import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/widgets/DeleteDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailKegiatan extends StatelessWidget {
  KegiatanModel model = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: appBarTitleWidget(context, model.nama ?? 'Detail Kegiatan'),
        backgroundColor: appStore.appBarColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 15, left: 2, right: 2),
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: Get.width,
                    height: Get.width / 1.777,
                    child: !model.photoUrl.isEmptyOrNull
                        ? CachedNetworkImage(
                            placeholder: placeholderWidgetFn() as Widget
                                Function(BuildContext, String)?,
                            imageUrl: "${model.photoUrl}",
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(mk_no_image),
                  ),
                  16.height,
                  text("${model.nama}",
                      fontFamily: fontBold, fontSize: textSizeLargeMedium),
                  16.height,
                  ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 10),
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.all(10),
                    title: Text(
                      mk_lbl_deskripsi,
                      style: TextStyle(
                          fontSize: textSizeLargeMedium, fontFamily: fontBold),
                    ),
                    children: <Widget>[
                      text(model.deskripsi ?? "-",
                          fontSize: textSizeMedium, isLongText: true)
                    ],
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 10),
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.all(10),
                    expandedAlignment: Alignment.topLeft,
                    title: Text(
                      mk_lbl_waktu_tempat,
                      style: TextStyle(
                          fontSize: textSizeLargeMedium, fontFamily: fontBold),
                    ),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                        ),
                        title: text(dateFormatter(model.tanggal),
                            fontSize: textSizeSMedium),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.access_time,
                        ),
                        title: text(
                          timeFormatter(model.tanggal),
                          fontSize: textSizeMedium,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.pin_drop,
                        ),
                        title: text(
                          model.tempat ?? "-",
                          fontSize: textSizeMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 15, bottom: 15),
              child: Obx(
                () => masjidC.myMasjid.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                              heroTag: 'btn_edit',
                              child: Icon(
                                Icons.edit,
                                color: mkWhite,
                              ),
                              backgroundColor: mkGreen,
                              onPressed: () {
                                Get.toNamed(RouteName.edit_kegiatan,
                                    arguments: model);
                              }),
                          16.height,
                          FloatingActionButton(
                            heroTag: 'btn_delete',
                            onPressed: () async {
                              var res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDelete(
                                        titleName: 'Kegiatan',
                                        subtitleName: model.nama ?? "",
                                      ));
                              if (res == true) {
                                kegiatanC.deleteKegiatan(model);
                              }
                            },
                            child: Icon(
                              Icons.delete,
                              color: mkWhite,
                            ),
                            backgroundColor: mkRed,
                          ),
                        ],
                      )
                    : SizedBox(),
              )),
        ],
      ),
    );
  }
}
