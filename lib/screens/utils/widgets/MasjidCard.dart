import 'package:flutter/material.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import '../../../main.dart';
import '../MKConstant.dart';

class MasjidCard extends StatelessWidget {
  const MasjidCard({
    Key? key,
    required this.dataMasjid,
    required this.width,
  }) : super(key: key);

  final dataMasjid;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0)),
            child: Image.asset(
              dataMasjid.image,
              width: width,
              height: width / 1.77,
              fit: BoxFit.fill,
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text(dataMasjid.nama,
                  textColor: appStore.textPrimaryColor,
                  fontSize: textSizeLargeMedium,
                  fontFamily: fontMedium),
              text(
                dataMasjid.kota,
                textColor: appStore.textSecondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
