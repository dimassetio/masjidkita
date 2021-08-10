import 'package:flutter/material.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import 'package:mosq/screens/utils/MKConstant.dart';

class KegiatanCard extends StatelessWidget {
  const KegiatanCard({
    Key? key,
    required this.width,
    required this.dataKegiatan,
  }) : super(key: key);

  final double width;
  final dataKegiatan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: boxDecoration(
          radius: 16, showShadow: true, bgColor: appStore.scaffoldBackground),
      width: width,
      child: GestureDetector(
        onTap: () => toast("Go To Kegiatan Detail"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.asset(mk_contoh_image,
                  // slider.image,
                  // placeholder: placeholderWidgetFn() as Widget Function(
                  //     BuildContext, String)?,
                  height: 180,
                  width: width,
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text(dataKegiatan.nama,
                      textColor: appStore.textPrimaryColor,
                      fontSize: textSizeLargeMedium,
                      fontFamily: fontMedium),
                  text(mk_long_text, maxLine: 2, fontSize: textSizeSMedium),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: text(
                        "view more",
                        fontSize: textSizeSMedium,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
