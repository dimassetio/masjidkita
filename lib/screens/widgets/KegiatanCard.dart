import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kegiatan/models/kegiatan_model.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:get/get.dart';
import 'package:mosq/main.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/src/extensions/int_extensions.dart';

class KegiatanCard extends StatelessWidget {
  KegiatanCard({
    Key? key,
    required this.width,
    required this.dataKegiatan,
    // required this.openContainer,
  }) : super(key: key);

  // final VoidCallback? openContainer;
  final double width;
  final KegiatanModel dataKegiatan;

  var isFull = false.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      // openBuilder: (context, openContainer) => const DetailsPage(),
      margin: EdgeInsets.all(16),
      decoration: boxDecoration(
          radius: 16, showShadow: true, bgColor: appStore.scaffoldBackground),
      width: width,
      child: GestureDetector(
        // onTap: () => toast("Go To Kegiatan Detail"),
        onTap: () async {
          // Get.toNamed(RouteName.detail_kegiatan);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: dataKegiatan.photoUrl.isEmptyOrNull
                  ? Image.asset(mk_contoh_image,
                      height: 180, width: width, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      placeholder: placeholderWidgetFn() as Widget Function(
                          BuildContext, String)?,
                      imageUrl: dataKegiatan.photoUrl!,
                      fit: BoxFit.cover,
                      height: 180,
                      width: width,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    text(dataKegiatan.nama,
                        textColor: appStore.textPrimaryColor,
                        fontSize: textSizeLargeMedium,
                        fontFamily: fontMedium),
                    4.height,
                    text(dataKegiatan.deskripsi,
                        maxLine: 2,
                        fontSize: textSizeSMedium,
                        isLongText: isFull.value),
                    isFull.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              TextIcon(
                                prefix: Icon(
                                  Icons.calendar_today,
                                  size: textSizeMedium,
                                ),
                                text: dateFormatter(dataKegiatan.tanggal),
                                textStyle: primaryTextStyle(
                                    size: textSizeSMedium.toInt()),
                              ),
                              TextIcon(
                                prefix: Icon(
                                  Icons.access_time,
                                  size: textSizeMedium,
                                ),
                                text: timeFormatter(dataKegiatan.tanggal),
                                textStyle: primaryTextStyle(
                                    size: textSizeSMedium.toInt()),
                              ),
                            ],
                          )
                        : SizedBox(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          isFull.value = !isFull.value;
                          print(dataKegiatan.tanggal);
                        },
                        child: TextIcon(
                          text: "view ${isFull.value ? 'less' : 'more'}",
                          textStyle:
                              primaryTextStyle(size: textSizeSMedium.toInt()),
                          suffix: Icon(isFull.value
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
