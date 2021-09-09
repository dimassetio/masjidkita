import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:get/get.dart';
import 'package:mosq/main.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/src/extensions/int_extensions.dart';

class KegiatanCard extends StatelessWidget {
  KegiatanCard({
    Key? key,
    required this.dataKegiatan,
    // required this.openContainer,
  }) : super(key: key);

  // final VoidCallback? openContainer;

  final KegiatanModel dataKegiatan;
  var width = Get.width;
  // var isFull = false.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: boxDecoration(
        radius: 16,
        showShadow: true,
      ),
      width: width,
      child: InkWell(
        onTap: () async {
          Get.toNamed(RouteName.detail_kegiatan, arguments: dataKegiatan);
          // toast('Go to Kegiatan detail');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Container(
                height: width / 1.7,
                width: width,
                child: dataKegiatan.photoUrl.isEmptyOrNull
                    ? Image.asset(mk_contoh_image, fit: BoxFit.cover)
                    : CachedNetworkImage(
                        placeholder: placeholderWidgetFn() as Widget Function(
                            BuildContext, String)?,
                        imageUrl: dataKegiatan.photoUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text(dataKegiatan.nama,
                      textColor: appStore.textPrimaryColor,
                      fontSize: textSizeLargeMedium,
                      fontFamily: fontMedium),
                  4.height,
                  text(
                    dataKegiatan.deskripsi,
                    maxLine: 2,
                    fontSize: textSizeSMedium,
                  ),
                  //  Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Divider(),
                  //           TextIcon(
                  //             prefix: Icon(
                  //               Icons.calendar_today,
                  //               size: textSizeMedium,
                  //             ),
                  //             text: dateFormatter(dataKegiatan.tanggal),
                  //             textStyle: primaryTextStyle(
                  //                 size: textSizeSMedium.toInt()),
                  //           ),
                  //           TextIcon(
                  //             prefix: Icon(
                  //               Icons.access_time,
                  //               size: textSizeMedium,
                  //             ),
                  //             text: timeFormatter(dataKegiatan.tanggal),
                  //             textStyle: primaryTextStyle(
                  //                 size: textSizeSMedium.toInt()),
                  //           ),
                  //         ],
                  //       )
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextIcon(
                      text: "view more",
                      textStyle:
                          primaryTextStyle(size: textSizeSMedium.toInt()),
                      suffix: Icon(
                        Icons.chevron_right,
                        size: textSizeMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
